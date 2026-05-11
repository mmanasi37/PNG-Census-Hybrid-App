import 'package:flutter/foundation.dart';

import '../models/form_schema.dart';
import 'expression_evaluator.dart';

export 'expression_evaluator.dart' show ValidationResult;

class FormEngine extends ChangeNotifier {
  FormEngine(this.schema, {this.locale = 'en'});

  final FormSchema schema;
  String locale;

  final Map<String, dynamic> _answers = {};

  /// repeat group answers: repeatGroupQuestionId → List of instance answer maps
  final Map<String, List<Map<String, dynamic>>> _repeatAnswers = {};

  final Map<String, String?> _errors = {};
  final ExpressionEvaluator _evaluator = ExpressionEvaluator();

  // ── Locale ─────────────────────────────────────────────────────────────────

  void toggleLocale() {
    locale = locale == 'en' ? 'tpi' : 'en';
    notifyListeners();
  }

  // ── Top-level answers ──────────────────────────────────────────────────────

  dynamic getAnswer(String questionId) => _answers[questionId];

  void setAnswer(String questionId, dynamic value) {
    if (value == null || (value is String && value.isEmpty)) {
      _answers.remove(questionId);
    } else {
      _answers[questionId] = value;
    }
    _errors.remove(questionId);
    _pruneHidden();
    notifyListeners();
  }

  bool isVisible(Question question) =>
      _evaluator.isVisible(question, _answers);

  String? getError(String questionId) => _errors[questionId];

  // ── Repeat groups ──────────────────────────────────────────────────────────

  List<Map<String, dynamic>> getRepeatInstances(String repeatGroupId) =>
      _repeatAnswers[repeatGroupId] ?? const [];

  void addRepeatInstance(String repeatGroupId) {
    (_repeatAnswers[repeatGroupId] ??= []).add({});
    notifyListeners();
  }

  void removeRepeatInstance(String repeatGroupId, int index) {
    _repeatAnswers[repeatGroupId]?.removeAt(index);
    notifyListeners();
  }

  dynamic getRepeatAnswer(String repeatGroupId, int index, String questionId) {
    final instances = _repeatAnswers[repeatGroupId];
    if (instances == null || index >= instances.length) return null;
    return instances[index][questionId];
  }

  void setRepeatAnswer(
    String repeatGroupId,
    int index,
    String questionId,
    dynamic value,
  ) {
    final instances = _repeatAnswers[repeatGroupId] ??= [];
    while (instances.length <= index) {
      instances.add({});
    }
    if (value == null || (value is String && value.isEmpty)) {
      instances[index].remove(questionId);
    } else {
      instances[index][questionId] = value;
    }
    notifyListeners();
  }

  bool isVisibleInRepeat(Question question, Map<String, dynamic> instanceAnswers) =>
      _evaluator.isVisible(question, instanceAnswers);

  // ── Validation ─────────────────────────────────────────────────────────────

  bool validate(Question question) {
    if (!isVisible(question)) return true;
    final result = _evaluator.validate(question, _answers[question.id], locale);
    _errors[question.id] = result.isValid ? null : result.errorMessage;
    notifyListeners();
    return result.isValid;
  }

  bool validateAll() {
    var valid = true;
    for (final q in schema.allQuestions) {
      if (q.type == QuestionType.repeatGroup) continue;
      if (!validate(q)) valid = false;
    }
    return valid;
  }

  bool validateRepeatInstance(
    List<Question> subQuestions,
    int index,
    String repeatGroupId,
  ) {
    final instanceAnswers = getRepeatInstances(repeatGroupId)[index];
    var valid = true;
    for (final q in subQuestions) {
      if (!isVisibleInRepeat(q, instanceAnswers)) continue;
      final result = _evaluator.validate(q, instanceAnswers[q.id], locale);
      if (!result.isValid) valid = false;
    }
    return valid;
  }

  // ── Progress ───────────────────────────────────────────────────────────────

  /// Fraction of visible top-level required questions that have been answered.
  double get completionPercent {
    final required = schema.allQuestions
        .where((q) => q.type != QuestionType.repeatGroup && q.required && isVisible(q))
        .toList();
    if (required.isEmpty) return 1.0;
    final answered = required.where((q) => _answers.containsKey(q.id)).length;
    return answered / required.length;
  }

  bool isSectionComplete(FormSection section) {
    return section.questions
        .where((q) => q.type != QuestionType.repeatGroup && q.required && isVisible(q))
        .every((q) => _answers.containsKey(q.id));
  }

  // ── Import / export ────────────────────────────────────────────────────────

  Map<String, dynamic> exportAnswers() {
    return {
      ..._answers,
      for (final e in _repeatAnswers.entries) e.key: e.value,
    };
  }

  void loadAnswers(Map<String, dynamic> answers) {
    _answers.clear();
    _repeatAnswers.clear();
    for (final entry in answers.entries) {
      if (entry.value is List) {
        final list = entry.value as List<dynamic>;
        if (list.isNotEmpty && list.first is Map) {
          _repeatAnswers[entry.key] =
              list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          continue;
        }
      }
      _answers[entry.key] = entry.value;
    }
    _errors.clear();
    notifyListeners();
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  void _pruneHidden() {
    for (final q in schema.allQuestions) {
      if (q.type == QuestionType.repeatGroup) continue;
      if (!isVisible(q)) {
        _answers.remove(q.id);
        _errors.remove(q.id);
      }
    }
  }
}
