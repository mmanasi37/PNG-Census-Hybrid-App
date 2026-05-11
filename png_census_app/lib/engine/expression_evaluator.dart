import '../models/form_schema.dart';

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult.ok() : isValid = true, errorMessage = null;
  const ValidationResult.error(String message)
      : isValid = false,
        errorMessage = message;
}

class ExpressionEvaluator {
  /// Returns true when [question] should be displayed given [answers].
  /// A question with no showWhen conditions is always visible.
  bool isVisible(Question question, Map<String, dynamic> answers) {
    final conditions = question.showWhen;
    if (conditions == null || conditions.isEmpty) return true;
    return conditions.every((c) => _evaluate(c, answers));
  }

  bool _evaluate(SkipCondition cond, Map<String, dynamic> answers) {
    final answer = answers[cond.questionId];
    switch (cond.operator) {
      case 'eq':
        return _eq(answer, cond.value);
      case 'neq':
        return !_eq(answer, cond.value);
      case 'gt':
        return _cmp(answer, cond.value) > 0;
      case 'lt':
        return _cmp(answer, cond.value) < 0;
      case 'gte':
        return _cmp(answer, cond.value) >= 0;
      case 'lte':
        return _cmp(answer, cond.value) <= 0;
      case 'contains':
        return _contains(answer, cond.value);
      case 'empty':
        return _blank(answer);
      case 'notEmpty':
        return !_blank(answer);
      default:
        return true;
    }
  }

  bool _eq(dynamic a, dynamic b) {
    if (a is List) return a.contains(b?.toString());
    return a?.toString() == b?.toString();
  }

  int _cmp(dynamic a, dynamic b) {
    final an = num.tryParse(a?.toString() ?? '');
    final bn = num.tryParse(b?.toString() ?? '');
    if (an != null && bn != null) return an.compareTo(bn);
    return (a?.toString() ?? '').compareTo(b?.toString() ?? '');
  }

  bool _contains(dynamic a, dynamic b) {
    if (a is List) return a.contains(b?.toString());
    if (a is String && b != null) return a.contains(b.toString());
    return false;
  }

  bool _blank(dynamic a) {
    if (a == null) return true;
    if (a is String) return a.isEmpty;
    if (a is List) return a.isEmpty;
    return false;
  }

  // ── Validation ─────────────────────────────────────────────────────────────

  ValidationResult validate(
    Question question,
    dynamic answer,
    String locale,
  ) {
    // required check
    if (question.required && _blank(answer)) {
      return ValidationResult.error(
        _msg({'en': 'This field is required', 'tpi': 'Dispela hap i mas pildim'}, locale),
      );
    }

    for (final rule in (question.validations ?? [])) {
      final result = _applyRule(rule, answer, locale);
      if (!result.isValid) return result;
    }
    return const ValidationResult.ok();
  }

  ValidationResult _applyRule(ValidationRule rule, dynamic answer, String locale) {
    if (_blank(answer)) return const ValidationResult.ok();

    String err(String fallback) =>
        rule.message != null ? _msg(rule.message!, locale) : fallback;

    switch (rule.type) {
      case 'min':
        final n = num.tryParse(answer.toString());
        final min = num.tryParse(rule.value?.toString() ?? '');
        if (n != null && min != null && n < min) {
          return ValidationResult.error(err('Minimum value is ${rule.value}'));
        }
      case 'max':
        final n = num.tryParse(answer.toString());
        final max = num.tryParse(rule.value?.toString() ?? '');
        if (n != null && max != null && n > max) {
          return ValidationResult.error(err('Maximum value is ${rule.value}'));
        }
      case 'minLength':
        final len = answer is List ? answer.length : answer.toString().length;
        final min = int.tryParse(rule.value?.toString() ?? '') ?? 0;
        if (len < min) {
          return ValidationResult.error(err('Minimum length is $min'));
        }
      case 'maxLength':
        final len = answer is List ? answer.length : answer.toString().length;
        final max = int.tryParse(rule.value?.toString() ?? '') ?? 0;
        if (len > max) {
          return ValidationResult.error(err('Maximum length is $max'));
        }
      case 'regex':
        final pattern = rule.value?.toString() ?? '';
        if (!RegExp(pattern).hasMatch(answer.toString())) {
          return ValidationResult.error(err('Invalid format'));
        }
    }
    return const ValidationResult.ok();
  }

  String _msg(Map<String, String> messages, String locale) =>
      messages[locale] ?? messages['en'] ?? messages.values.first;
}
