import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/form_schema.dart';
import 'screens/auth_wrapper.dart';
import 'services/auth_service.dart';
import 'services/background_sync.dart';
import 'services/isar_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.instance.open();
  await AuthService.instance.init();
  if (Platform.isAndroid || Platform.isIOS) {
    await initBackgroundSync();
  }
  runApp(const CensusApp());
}

class CensusApp extends StatefulWidget {
  const CensusApp({super.key});

  @override
  State<CensusApp> createState() => _CensusAppState();
}

class _CensusAppState extends State<CensusApp> {
  FormSchema? _schema;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSchema();
  }

  Future<void> _loadSchema() async {
    try {
      final json =
          await rootBundle.loadString('assets/schemas/png_census_2025.json');
      setState(() => _schema = FormSchema.fromJsonString(json));
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WIA Census 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                const Text('Failed to load census schema',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _error = null);
                    _loadSchema();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_schema == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading census form…'),
            ],
          ),
        ),
      );
    }

    return AuthWrapper(schema: _schema!);
  }
}
