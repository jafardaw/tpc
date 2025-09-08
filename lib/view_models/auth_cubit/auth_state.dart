abstract class AuthState {}
class AuthInitial extends AuthState{}
class Loading extends AuthState {}
class LoginSucces extends AuthState {}
class LoginError extends AuthState {
  final String error;
  LoginError({required this.error});
}
class SignUpSucces extends AuthState{}
class SignUpError extends AuthState{
  final String error;
  SignUpError({required this.error});
  }


