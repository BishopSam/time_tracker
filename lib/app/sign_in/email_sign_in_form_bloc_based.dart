import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/blocs/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/models/email_sign_model.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_dialog.dart';

class EmailSiginInFormBlocBased extends StatefulWidget {
  EmailSiginInFormBlocBased({Key? key, required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSiginInFormBlocBased(
          bloc: bloc,
        ),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSiginInFormBlocBased> createState() =>
      _EmailSiginInFormBlocBasedState();
}

class _EmailSiginInFormBlocBasedState extends State<EmailSiginInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8),
      _buildPasswordTextField(model),
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

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
        focusNode: _emailFocusNode,
        controller: _emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        onEditingComplete: () => _emailEditingComplete(model),
        decoration: InputDecoration(
            labelText: 'Email',
            enabled: model.isLoading == false,
            hintText: 'test@test.com',
            errorText: model.emailErrorText),
        onChanged: widget.bloc.updateEmail);
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
        focusNode: _passwordFocusNode,
        controller: _passwordController,
        decoration: InputDecoration(
            labelText: 'Password',
            enabled: model.isLoading == false,
            errorText: model.passwordErrorText),
        obscureText: true,
        onEditingComplete: _submit,
        onChanged: widget.bloc.updatePassword);
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign In Failed', exception: e);
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: StreamBuilder<EmailSignInModel>(
          stream: widget.bloc.modelStream,
          initialData: EmailSignInModel(),
          builder: (context, snapshot) {
            final EmailSignInModel model = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildChildren(model),
              ),
            );
          }),
    );
  }
}
