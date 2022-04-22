import 'package:time_tracker_flutter_course/app/models/jobs_model.dart';
import 'package:time_tracker_flutter_course/app/services/api_path.dart';
import 'package:time_tracker_flutter_course/app/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobStream();
  Future<void> deleteJob(Job job);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirebaseDatabase implements Database {
  FirebaseDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(uid: uid, jobId: job.id),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobStream() => _service.collectionStream(
      path: APIPath.jobs(uid),
      builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Future<void> deleteJob(Job job) => _service.deleteData(
        path: APIPath.job(uid: uid, jobId: job.id),
      );
}
