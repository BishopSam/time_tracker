import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/models/job.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/app/services/database.dart';
import 'package:time_tracker_flutter_course/common_widgets/job_list_tile.dart';
import 'package:time_tracker_flutter_course/common_widgets/list_item_builder.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_dialog.dart';

class JobsPage extends StatefulWidget {
  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  bool isFABVisible = true;

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

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final dataBase = Provider.of<Database>(context, listen: false);
      await dataBase.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Could\'nt delete job', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                isFABVisible = true;
              });
            } else if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                isFABVisible = false;
              });
            }
            return true;
          },
          child: _buildContents(context)),
      floatingActionButton: isFABVisible
          ? FloatingActionButton(
              onPressed: () => EditJobPage.show(context,
                  database: Provider.of<Database>(context, listen: false)),
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildContents(BuildContext context) {
    final dataBase = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: dataBase.jobsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
              key: Key('job-${job.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (dismiss) => _delete(context, job),
              child: JobListTile(
                job: job,
                onTap: () => JobEntriesPage.show(context, job),
              ),
            ),
          );
        });
  }
}
