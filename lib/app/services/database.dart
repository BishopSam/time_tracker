import 'package:time_tracker_flutter_course/app/models/jobs_model.dart';
import 'package:time_tracker_flutter_course/app/services/api_path.dart';
import 'package:time_tracker_flutter_course/app/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobStream();
}

class FirebaseDatabase implements Database {
  FirebaseDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> createJob(Job job) => _service.setData(
        path: APIPath.job(uid: uid, jobId: 'job_abc'),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data) => Job.fromMap(data));
}
