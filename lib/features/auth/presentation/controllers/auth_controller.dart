import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:electronics_shop/features/auth/domain/usecases/usecase_providers.dart';
import 'package:electronics_shop/features/profile/data/models/user_model.dart';
import 'package:electronics_shop/core/services/analytics_service.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserModel?> build() async {
    final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    return await getCurrentUser();
  }

  UserModel? get currentUser => state.value;
  bool get isLoggedIn => state.value != null;
  bool get isLoading => state.isLoading;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final login = ref.read(loginUseCaseProvider);
      final user = await login(email: email, password: password);
      if (user != null) {
        ref.read(analyticsServiceProvider).logLogin(method: 'email');
        ref.read(analyticsServiceProvider).setUserId(user.id.toString());
      }
      return user;
    });
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final register = ref.read(registerUseCaseProvider);
      final user = await register(email: email, password: password, name: name ?? "");
      if (user != null) {
        ref.read(analyticsServiceProvider).logSignUp(method: 'email');
        ref.read(analyticsServiceProvider).setUserId(user.id.toString());
      }
      return user;
    });
  }

  Future<void> signInWithGoogle() async {
    // This logic should be expanded to use a GoogleSignInUseCase
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final logout = ref.read(logoutUseCaseProvider);
      await logout();
      ref.read(analyticsServiceProvider).setUserId(null);
      return null;
    });
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    if (state.value == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updateProfile = ref.read(updateProfileUseCaseProvider);
      return await updateProfile(
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
      );
    });
  }
}
