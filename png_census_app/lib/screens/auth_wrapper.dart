import 'package:flutter/material.dart';

import '../models/form_schema.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'enumerator_dashboard.dart';
import 'login_screen.dart';
import 'supervisor_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key, required this.schema});

  final FormSchema schema;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final user = AuthService.instance.currentUser;

        if (user == null) return const LoginScreen();

        return switch (user.role) {
          UserRole.supervisor => SupervisorScreen(schema: schema),
          UserRole.enumerator => EnumeratorDashboard(schema: schema),
        };
      },
    );
  }
}
