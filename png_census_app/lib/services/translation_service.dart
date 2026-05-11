import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// ── Static glossary (EN → TPI) ─────────────────────────────────────────────────

const _kGlossary = <String, String>{
  // ── Administrative ────────────────────────────────
  'Province': 'Provins',
  'District': 'Distrik',
  'Local Level Government': 'Lokel Lefel Gavman',
  'Ward': 'Wod',
  'Village': 'Ples',
  'Town': 'Taun',
  'Census Unit': 'Sensas Yunet',
  'Household': 'Haus',
  'Household Number': 'Namba bilong Haus',
  'Head of Household': 'Het bilong Haus',
  'Enumerator': 'Man bilong Kauntim',
  'Supervisor': 'Supavaisa',
  'Census': 'Sensas',
  'National': 'Nesen',

  // ── Personal ───────────────────────────────────────
  'Name': 'Nem',
  'Full Name': 'Ful Nem',
  'Sex': 'Seks',
  'Male': 'Man',
  'Female': 'Meri',
  'Age': 'Ais',
  'Date of Birth': 'De bilong Bon',
  'Citizenship': 'Sitisenship',
  'Citizen': 'Sitisen',
  'Relationship': 'Wanem samting yu stap',
  'Spouse': 'Wantain',
  'Partner': 'Paten',
  'Child': 'Pikinini',
  'Son': 'Pikinini Man',
  'Daughter': 'Pikinini Meri',
  'Parent': 'Papa o Mama',
  'Father': 'Papa',
  'Mother': 'Mama',
  'Brother': 'Brata',
  'Sister': 'Susa',
  'Grandchild': 'Tumbuna Pikinini',
  'Relative': 'Wantok',

  // ── Marital status ─────────────────────────────────
  'Married': 'Marit',
  'Single': 'Marit i no gat',
  'Divorced': 'Divois',
  'Widowed': 'Wido',
  'Separated': 'Brukim marit',

  // ── Religion ───────────────────────────────────────
  'Religion': 'Lotu',
  'Catholic': 'Katolik',
  'Lutheran': 'Luteran',
  'Church': 'Sios',

  // ── Education ──────────────────────────────────────
  'Education': 'Edukesen',
  'School': 'Skul',
  'Primary': 'Praimeri',
  'Secondary': 'Sekenderi',
  'University': 'Yunivesiti',
  'Literate': 'Inap ritim na raitim',
  'Read': 'Ritim',
  'Write': 'Raitim',
  'Grade': 'Gret',
  'Level': 'Lefel',
  'Attended': 'Bin go',
  'Never attended': 'I no bin go skul',

  // ── Employment ─────────────────────────────────────
  'Employment': 'Wok',
  'Employed': 'Wok i gat',
  'Unemployed': 'Wok i no gat',
  'Farmer': 'Gaden man',
  'Farming': 'Gaden wok',
  'Fisherman': 'Man bilong pissim fis',
  'Occupation': 'Wanem kain wok',
  'Industry': 'Bisnis',
  'Salary': 'Sala',
  'Wage': 'Pe',
  'Subsistence': 'Kaikai bilong yet',

  // ── Housing ────────────────────────────────────────
  'House': 'Haus',
  'Dwelling': 'Haus stap',
  'Room': 'Rum',
  'Floor': 'Flo',
  'Wall': 'Banis',
  'Roof': 'Rup',
  'Water': 'Wara',
  'Toilet': 'Haus pekpek',
  'Electricity': 'Elektrisiti',
  'Solar': 'Sol',
  'Generator': 'Jenereta',
  'Fuel': 'Fil',
  'Lighting': 'Lait',
  'Cooking': 'Kukim kaikai',
  'Firewood': 'Paiawut',
  'Kerosene': 'Kerosin',
  'Urban': 'Taun',
  'Rural': 'Ples busk',

  // ── GPS / Location ─────────────────────────────────
  'Location': 'Ples',
  'GPS': 'GPS',
  'Latitude': 'Latitjud',
  'Longitude': 'Lonjitjud',
  'Accuracy': 'Stret ples',

  // ── Status / Response ──────────────────────────────
  'Yes': 'Yes',
  'No': 'Nogat',
  'Unknown': 'I no save',
  'Other': 'Narapela',
  'None': 'I no gat',
  'Not applicable': 'I no kamap long em',

  // ── UI actions ─────────────────────────────────────
  'Save': 'Seivim',
  'Submit': 'Salim',
  'Cancel': 'Kansel',
  'Next': 'Nekis',
  'Previous': 'Bipo',
  'Add': 'Putim',
  'Remove': 'Rausim',
  'Edit': 'Senisim',
  'Delete': 'Rausim olgeta',
  'Search': 'Painim',
  'Select': 'Makim',
  'Done': 'Pinis',
  'Back': 'Go bek',
  'Close': 'Pasim',

  // ── Validation ─────────────────────────────────────
  'Required': 'Mas pildim',
  'Invalid': 'I no stret',
  'Error': 'Bagarap',
  'Please fix all errors': 'Stretim olgeta bagarap pastaim',
  'Draft saved': 'Draf i seivim',
  'Submitted': 'I salim pinis',
};

