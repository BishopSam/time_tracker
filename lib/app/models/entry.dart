class Entry {
  Entry({
    required this.id,
    required this.jobId,
    required this.start,
    required this.end,
    this.comment = '',
  });

  String id;
  String jobId;
  DateTime start;
  DateTime end;
  String? comment;

  int get durationInHours {
     final hours = end.difference(start).inMinutes.toDouble() / 60.0;
     return hours.round();
  }
     
  String get durationInMinutes =>
      '${end.difference(start).inMinutes.toInt()}mins';
  
  int get durationInMinutesInt =>
      end.difference(start).inMinutes.toInt();

  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return Entry(
      id: id,
      jobId: value['jobId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
