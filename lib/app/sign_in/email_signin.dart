import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_bloc_based.dart';

class EmailSignInPage extends StatelessWidget {


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(child: EmailSiginInFormBlocBased.create(context)),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  
}