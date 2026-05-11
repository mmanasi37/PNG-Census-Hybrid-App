import 'dart:convert';

enum QuestionType {
  text,
  number,
  singleSelect,
  multiSelect,
  date,
  gps,
  image,
  audio,
  repeatGroup,
}

class AnswerOption {
  final String value;
  final Map<String, String> label;

  const AnswerOption({required this.value, required this.label});

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      value: json['value'] as String,
      label: Map<String, String>.from(json['label'] as Map),
    );
  }
}

class SkipCondition {
  final String questionId;

  /// Operators: eq, neq, gt, lt, gte, lte, contains, empty, notEmpty
  final String operator;
  final dynamic value;

  const SkipCondition({
    required this.questionId,
    required this.operator,
    this.value,
  });

  factory SkipCondition.fromJson(Map<String, dynamic> json) {
    return SkipCondition(
      questionId: json['questionId'] as String,
      operator: json['operator'] as String,
      value: json['value'],
    );
  }
}

class ValidationRule {
  /// Types: min, max, minLength, maxLength, regex, required
  final String type;
  final dynamic value;
  final Map<String, String>? message;

  const ValidationRule({required this.type, this.value, this.message});

  factory ValidationRule.fromJson(Map<String, dynamic> json) {
    return ValidationRule(
      type: json['type'] as String,
      value: json['value'],
      message: json['message'] != null
          ? Map<String, String>.from(json['message'] as Map)
          : null,
    );
  }
}

class Question {
  final String id;
  final QuestionType type;
  final Map<String, String> text;
  final Map<String, String>? hint;

  /// Flutter asset path for audio prompt (e.g. assets/audio/q001.mp3)
  final String? audioAsset;
  final List<AnswerOption>? options;

  /// Question is shown only when ALL conditions are satisfied
  final List<SkipCondition>? showWhen;
  final List<ValidationRule>? validations;
  final bool required;

  /// Sub-questions for repeatGroup type
  final List<Question>? repeatGroupQuestions;

  const Question({
    required this.id,
    required this.type,
    required this.text,
    this.hint,
    this.audioAsset,
    this.options,
    this.showWhen,
    this.validations,
    this.required = false,
    this.repeatGroupQuestions,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = QuestionType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => QuestionType.text,
    );

    return Question(
      id: json['id'] as String,
      type: type,
      text: Map<String, String>.from(json['text'] as Map),
      hint: json['hint'] != null
          ? Map<String, String>.from(json['hint'] as Map)
          : null,
      audioAsset: json['audioAsset'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((o) => AnswerOption.fromJson(o as Map<String, dynamic>))
          .toList(),
      showWhen: (json['showWhen'] as List<dynamic>?)
          ?.map((c) => SkipCondition.fromJson(c as Map<String, dynamic>))
          .toList(),
      validations: (json['validations'] as List<dynamic>?)
          ?.map((v) => ValidationRule.fromJson(v as Map<String, dynamic>))
          .toList(),
      required: json['required'] as bool? ?? false,
      repeatGroupQuestions: (json['repeatGroupQuestions'] as List<dynamic>?)
          ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FormSection {
  final String id;
  final Map<String, String> title;
  final List<Question> questions;

  const FormSection({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory FormSection.fromJson(Map<String, dynamic> json) {
    return FormSection(
      id: json['id'] as String,
      title: Map<String, String>.from(json['title'] as Map),
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FormSchema {
  final String id;
  final String version;
  final Map<String, String> title;
  final List<FormSection> sections;

  const FormSchema({
    required this.id,
    required this.version,
    required this.title,
    required this.sections,
  });

  factory FormSchema.fromJson(Map<String, dynamic> json) {
    return FormSchema(
      id: json['id'] as String,
      version: json['version'] as String,
      title: Map<String, String>.from(json['title'] as Map),
      sections: (json['sections'] as List<dynamic>)
          .map((s) => FormSection.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  factory FormSchema.fromJsonString(String source) {
    return FormSchema.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }

  /// Flat list of all questions across all sections (excludes repeat sub-questions)
  List<Question> get allQuestions =>
      sections.expand((s) => s.questions).toList();

  Question? findQuestion(String id) {
    for (final section in sections) {
      for (final q in section.questions) {
        if (q.id == id) return q;
        if (q.type == QuestionType.repeatGroup) {
          final sub = q.repeatGroupQuestions?.where((r) => r.id == id).firstOrNull;
          if (sub != null) return sub;
        }
      }
    }
    return null;
  }
}
