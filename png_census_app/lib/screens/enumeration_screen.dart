import 'package:flutter/material.dart';

import '../engine/form_engine.dart';
import '../models/form_schema.dart';
import '../models/household_record.dart';
import '../services/isar_service.dart';
import '../widgets/question_widget.dart';
import '../widgets/repeat_group_widget.dart';
import 'supervisor_screen.dart';

class EnumerationScreen extends StatefulWidget {
  const EnumerationScreen({
    super.key,
    required this.schema,
    this.existingRecord,
  });

  final FormSchema schema;
  final HouseholdRecord? existingRecord;

  @override
  State<EnumerationScreen> createState() => _EnumerationScreenState();
}

class _EnumerationScreenState extends State<EnumerationScreen>
    with SingleTickerProviderStateMixin {
  late final FormEngine _engine;
  late final TabController _tabs;
  String? _recordUuid;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _engine = FormEngine(widget.schema);
    _tabs = TabController(
        length: widget.schema.sections.length, vsync: this);
    _tabs.addListener(() => setState(() {}));

    if (widget.existingRecord != null) {
      final rec = widget.existingRecord!;
      _recordUuid = rec.uuid;
      final answers = IsarService.instance.decodeAnswers(rec);
      if (answers.isNotEmpty) _engine.loadAnswers(answers);
    }
  }

  @override
  void dispose() {
    _engine.dispose();
    _tabs.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _saveDraft() async {
    setState(() => _saving = true);
    try {
      final answers = _engine.exportAnswers();
      if (_recordUuid == null) {
        final rec = await IsarService.instance.createDraft(
          enumeratorId: 'enumerator_1',
          supervisorId: 'supervisor_1',
          province: answers['A01']?.toString() ?? '',
          district: answers['A02']?.toString() ?? '',
          llg: answers['A03']?.toString() ?? '',
          ward: answers['A04']?.toString() ?? '',
          village: answers['A06']?.toString() ?? '',
          householdNumber: answers['A08']?.toString() ?? '',
        );
        _recordUuid = rec.uuid;
      }
      await IsarService.instance.updateAnswers(_recordUuid!, answers);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft saved'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submit() async {
    if (!_engine.validateAll()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix all errors before submitting.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await _saveDraft();
    if (_recordUuid != null) {
      await IsarService.instance.markComplete(
          _recordUuid!, 'enumerator_1');
    }
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Form Submitted'),
          content: const Text(
              'Household record marked complete. It will sync when connectivity is available.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context)
                ..pop()
                ..pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _engine,
      builder: (context, _) {
        final sections = widget.schema.sections;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PNG Census 2025',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (_recordUuid != null)
                  Text('HH: $_recordUuid',
                      style: const TextStyle(
                          fontSize: 10, color: Colors.white70)),
              ],
            ),
            actions: [
              // Locale toggle
              TextButton(
                onPressed: _engine.toggleLocale,
                child: Text(
                  _engine.locale.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
              // Save draft
              if (_saving)
                const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white)),
                )
              else
                IconButton(
                  icon: const Icon(Icons.save_outlined),
                  tooltip: 'Save Draft',
                  onPressed: _saveDraft,
                ),
              // Supervisor dashboard
              IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                tooltip: 'Supervisor Dashboard',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SupervisorScreen(schema: widget.schema),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: Column(
                children: [
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _engine.completionPercent,
                            backgroundColor: Colors.indigo.shade300,
                            color: Colors.white,
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(_engine.completionPercent * 100).toInt()}%',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  // Section tabs
                  TabBar(
                    controller: _tabs,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.indigo.shade200,
                    tabs: sections.map((s) {
                      final title = s.title[_engine.locale] ??
                          s.title['en'] ??
                          s.id;
                      final label = title.contains(':')
                          ? title.split(':').last.trim()
                          : title;
                      return Tab(
                        child: Row(
                          children: [
                            if (_engine.isSectionComplete(s))
                              const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Icon(Icons.check_circle,
                                    size: 14, color: Colors.greenAccent),
                              ),
                            Text(label,
                                style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          body: TabBarView(
            controller: _tabs,
            children: sections.map((section) {
              return _SectionBody(
                section: section,
                engine: _engine,
              );
            }).toList(),
          ),

          bottomNavigationBar: _BottomNav(
            isFirst: _tabs.index == 0,
            isLast: _tabs.index == sections.length - 1,
            onPrev: () => _tabs.animateTo(_tabs.index - 1),
            onNext: () => _tabs.animateTo(_tabs.index + 1),
            onSubmit: _submit,
          ),
        );
      },
    );
  }
}

// ── Section body ───────────────────────────────────────────────────────────────

class _SectionBody extends StatelessWidget {
  const _SectionBody({required this.section, required this.engine});

  final FormSection section;
  final FormEngine engine;

  @override
  Widget build(BuildContext context) {
    final visibleQuestions = section.questions
        .where((q) =>
            q.type == QuestionType.repeatGroup || engine.isVisible(q))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: visibleQuestions.length,
      itemBuilder: (context, i) {
        final q = visibleQuestions[i];
        if (q.type == QuestionType.repeatGroup) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RepeatGroupWidget(
              repeatQuestion: q,
              engine: engine,
              locale: engine.locale,
            ),
          );
        }
        return QuestionWidget(
          key: ValueKey(q.id),
          question: q,
          answer: engine.getAnswer(q.id),
          error: engine.getError(q.id),
          locale: engine.locale,
          onChanged: (value) => engine.setAnswer(q.id, value),
        );
      },
    );
  }
}

// ── Bottom nav ─────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.isFirst,
    required this.isLast,
    required this.onPrev,
    required this.onNext,
    required this.onSubmit,
  });

  final bool isFirst;
  final bool isLast;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, -2))
          ],
        ),
        child: Row(
          children: [
            if (!isFirst)
              OutlinedButton.icon(
                onPressed: onPrev,
                icon: const Icon(Icons.chevron_left, size: 18),
                label: const Text('Previous'),
              ),
            const Spacer(),
            if (!isLast)
              ElevatedButton.icon(
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right, size: 18),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white),
              )
            else
              ElevatedButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
