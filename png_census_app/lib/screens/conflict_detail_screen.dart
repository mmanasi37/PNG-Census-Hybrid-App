import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/form_schema.dart';
import '../models/household_record.dart';
import '../services/isar_service.dart';

class ConflictDetailScreen extends StatelessWidget {
  const ConflictDetailScreen({
    super.key,
    required this.record,
    required this.schema,
  });

  final HouseholdRecord record;
  final FormSchema schema;

  @override
  Widget build(BuildContext context) {
    final answers = _decodeAnswers();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
        title: Text('HH ${record.householdNumber}  —  ${record.village}',
            style: const TextStyle(fontSize: 15)),
        actions: [
          Chip(
            label: const Text('CONFLICT',
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
            backgroundColor: Colors.orange.shade700,
            side: BorderSide.none,
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── Metadata banner ────────────────────────────────────────────────
          _MetaBanner(record: record),

          // ── Answer list ────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final section in schema.sections) ...[
                  _SectionDivider(title: section.title['en'] ?? section.id),
                  for (final q in section.questions)
                    if (q.type == QuestionType.repeatGroup)
                      _RepeatGroupAnswers(
                          question: q,
                          instances: _getRepeatInstances(answers, q.id))
                    else if (answers.containsKey(q.id))
                      _AnswerRow(
                          question: q,
                          answer: answers[q.id],
                          schema: schema),
                ],
              ],
            ),
          ),
        ],
      ),

      // ── Bottom actions ─────────────────────────────────────────────────────
      bottomNavigationBar: _ActionBar(record: record),
    );
  }

  Map<String, dynamic> _decodeAnswers() {
    try {
      if (record.answersJson.isEmpty) return {};
      return jsonDecode(record.answersJson) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  List<Map<String, dynamic>> _getRepeatInstances(
    Map<String, dynamic> answers,
    String groupId,
  ) {
    final raw = answers[groupId];
    if (raw is List) {
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }
}

// ── Metadata banner ────────────────────────────────────────────────────────────

class _MetaBanner extends StatelessWidget {
  const _MetaBanner({required this.record});
  final HouseholdRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        spacing: 16,
        runSpacing: 4,
        children: [
          _Meta(label: 'Province', value: record.province),
          _Meta(label: 'District', value: record.district),
          _Meta(label: 'LLG', value: record.llg),
          _Meta(label: 'Ward', value: record.ward),
          _Meta(label: 'Enumerator', value: record.enumeratorId),
          _Meta(
              label: 'Last Updated',
              value: _fmt(record.updatedAt)),
          if (record.latitude != null)
            _Meta(
                label: 'GPS',
                value:
                    '${record.latitude!.toStringAsFixed(4)}, ${record.longitude!.toStringAsFixed(4)}'),
        ],
      ),
    );
  }

  String _fmt(DateTime t) =>
      '${t.day.toString().padLeft(2, '0')}/'
      '${t.month.toString().padLeft(2, '0')}/${t.year} '
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: Colors.black87),
        children: [
          TextSpan(
              text: '$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black54)),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

// ── Section divider ────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.indigo.shade200)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.indigo.shade600,
                  letterSpacing: 0.4),
            ),
          ),
          Expanded(child: Divider(color: Colors.indigo.shade200)),
        ],
      ),
    );
  }
}

// ── Answer row ─────────────────────────────────────────────────────────────────

class _AnswerRow extends StatelessWidget {
  const _AnswerRow({
    required this.question,
    required this.answer,
    required this.schema,
  });

  final Question question;
  final dynamic answer;
  final FormSchema schema;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question label
          Expanded(
            flex: 4,
            child: Text(
              question.text['en'] ?? question.id,
              style: const TextStyle(
                  fontSize: 13, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 8),
          // Answer value
          Expanded(
            flex: 5,
            child: Text(
              _format(answer),
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _format(dynamic value) {
    if (value == null) return '—';

    switch (question.type) {
      case QuestionType.singleSelect:
        final opt = question.options
            ?.where((o) => o.value == value.toString())
            .firstOrNull;
        return opt?.label['en'] ?? value.toString();

      case QuestionType.multiSelect:
        if (value is! List) return value.toString();
        return value.map((v) {
          final opt = question.options
              ?.where((o) => o.value == v.toString())
              .firstOrNull;
          return opt?.label['en'] ?? v.toString();
        }).join(', ');

      case QuestionType.date:
        try {
          final d = DateTime.parse(value.toString());
          return '${d.day}/${d.month}/${d.year}';
        } catch (_) {
          return value.toString();
        }

      case QuestionType.gps:
        if (value is Map) {
          final lat = (value['lat'] as num?)?.toStringAsFixed(6) ?? '?';
          final lon = (value['lon'] as num?)?.toStringAsFixed(6) ?? '?';
          final acc = (value['accuracy'] as num?)?.toStringAsFixed(1) ?? '?';
          return '$lat, $lon  (±${acc}m)';
        }
        return value.toString();

      case QuestionType.image:
        final path = value.toString();
        if (File(path).existsSync()) return '📷 ${path.split('/').last}';
        return '📷 (file missing)';

      case QuestionType.audio:
        return '🔊 ${value.toString()}';

      case QuestionType.number:
        return value.toString();

      default:
        return value.toString();
    }
  }
}

// ── Repeat group answers ───────────────────────────────────────────────────────

class _RepeatGroupAnswers extends StatelessWidget {
  const _RepeatGroupAnswers({
    required this.question,
    required this.instances,
  });

  final Question question;
  final List<Map<String, dynamic>> instances;

  @override
  Widget build(BuildContext context) {
    if (instances.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instances.asMap().entries.map((e) {
        final index = e.key;
        final inst = e.value;
        final name = inst['B01']?.toString();
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Colors.indigo.shade100),
          ),
          child: ExpansionTile(
            initiallyExpanded: index == 0,
            dense: true,
            leading: CircleAvatar(
              radius: 13,
              backgroundColor: Colors.indigo.shade100,
              child: Text('${index + 1}',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700)),
            ),
            title: Text(
              name != null && name.isNotEmpty
                  ? name
                  : 'Member ${index + 1}',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: (question.repeatGroupQuestions ?? [])
                      .where((q) => inst.containsKey(q.id))
                      .map((q) => _AnswerRow(
                            question: q,
                            answer: inst[q.id],
                            schema: _emptySchema,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Minimal schema stub used for sub-question rendering
  static final _emptySchema = FormSchema(
      id: '', version: '', title: const {}, sections: const []);
}

// ── Bottom action bar ──────────────────────────────────────────────────────────

class _ActionBar extends StatefulWidget {
  const _ActionBar({required this.record});
  final HouseholdRecord record;

  @override
  State<_ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<_ActionBar> {
  bool _busy = false;

  Future<void> _approve() async {
    setState(() => _busy = true);
    await IsarService.instance.markComplete(
        widget.record.uuid, 'supervisor');
    if (mounted) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Approved and queued for sync'),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _returnToDraft() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Return to Draft?'),
        content: const Text(
            'The enumerator will need to re-complete and re-submit this household.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Return to Draft')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    widget.record.status = RecordStatus.draft.value;
    await IsarService.instance.save(widget.record);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
          ],
        ),
        child: Row(
          children: [
            OutlinedButton.icon(
              onPressed: _busy ? null : _returnToDraft,
              icon: const Icon(Icons.undo, size: 18),
              label: const Text('Return to Draft'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _busy ? null : _approve,
              icon: _busy
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.check, size: 18),
              label: const Text('Approve & Submit'),
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