// ── Translation service ────────────────────────────────────────────────────────

class TranslationService {
  TranslationService._();
  static final instance = TranslationService._();

  String _apiKey = '';
  final Map<String, String> _cache = {};
  bool _cacheLoaded = false;

  void configure({required String apiKey}) => _apiKey = apiKey;

  bool get hasApiKey => _apiKey.isNotEmpty;

  /// Translates [text] from [from] locale to [to] locale.
  /// Falls through: glossary → file cache → Claude API → original text.
  Future<String> translate(
    String text, {
    String from = 'en',
    String to = 'tpi',
  }) async {
    if (text.trim().isEmpty || from == to) return text;

    // 1. Glossary
    final g = _glossaryLookup(text, from: from, to: to);
    if (g != null) return g;

    // 2. File cache
    await _ensureCacheLoaded();
    final key = '$from:$to:${text.trim()}';
    if (_cache.containsKey(key)) return _cache[key]!;

    // 3. Claude API
    if (!hasApiKey) return text;
    try {
      final result = await _translateWithClaude(text, from: from, to: to);
      _cache[key] = result;
      unawaited(_saveCache());
      return result;
    } catch (_) {
      return text;
    }
  }

  /// Translates multiple strings in a single API call where possible.
  Future<Map<String, String>> batchTranslate(
    List<String> texts, {
    String from = 'en',
    String to = 'tpi',
  }) async {
    final results = <String, String>{};
    // Identify cache misses first
    final misses = <String>[];
    await _ensureCacheLoaded();
    for (final text in texts) {
      if (text.trim().isEmpty || from == to) {
        results[text] = text;
        continue;
      }
      final g = _glossaryLookup(text, from: from, to: to);
      if (g != null) {
        results[text] = g;
        continue;
      }
      final key = '$from:$to:${text.trim()}';
      if (_cache.containsKey(key)) {
        results[text] = _cache[key]!;
      } else {
        misses.add(text);
      }
    }

    if (misses.isEmpty || !hasApiKey) {
      for (final m in misses) {
        results[m] = m;
      }
      return results;
    }

    // Translate all misses in one API call
    try {
      final combined = misses.asMap().entries
          .map((e) => '${e.key + 1}. ${e.value}')
          .join('\n');
      final raw = await _translateWithClaude(combined, from: from, to: to);
      final lines = raw.split('\n');
      for (var i = 0; i < misses.length && i < lines.length; i++) {
        final line = lines[i].replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
        if (line.isNotEmpty) {
          results[misses[i]] = line;
          _cache['$from:$to:${misses[i].trim()}'] = line;
        } else {
          results[misses[i]] = misses[i];
        }
      }
      unawaited(_saveCache());
    } catch (_) {
      for (final m in misses) {
        results[m] = m;
      }
    }
    return results;
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  String? _glossaryLookup(String text, {required String from, required String to}) {
    if (from == 'en' && to == 'tpi') {
      final exact = _kGlossary[text];
      if (exact != null) return exact;
      final lower = text.toLowerCase();
      for (final e in _kGlossary.entries) {
        if (e.key.toLowerCase() == lower) return e.value;
      }
    } else if (from == 'tpi' && to == 'en') {
      for (final e in _kGlossary.entries) {
        if (e.value == text || e.value.toLowerCase() == text.toLowerCase()) {
          return e.key;
        }
      }
    }
    return null;
  }

  Future<String> _translateWithClaude(
    String text, {
    required String from,
    required String to,
  }) async {
    final fromName = from == 'en' ? 'English' : 'Tok Pisin';
    final toName = to == 'tpi' ? 'Tok Pisin' : 'English';

    final resp = await http
        .post(
          Uri.parse('https://api.anthropic.com/v1/messages'),
          headers: {
            'x-api-key': _apiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
            'anthropic-beta': 'prompt-caching-2024-07-31',
          },
          body: jsonEncode({
            'model': 'claude-haiku-4-5-20251001',
            'max_tokens': 1024,
            'system': [
              {
                'type': 'text',
                'text': _kSystemPrompt,
                'cache_control': {'type': 'ephemeral'},
              }
            ],
            'messages': [
              {
                'role': 'user',
                'content':
                    'Translate from $fromName to $toName:\n\n$text\n\nReturn only the translated text.',
              }
            ],
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (resp.statusCode != 200) {
      throw Exception('Claude API ${resp.statusCode}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final content = (data['content'] as List<dynamic>).first as Map<String, dynamic>;
    return (content['text'] as String)
        .trim()
        .replaceAll(RegExp(r'^"+|"+$'), '');
  }

  Future<void> _ensureCacheLoaded() async {
    if (_cacheLoaded) return;
    _cacheLoaded = true;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/.census_translations.json');
      if (!f.existsSync()) return;
      final data = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      _cache.addAll(data.cast<String, String>());
    } catch (_) {}
  }

  Future<void> _saveCache() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      await File('${dir.path}/.census_translations.json')
          .writeAsString(jsonEncode(_cache));
    } catch (_) {}
  }
}

// Runs the future without awaiting it — needed for fire-and-forget cache saves.
void unawaited(Future<void> future) {
  future.ignore();
}

// ── System prompt (cached by Claude API across calls) ──────────────────────────

const _kSystemPrompt = '''
You are a professional translator for the Papua New Guinea National Population and Housing Census 2025, specialising in translations between English and Tok Pisin (TPI).

Tok Pisin is a creole lingua franca spoken by most of PNG's population. It draws vocabulary primarily from English, with German and Austronesian influences, and has its own distinct grammar and orthography.

## Translation rules
- Produce natural, idiomatic Tok Pisin appropriate for rural PNG communities
- Keep proper nouns (people's names, province names, village names) unchanged
- Keep numeric codes, percentages, and ISO dates unchanged
- Use official Tok Pisin terminology for government and census concepts
- Use standard Tok Pisin orthography (no hyphens in compound words unless conventional)
- Do NOT add explanations, commentary, parentheses, or quotation marks
- Return ONLY the translated text — nothing else

## Key census vocabulary (EN → TPI)
Province → Provins | District → Distrik | Village → Ples | Town → Taun
Household → Haus | Head of Household → Het bilong Haus
Male → Man | Female → Meri | Age → Ais
Married → Marit | Divorced → Divois | Widowed → Wido
School → Skul | Education → Edukesen | Employed → Wok i gat
Unemployed → Wok i no gat | Farmer → Gaden man
Water → Wara | Electricity → Elektrisiti | Toilet → Haus pekpek
Yes → Yes | No → Nogat | Unknown → I no save | Other → Narapela
Required → Mas pildim | Error → Bagarap
Save → Seivim | Submit → Salim | Next → Nekis | Back → Go bek
Census → Sensas | Enumerator → Man bilong Kauntim
National Capital District → Nesen Kepitel Distrik
''';
