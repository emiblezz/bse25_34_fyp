

class Application {
  final int id;
  final int jobId;
  final int applicantId;
  final String status;
  final DateTime dateApplied;


  Application({
    required this.id,
    required this.jobId,
    required this.applicantId,
    required this.status,
    required this.dateApplied,

  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['application_ID'],
      jobId: json['job_ID'],
      applicantId: json['applicant_ID'],
      status: json['application_status'],
      dateApplied: DateTime.parse(json['date_applied']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_ID': id,
      'job_ID': jobId,
      'applicant_ID': applicantId,
      'application_status': status,
      'date_applied': dateApplied.toIso8601String(),
    };
  }
}