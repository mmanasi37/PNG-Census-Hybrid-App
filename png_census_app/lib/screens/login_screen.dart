import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/wia_logo.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();

  bool _loading = false;
  String? _error;
  bool _pinVisible = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final result = await AuthService.instance.login(
      _usernameCtrl.text,
      _pinCtrl.text,
    );
    if (!mounted) return;
    if (result.ok) return;
    setState(() { _loading = false; _error = result.error; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: Column(
        children: [
          // ── Top hero (40%) ─────────────────────────────────────────────
          Expanded(
            flex: 40,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navyDark, AppColors.primaryDim],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const WiaLogo(size: 68),
                    const SizedBox(height: 18),
                    Text(
                      'WIA',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryContainer,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 120,
                      height: 1,
                      color: AppColors.primaryContainer.withAlpha(100),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'CENSUS 2026',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryContainer,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Field Enumeration System',
                      style: GoogleFonts.inter(
                        color: Colors.white.withAlpha(140),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom card (60%) ──────────────────────────────────────────
          Expanded(
            flex: 60,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Sign In',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navyDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Enter your credentials to continue',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Username
                      TextFormField(
                        controller: _usernameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person_outline,
                              color: AppColors.onSurfaceVariant),
                        ),
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // PIN
                      TextFormField(
                        controller: _pinCtrl,
                        decoration: InputDecoration(
                          labelText: 'PIN',
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        obscureText: !_pinVisible,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _login(),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v.length < 4) return 'Min 4 digits';
                          return null;
                        },
                      ),

                      // Error alert
                      if (_error != null) ...[
                        const SizedBox(height: 14),
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
                      const SizedBox(height: 24),

                      // Sign In button
                      FilledButton(
                        onPressed: _loading ? null : _login,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white))
                            : const Text('Sign In'),
                      ),
                      const SizedBox(height: 20),

                      // Divider + Register
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('or',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant)),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New to this device?',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const RegistrationScreen()),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8),
                            ),
                            child: Text(
                              'Register',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
