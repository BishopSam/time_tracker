import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier
 {
  EmailSignInChangeModel( 
      {
      required this.auth,
      this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});
 final AuthBase auth;
 String email;
 String password;
 EmailSignInFormType formType;
 bool isLoading;
 bool submitted;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create account';
  }

  
  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailandPassword(email,password);
      } else {
        await auth.createUserWithEmailandPassword(
            email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }


  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
        email: '',
        password: '',
        isLoading: false,
        submitted: false,
        formType: formType);
  }

   void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidPasswordText : null;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordText : null;
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
      this.email = email ?? this.email;
      this.password = password ?? this.password;
      this.formType= formType ?? this.formType;
      this.isLoading = isLoading ?? this.isLoading;
      this.submitted = submitted ?? this.submitted;
      notifyListeners();
    
  }
}
