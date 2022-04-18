import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';

class SignInManager {
  SignInManager({required this.auth, required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User?> _signIn(
      {required Future<User?> Function() signInMethod}) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
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
