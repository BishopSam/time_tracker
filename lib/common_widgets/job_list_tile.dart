import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/models/jobs_model.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key? key, required this.job, required this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(width: 1, color: Colors.white)),
        contentPadding: EdgeInsets.all(20),
        title: Text(
          job.name,
          style: TextStyle(color: Colors.indigo),
        ),
        onTap: onTap,
        trailing: Icon(
          Icons.chevron_right_outlined,
          color: Colors.indigo,
        ),
      ),
    );
  }
}
