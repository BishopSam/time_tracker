import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';

class SignInBloc {
  SignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn({required Future<User?> Function() signInMethod}) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async =>
      await _signIn(signInMethod: auth.signInAnonymously);

  Future<User?> signInWithGoogle() async =>
      await _signIn(signInMethod: auth.signInWithGoogle);

  Future<User?> signInWithFacebook() async =>
      await _signIn(signInMethod: auth.signInWithFacebook);
}
