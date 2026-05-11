import 'package:flutter/material.dart';

import '../engine/form_engine.dart';
import '../models/form_schema.dart';
import 'question_widget.dart';

class RepeatGroupWidget extends StatelessWidget {
  const RepeatGroupWidget({
    super.key,
    required this.repeatQuestion,
    required this.engine,
    required this.locale,
  });

  final Question repeatQuestion;
  final FormEngine engine;
  final String locale;

  String _t(Map<String, String>? map) =>
      map?[locale] ?? map?['en'] ?? '';

  @override
  Widget build(BuildContext context) {
    final groupId = repeatQuestion.id;
    final subQuestions = repeatQuestion.repeatGroupQuestions ?? [];
    final instances = engine.getRepeatInstances(groupId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Instances ────────────────────────────────────────────────────────
        ...instances.asMap().entries.map((entry) {
          final index = entry.key;
          final instanceAnswers = entry.value;
          return _InstanceCard(
            index: index,
            groupId: groupId,
            subQuestions: subQuestions,
            instanceAnswers: instanceAnswers,
            engine: engine,
            locale: locale,
            onRemove: () => engine.removeRepeatInstance(groupId, index),
          );
        }),

        // ── Add button ────────────────────────────────────────────────────────
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => engine.addRepeatInstance(groupId),
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            instances.isEmpty
                ? 'Add ${_t(repeatQuestion.text)}'
                : 'Add Another ${_t(repeatQuestion.text)}',
          ),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.indigo),
        ),

        if (instances.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _t(repeatQuestion.hint) +
                  (repeatQuestion.hint != null ? '' : ''),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
      ],
    );
  }
}

class _InstanceCard extends StatelessWidget {
  const _InstanceCard({
    required this.index,
    required this.groupId,
    required this.subQuestions,
    required this.instanceAnswers,
    required this.engine,
    required this.locale,
    required this.onRemove,
  });

  final int index;
  final String groupId;
  final List<Question> subQuestions;
  final Map<String, dynamic> instanceAnswers;
  final FormEngine engine;
  final String locale;
  final VoidCallback onRemove;

  String _memberLabel() {
    final name = instanceAnswers['B01']?.toString();
    return name != null && name.isNotEmpty
        ? name
        : 'Member ${index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.indigo.shade100),
      ),
      child: ExpansionTile(
        initiallyExpanded: index == 0,
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: Colors.indigo.shade100,
          child: Text(
            '${index + 1}',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade700),
          ),
        ),
        title: Text(_memberLabel(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
              tooltip: 'Remove',
              onPressed: () => _confirmRemove(context),
              visualDensity: VisualDensity.compact,
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: subQuestions
                  .where((q) =>
                      engine.isVisibleInRepeat(q, instanceAnswers))
                  .map((q) => QuestionWidget(
                        key: ValueKey('$groupId-$index-${q.id}'),
                        question: q,
                        answer: instanceAnswers[q.id],
                        locale: locale,
                        onChanged: (value) => engine.setRepeatAnswer(
                            groupId, index, q.id, value),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRemove(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove member?'),
        content: Text('Remove ${_memberLabel()} from the household roster?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) onRemove();
  }
}
