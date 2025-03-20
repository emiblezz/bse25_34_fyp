class Job {
  final int id;
  final int recruiterId;
  final String jobType;
  final String description;
  final String requirements;
  final String status;
  final DateTime datePosted;
  final DateTime deadline;
  final String? companyName;
  final String? location;

  Job({
    required this.id,
    required this.recruiterId,
    required this.jobType,
    required this.description,
    required this.requirements,
    required this.status,
    required this.datePosted,
    required this.deadline,
    this.companyName,
    this.location,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['job_ID'],
      recruiterId: json['recruiter_ID'],
      jobType: json['job_type'],
      description: json['description'],
      requirements: json['requirements'],
      status: json['status'],
      datePosted: DateTime.parse(json['date_posted']),
      deadline: DateTime.parse(json['deadline']),
      companyName: json['company_name'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_ID': id,
      'recruiter_ID': recruiterId,
      'job_type': jobType,
      'description': description,
      'requirements': requirements,
      'status': status,
      'date_posted': datePosted.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'company_name': companyName,
      'location': location,
    };
  }
}