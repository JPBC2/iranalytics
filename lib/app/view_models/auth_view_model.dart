import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../providers/auth_providers.dart';

// Using Riverpod 3.x AsyncNotifier instead of StateNotifier
class AuthViewModel extends AsyncNotifier<void> {
  late AuthService _authService;

  @override
  Future<void> build() async {
    _authService = ref.watch(authServiceProvider);
    return;
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signInWithGoogle();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('Sign in error: $error');
      }
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('Sign out error: $error');
      }
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      await _authService.deleteAccount();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('Delete account error: $error');
      }
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Auth view model provider using AsyncNotifierProvider
final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, void>(() {
  return AuthViewModel();
});
