import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_dialog.dart';

enum EmailSignInFormType { signIn, register }

class EmailSiginInForm extends StatefulWidget with EmailAndPasswordValidators {
  @override
  State<EmailSiginInForm> createState() => _EmailSiginInFormState();
}

class _EmailSiginInFormState extends State<EmailSiginInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? 'Sign In' : 'Create account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    return [
      _buildEmailTextField(),
      SizedBox(height: 8),
      _buildPasswordTextField(),
      SizedBox(height: 8),
      FormSubmitButton(
          onPressed: submitEnabled ? _submit : null, text: primaryText),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(
          secondaryText,
          style: TextStyle(color: Colors.black87),
        ),
      )
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
        focusNode: _emailFocusNode,
        controller: _emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        onEditingComplete: _emailEditingComplete,
        decoration: InputDecoration(
            labelText: 'Email',
            enabled: _isLoading == false,
            hintText: 'test@test.com',
            errorText: showErrorText ? widget.invalidEmailText : null),
        onChanged: (email) => setState(() {}));
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        decoration: InputDecoration(
            labelText: 'Password',
            enabled: _isLoading == false,
            errorText: showErrorText ? widget.invalidPasswordText : null),
        obscureText: true,
        onEditingComplete: _submit,
        onChanged: (email) => setState(() {}));
  }

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailandPassword(_email, _password);
      } else {
        await auth.createUserWithEmailandPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign In Failed', exception: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(),
        ),
      ),
    );
  }
}
