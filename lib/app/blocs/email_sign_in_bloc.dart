import 'dart:async';

import 'package:time_tracker_flutter_course/app/models/email_sign_model.dart';

class EmailSignInBloc {
    final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
    Stream<EmailSignInModel> get modelStream  => _modelController.stream;

    void dispose() {
      _modelController.close();
    }
}