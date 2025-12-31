import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_notes_app/models/User.dart';
import 'package:smart_notes_app/services/authService.dart' as authService;

class AuthState {
  final User? currentUser;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    User? currentUser,
    bool? isLoading,
    String? errorMessage,
    bool clearCurrentUser = false,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      currentUser: clearCurrentUser ? null : (currentUser ?? this.currentUser),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final user = await authService.login(email, password);
      if (user != null) {
        state = state.copyWith(currentUser: user, isLoading: false);
        return true;
      } else {
        state = state.copyWith(errorMessage: 'Invalid email or password', isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Login failed: $e', isLoading: false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final user = await authService.register(name, email, password);
      if (user != null) {
        state = state.copyWith(currentUser: user, isLoading: false);
        return true;
      } else {
        state = state.copyWith(errorMessage: 'Registration failed', isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Registration failed: $e', isLoading: false);
      return false;
    }
  }

  void logout() {
    state = state.copyWith(clearCurrentUser: true, clearErrorMessage: true);
  }

  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
