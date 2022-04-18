import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker_flutter_course/app/notify_managers/email_sign_manager.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_dialog.dart';

class EmailSiginInFormCahngeNotifier extends StatefulWidget {
  EmailSiginInFormCahngeNotifier({Key? key, required this.model}) : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSiginInFormCahngeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  State<EmailSiginInFormCahngeNotifier> createState() =>
      _EmailSiginInFormCahngeNotifierState();
}

class _EmailSiginInFormCahngeNotifierState extends State<EmailSiginInFormCahngeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8),
      _buildPasswordTextField(),
      SizedBox(height: 8),
      FormSubmitButton(
          onPressed: model.canSubmit ? _submit : null,
          text: model.primaryButtonText),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(
          model.secondaryButtonText,
          style: TextStyle(color: Colors.black87),
        ),
      )
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
        focusNode: _emailFocusNode,
        controller: _emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        onEditingComplete: () => _emailEditingComplete(),
        decoration: InputDecoration(
            labelText: 'Email',
            enabled: model.isLoading == false,
            hintText: 'test@test.com',
            errorText: model.emailErrorText),
        onChanged: model.updateEmail);
  }

  TextField _buildPasswordTextField() {
    return TextField(
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        decoration: InputDecoration(
            labelText: 'Password',
            enabled: model.isLoading == false,
            errorText: model.passwordErrorText),
        obscureText: true,
        onEditingComplete: _submit,
        onChanged: model.updatePassword);
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign In Failed', exception: e);
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child:  Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildChildren(),
              ),
            )
    );
  }
}
