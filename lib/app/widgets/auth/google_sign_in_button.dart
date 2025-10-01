import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_models/auth_view_model.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: authState.isLoading
            ? null
            : () => ref.read(authViewModelProvider.notifier).signInWithGoogle(),
        icon: authState.isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Image.asset(
          'assets/images/google_logo.png', // You'll need to add this
          height: 24,
          width: 24,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.login, size: 24),
        ),
        label: Text(
          authState.isLoading ? 'Signing in...' : 'Sign in with Google',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[800],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ),
    );
  }
}
