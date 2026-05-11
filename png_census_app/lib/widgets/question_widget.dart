import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/form_schema.dart';
import 'audio_play_button.dart';
import 'gps_capture.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.question,
    required this.answer,
    required this.onChanged,
    required this.locale,
    this.error,
  });

  final Question question;
  final dynamic answer;
  final String? error;
  final ValueChanged<dynamic> onChanged;
  final String locale;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.answer?.toString() ?? '');
  }

  @override
  void didUpdateWidget(QuestionWidget old) {
    super.didUpdateWidget(old);
    final expected = widget.answer?.toString() ?? '';
    if (_ctrl.text != expected) {
      _ctrl.value = _ctrl.value.copyWith(text: expected);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _t(Map<String, String>? map) =>
      map?[widget.locale] ?? map?['en'] ?? '';

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label ────────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (q.required)
                const Text('* ',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  _t(q.text),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (q.hint != null && _t(q.hint).isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(_t(q.hint),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade600)),
          ],
          if (q.audioAsset != null) ...[
            const SizedBox(height: 6),
            AudioPlayButton(assetPath: q.audioAsset!),
          ],
          const SizedBox(height: 8),
          // ── Input ─────────────────────────────────────────────────────────
          _buildInput(context),
          // ── Error ─────────────────────────────────────────────────────────
          if (widget.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(widget.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    switch (widget.question.type) {
      case QuestionType.text:
        return _TextField(ctrl: _ctrl, error: widget.error, onChanged: (v) {
          widget.onChanged(v.isEmpty ? null : v);
        });
      case QuestionType.number:
        return _TextField(
          ctrl: _ctrl,
          error: widget.error,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          onChanged: (v) => widget.onChanged(v.isEmpty ? null : num.tryParse(v)),
        );
      case QuestionType.singleSelect:
        return _buildSingleSelect(context);
      case QuestionType.multiSelect:
        return _buildMultiSelect(context);
      case QuestionType.date:
        return _buildDatePicker(context);
      case QuestionType.gps:
        return GpsCaptureWidget(
          value: widget.answer is Map<String, dynamic>
              ? widget.answer as Map<String, dynamic>
              : null,
          onChanged: widget.onChanged,
        );
      case QuestionType.image:
        return _buildImagePicker(context);
      case QuestionType.audio:
        return AudioPlayButton(assetPath: widget.question.audioAsset ?? '');
      case QuestionType.repeatGroup:
        return const SizedBox.shrink();
    }
  }

  // ── Single select ──────────────────────────────────────────────────────────

  Widget _buildSingleSelect(BuildContext context) {
    final options = widget.question.options ?? [];
    final selected = widget.answer?.toString();

    if (options.length <= 4) {
      return Column(
        children: options
            .map((opt) => _RadioTile(
                  value: opt.value,
                  label: _t(opt.label),
                  selected: selected == opt.value,
                  onTap: () => widget.onChanged(opt.value),
                ))
            .toList(),
      );
    }

    final selectedOpt = options.where((o) => o.value == selected).firstOrNull;
    return _PickerTile(
      displayText: selectedOpt != null ? _t(selectedOpt.label) : null,
      error: widget.error,
      onTap: () async {
        final result = await _showPicker(
          context: context,
          options: options,
          selected: selected != null ? {selected} : const <String>{},
          multiSelect: false,
          title: _t(widget.question.text),
          locale: widget.locale,
        );
        if (result != null && result.isNotEmpty) {
          widget.onChanged(result.first);
        }
      },
    );
  }

  // ── Multi select ───────────────────────────────────────────────────────────

  Widget _buildMultiSelect(BuildContext context) {
    final options = widget.question.options ?? [];
    final selected = (widget.answer as List<dynamic>?)
            ?.map((e) => e.toString())
            .toSet() ??
        {};

    if (options.length <= 6) {
      return Column(
        children: options
            .map((opt) => CheckboxListTile(
                  value: selected.contains(opt.value),
                  title: Text(_t(opt.label), style: const TextStyle(fontSize: 14)),
                  onChanged: (checked) {
                    final next = Set<String>.from(selected);
                    checked == true ? next.add(opt.value) : next.remove(opt.value);
                    widget.onChanged(next.isEmpty ? null : next.toList());
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ))
            .toList(),
      );
    }

    return _PickerTile(
      displayText: selected.isEmpty ? null : '${selected.length} selected',
      error: widget.error,
      onTap: () async {
        final result = await _showPicker(
          context: context,
          options: options,
          selected: selected,
          multiSelect: true,
          title: _t(widget.question.text),
          locale: widget.locale,
        );
        if (result != null) {
          widget.onChanged(result.isEmpty ? null : result.toList());
        }
      },
    );
  }

  // ── Date picker ────────────────────────────────────────────────────────────

  Widget _buildDatePicker(BuildContext context) {
    final dateStr = widget.answer?.toString();
    final parsed = dateStr != null ? DateTime.tryParse(dateStr) : null;
    return _PickerTile(
      icon: Icons.calendar_today,
      displayText: parsed != null
          ? '${parsed.day}/${parsed.month}/${parsed.year}'
          : null,
      placeholder: 'Select date…',
      error: widget.error,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: parsed ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          widget.onChanged(picked.toIso8601String().substring(0, 10));
        }
      },
    );
  }

  // ── Image picker ───────────────────────────────────────────────────────────

  Widget _buildImagePicker(BuildContext context) {
    final path = widget.answer?.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (path != null && File(path).existsSync()) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.file(File(path), height: 140, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt, size: 18),
              label: const Text('Camera'),
              onPressed: () => _pickImage(ImageSource.camera),
              style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.photo_library, size: 18),
              label: const Text('Gallery'),
              onPressed: () => _pickImage(ImageSource.gallery),
              style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await ImagePicker()
        .pickImage(source: source, imageQuality: 80, maxWidth: 1280);
    if (file != null) widget.onChanged(file.path);
  }

  // ── Option picker bottom sheet ─────────────────────────────────────────────

  static Future<Set<String>?> _showPicker({
    required BuildContext context,
    required List<AnswerOption> options,
    required Set<String> selected,
    required bool multiSelect,
    required String title,
    required String locale,
  }) {
    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _OptionSheet(
        options: options,
        selected: selected,
        multiSelect: multiSelect,
        title: title,
        locale: locale,
      ),
    );
  }
}

