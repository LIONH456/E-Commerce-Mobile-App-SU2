import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/local_network.dart';
import '../../data/models/user_profile.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  static final RegExp _gmailRegex = RegExp(
    r'^[\w\.\-]+@gmail\.com$',
    caseSensitive: false,
  );
  static const List<UserProfile> _seedUsers = [
    UserProfile(
      username: 'user1',
      email: 'user1@gmail.com',
      password: 'User123!',
      address: 'Demo Street 01',
    ),
    UserProfile(
      username: 'user2',
      email: 'user2@gmail.com',
      password: 'User123!',
      address: 'Setec University Campus',
    ),
  ];

  Future<void> loadUser() async {
    final stored = CachedHelper.getData(kUserProfile) as String?;
    if (stored == null || stored.isEmpty) {
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
      return;
    }

    try {
      final Map<String, dynamic> map =
          jsonDecode(stored) as Map<String, dynamic>;
      // Check if there's a saved session (has sessionToken and username)
      final username = map['username']?.toString() ?? '';
      final sessionToken = map['sessionToken']?.toString() ?? '';

      if (username.isNotEmpty && sessionToken.isNotEmpty) {
        // Session found: user is authenticated
        final cachedUser = UserProfile(
          username: username,
          email: map['email']?.toString() ?? '',
          password: '', // Session-based: no password in cache
          address: map['address']?.toString(),
        );
        emit(
          state.copyWith(status: AuthStatus.authenticated, user: cachedUser),
        );
        return;
      }
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final trimmedUsername = username.trim();
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedUsername.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: 'Username is required',
        ),
      );
      return;
    }

    if (!_gmailRegex.hasMatch(trimmedEmail)) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: 'Please enter a valid Gmail address',
        ),
      );
      return;
    }

    if (trimmedPassword.length < 8) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: 'Password must be at least 8 characters long',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final profile = UserProfile(
      username: trimmedUsername,
      email: trimmedEmail,
      password: trimmedPassword,
    );

    // Save session without storing plaintext password
    final session = {
      'username': profile.username,
      'email': profile.email,
      'address': profile.address,
      'sessionToken': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    await CachedHelper.saveData(kUserProfile, jsonEncode(session));

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: profile,
        message: null,
      ),
    );
  }

  Future<void> login({
    required String identifier,
    required String password,
    bool remember = true,
  }) async {
    final trimmedIdentifier = identifier.trim().toLowerCase();
    final trimmedPassword = password.trim();

    UserProfile? matchedUser;
    // Try to authenticate against seed users
    matchedUser = _seedUsers.firstWhere(
      (seed) =>
          trimmedPassword == seed.password &&
          (trimmedIdentifier == seed.username.toLowerCase() ||
              trimmedIdentifier == seed.email.toLowerCase()),
      orElse: () => const UserProfile(username: '', email: '', password: ''),
    );

    if (matchedUser.username.isNotEmpty) {
      // Always save session when login is successful
      // (remember flag kept for UI but session always persists until logout)
      final session = {
        'username': matchedUser.username,
        'email': matchedUser.email,
        'address': matchedUser.address,
        'sessionToken': DateTime.now().millisecondsSinceEpoch.toString(),
      };
      await CachedHelper.saveData(kUserProfile, jsonEncode(session));

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: matchedUser,
          message: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message:
              'Invalid credentials. Try user1@gmail.com / User123! or register a new account.',
        ),
      );
    }
  }

  Future<void> updateProfile({
    required String username,
    required String email,
    String? address,
    String? password,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    if (username.trim().isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: 'Username is required',
        ),
      );
      return;
    }

    if (!_gmailRegex.hasMatch(email.trim())) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: 'Please enter a valid Gmail address',
        ),
      );
      return;
    }

    if (password != null && password.isNotEmpty && password.length < 8) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: 'Password must be at least 8 characters long',
        ),
      );
      return;
    }

    final updatedUser = currentUser.copyWith(
      username: username.trim(),
      email: email.trim(),
      address: address?.trim(),
      password: (password != null && password.isNotEmpty)
          ? password.trim()
          : currentUser.password,
    );

    // Update stored session but do not include password
    final session = {
      'username': updatedUser.username,
      'email': updatedUser.email,
      'address': updatedUser.address,
      'sessionToken': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    await CachedHelper.saveData(kUserProfile, jsonEncode(session));

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedUser,
        message: null,
      ),
    );
  }

  Future<void> logout() async {
    await CachedHelper.removeData(kUserProfile);
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        message: null,
      ),
    );
  }
}
