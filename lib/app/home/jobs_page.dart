import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/models/jobs_model.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/app/services/database.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_dialog.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Log Out',
        content: 'Are you sure you want to logout?',
        defaultActionText: 'Log Out',
        cancelActionText: 'Cancel');

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  void _createJob(BuildContext context) {
    try {
      final database = Provider.of<Database>(context, listen: false);
      database.createJob(Job(name: 'Blogging', ratePerHour: 10));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    database.jobStream();
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dataBase = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: dataBase.jobStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs!.map((job) => Text(job.name)).toList();
            return ListView(children: children);
          }
          if (snapshot.hasError) {
            return Center(child: Text('Some error has occured'),);
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
