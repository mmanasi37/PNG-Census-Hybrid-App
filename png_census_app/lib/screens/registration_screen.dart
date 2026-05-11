import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

const _kProvinces = [
  'Central',
  'Chimbu (Simbu)',
  'East New Britain',
  'East Sepik',
  'Eastern Highlands',
  'Enga',
  'Gulf',
  'Hela',
  'Jiwaka',
  'Madang',
  'Manus',
  'Milne Bay',
  'Morobe',
  'National Capital District',
  'New Ireland',
  'North Solomons (Bougainville)',
  'Northern (Oro)',
  'Southern Highlands',
  'West New Britain',
  'West Sepik (Sandaun)',
  'Western',
  'Western Highlands',
];

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _confirmPinCtrl = TextEditingController();
  final _supCodeCtrl = TextEditingController();

  UserRole _role = UserRole.enumerator;
  String? _province;
  bool _loading = false;
  String? _error;
  bool _pinVisible = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _districtCtrl.dispose();
    _pinCtrl.dispose();
    _confirmPinCtrl.dispose();
    _supCodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final result = await AuthService.instance.register(
      username: _usernameCtrl.text,
      pin: _pinCtrl.text,
      fullName: _nameCtrl.text,
      role: _role,
      province: _province!,
      district: _districtCtrl.text,
      supervisorCode:
          _role == UserRole.supervisor ? _supCodeCtrl.text : null,
    );
    if (!mounted) return;
    if (result.ok) { Navigator.pop(context); return; }
    setState(() { _loading = false; _error = result.error; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Create Account',
          style: GoogleFonts.plusJakartaSans(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Role toggle ────────────────────────────────────────
                  _FieldLabel('Account Type'),
                  const SizedBox(height: 8),
                  SegmentedButton<UserRole>(
                    segments: [
                      ButtonSegment(
                        value: UserRole.enumerator,
                        label: Text('Enumerator',
                            style: GoogleFonts.inter(fontSize: 13)),
                        icon: const Icon(Icons.person_outline, size: 18),
                      ),
                      ButtonSegment(
                        value: UserRole.supervisor,
                        label: Text('Supervisor',
                            style: GoogleFonts.inter(fontSize: 13)),
                        icon: const Icon(
                            Icons.admin_panel_settings_outlined,
                            size: 18),
                      ),
                    ],
                    selected: {_role},
                    onSelectionChanged: (s) =>
                        setState(() => _role = s.first),
                  ),
                  const SizedBox(height: 20),

                  // ── Personal info ──────────────────────────────────────
                  _Field(
                    controller: _nameCtrl,
                    label: 'Full Name',
                    icon: Icons.badge_outlined,
                    capitalization: TextCapitalization.words,
                    action: TextInputAction.next,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  _Field(
                    controller: _usernameCtrl,
                    label: 'Username',
                    icon: Icons.person_outline,
                    helper: 'Used to log in — no spaces',
                    action: TextInputAction.next,
                    formatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s'))
                    ],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (v.length < 3) return 'Min 3 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Location ───────────────────────────────────────────
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Province',
                      prefixIcon: Icon(Icons.map_outlined,
                          color: AppColors.onSurfaceVariant),
                    ),
                    isExpanded: true,
                    items: _kProvinces
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(fontSize: 14)),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _province = v),
                    validator: (v) =>
                        v == null ? 'Select a province' : null,
                  ),
                  const SizedBox(height: 14),

                  _Field(
                    controller: _districtCtrl,
                    label: 'District',
                    icon: Icons.location_city_outlined,
                    capitalization: TextCapitalization.words,
                    action: TextInputAction.next,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // ── PIN ────────────────────────────────────────────────
                  TextFormField(
                    controller: _pinCtrl,
                    decoration: InputDecoration(
                      labelText: 'PIN (4–6 digits)',
                      prefixIcon: Icon(Icons.lock_outline,
                          color: AppColors.onSurfaceVariant),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _pinVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.onSurfaceVariant,
                        ),
                        onPressed: () =>
                            setState(() => _pinVisible = !_pinVisible),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: !_pinVisible,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (v.length < 4) return 'Min 4 digits';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _confirmPinCtrl,
                    decoration: InputDecoration(
                      labelText: 'Confirm PIN',
                      prefixIcon: Icon(Icons.lock_outline,
                          color: AppColors.onSurfaceVariant),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: !_pinVisible,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    textInputAction: _role == UserRole.supervisor
                        ? TextInputAction.next
                        : TextInputAction.done,
                    onFieldSubmitted: _role == UserRole.enumerator
                        ? (_) => _register()
                        : null,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (v != _pinCtrl.text) return 'PINs do not match';
                      return null;
                    },
                  ),

                  // ── Supervisor code ────────────────────────────────────
                  if (_role == UserRole.supervisor) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _supCodeCtrl,
                      decoration: InputDecoration(
                        labelText: 'Supervisor Access Code',
                        prefixIcon: Icon(Icons.vpn_key_outlined,
                            color: AppColors.onSurfaceVariant),
                        helperText: 'Provided by the Census Authority',
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _register(),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ],

                  // ── Error alert ────────────────────────────────────────
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.error.withAlpha(80)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              size: 18, color: AppColors.error),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _error!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),

                  FilledButton(
                    onPressed: _loading ? null : _register,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white))
                        : const Text('Create Account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Small helpers ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 0.4,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.helper,
    this.capitalization = TextCapitalization.none,
    this.action = TextInputAction.next,
    this.formatters,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? helper;
  final TextCapitalization capitalization;
  final TextInputAction action;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        prefixIcon:
            Icon(icon, color: AppColors.onSurfaceVariant),
      ),
      textCapitalization: capitalization,
      textInputAction: action,
      autocorrect: false,
      inputFormatters: formatters,
      validator: validator,
    );
  }
}
