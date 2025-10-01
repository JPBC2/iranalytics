import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../providers/auth_providers.dart';

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  AuthViewModel(this._authService) : super(const AsyncValue.data(null));

  final AuthService _authService;

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

// Auth view model provider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthViewModel(authService);
});