// ── Shared picker tile ─────────────────────────────────────────────────────────

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.onTap,
    this.displayText,
    this.placeholder = 'Select…',
    this.icon,
    this.error,
  });

  final VoidCallback onTap;
  final String? displayText;
  final String placeholder;
  final IconData? icon;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          border: Border.all(
              color: hasError ? Colors.red : Colors.grey.shade400, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                displayText ?? placeholder,
                style: TextStyle(
                  color: displayText == null ? Colors.grey.shade500 : null,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}

// ── Text field helper ──────────────────────────────────────────────────────────

class _TextField extends StatelessWidget {
  const _TextField({
    required this.ctrl,
    required this.onChanged,
    this.error,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController ctrl;
  final ValueChanged<String> onChanged;
  final String? error;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        errorText: error,
        isDense: true,
      ),
    );
  }
}

// ── Option picker bottom sheet ─────────────────────────────────────────────────

class _OptionSheet extends StatefulWidget {
  const _OptionSheet({
    required this.options,
    required this.selected,
    required this.multiSelect,
    required this.title,
    required this.locale,
  });

  final List<AnswerOption> options;
  final Set<String> selected;
  final bool multiSelect;
  final String title;
  final String locale;

  @override
  State<_OptionSheet> createState() => _OptionSheetState();
}

class _OptionSheetState extends State<_OptionSheet> {
  late Set<String> _current;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _current = Set.from(widget.selected);
  }

  String _label(AnswerOption opt) =>
      opt.label[widget.locale] ?? opt.label['en'] ?? opt.value;

  @override
  Widget build(BuildContext context) {
    final filtered = _filter.isEmpty
        ? widget.options
        : widget.options
            .where((o) =>
                _label(o).toLowerCase().contains(_filter.toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      minChildSize: 0.35,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          // Handle + title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                if (widget.multiSelect)
                  TextButton(
                    onPressed: () => Navigator.pop(context, _current),
                    child: const Text('Done'),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
          // Search
          if (widget.options.length > 7)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                autofocus: false,
                decoration: const InputDecoration(
                  hintText: 'Search…',
                  prefixIcon: Icon(Icons.search, size: 18),
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                ),
                onChanged: (v) => setState(() => _filter = v),
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: scrollCtrl,
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final opt = filtered[i];
                final selected = _current.contains(opt.value);
                if (widget.multiSelect) {
                  return CheckboxListTile(
                    value: selected,
                    title: Text(_label(opt), style: const TextStyle(fontSize: 14)),
                    onChanged: (checked) {
                      setState(() => checked == true
                          ? _current.add(opt.value)
                          : _current.remove(opt.value));
                    },
                    dense: true,
                  );
                }
                return ListTile(
                  title: Text(_label(opt), style: const TextStyle(fontSize: 14)),
                  trailing: selected
                      ? const Icon(Icons.check, color: Colors.indigo)
                      : null,
                  onTap: () => Navigator.pop(context, {opt.value}),
                  dense: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom radio tile (avoids deprecated RadioListTile.groupValue) ─────────────

class _RadioTile extends StatelessWidget {
  const _RadioTile({
    required this.value,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String value;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.indigo : Colors.grey.shade500,
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.indigo,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
