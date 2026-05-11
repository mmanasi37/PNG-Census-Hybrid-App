import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _kUsers = 'census_users';
  static const _kSession = 'census_session';

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString(_kSession);
    if (sessionId == null) return;
    final users = await _loadUsers(prefs);
    _currentUser = users.where((u) => u.id == sessionId).firstOrNull;
    notifyListeners();
  }

  Future<AuthResult> login(String username, String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _loadUsers(prefs);
    final match = users.where((u) => u.username.toLowerCase() == username.trim().toLowerCase()).firstOrNull;
    if (match == null) return AuthResult.failure('Username not found.');
    if (match.pinHash != _hash(pin)) return AuthResult.failure('Incorrect PIN.');
    await prefs.setString(_kSession, match.id);
    _currentUser = match;
    notifyListeners();
    return AuthResult.success(match);
  }

  Future<AuthResult> register({
    required String username,
    required String pin,
    required String fullName,
    required UserRole role,
    required String province,
    required String district,
    String? supervisorCode,
  }) async {
    if (role == UserRole.supervisor && supervisorCode != 'CENSUS2025') {
      return AuthResult.failure('Invalid supervisor access code.');
    }

    final prefs = await SharedPreferences.getInstance();
    final users = await _loadUsers(prefs);
    if (users.any((u) => u.username.toLowerCase() == username.trim().toLowerCase())) {
      return AuthResult.failure('Username already taken.');
    }

    final user = UserModel(
      id: _uuid(),
      username: username.trim(),
      pinHash: _hash(pin),
      role: role,
      fullName: fullName.trim(),
      province: province,
      district: district.trim(),
      createdAt: DateTime.now(),
    );

    users.add(user);
    await prefs.setString(_kUsers, UserModel.listToJson(users));
    await prefs.setString(_kSession, user.id);
    _currentUser = user;
    notifyListeners();
    return AuthResult.success(user);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSession);
    _currentUser = null;
    notifyListeners();
  }

  Future<List<UserModel>> _loadUsers(SharedPreferences prefs) {
    final raw = prefs.getString(_kUsers) ?? '';
    return Future.value(UserModel.listFromJson(raw));
  }

  static String _hash(String pin) =>
      sha256.convert(utf8.encode(pin)).toString();

  static String _uuid() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}'
        '-${hex.substring(12, 16)}-${hex.substring(16, 20)}'
        '-${hex.substring(20)}';
  }
}

class AuthResult {
  final bool ok;
  final String? error;
  final UserModel? user;

  const AuthResult._({required this.ok, this.error, this.user});

  factory AuthResult.success(UserModel user) =>
      AuthResult._(ok: true, user: user);
  factory AuthResult.failure(String error) =>
      AuthResult._(ok: false, error: error);
}
