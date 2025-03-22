import 'package:flutter/foundation.dart';
import 'job_model.dart';

class Application {
  final String id;
  final Job job;
  final String status;
  final DateTime appliedDate;
  final List<String>? attachments;
  final String? coverLetter;
  final String? feedback;
  final DateTime? interviewDate;

  Application({
    required this.id,
    required this.job,
    required this.status,
    required this.appliedDate,
    this.attachments,
    this.coverLetter,
    this.feedback,
    this.interviewDate,
  });

  // Create an application instance from JSON data
  factory Application.fromJson(Map<String, dynamic> json, Job job) {
    return Application(
      id: json['id'],
      job: job,
      status: json['status'],
      appliedDate: DateTime.parse(json['appliedDate']),
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
      coverLetter: json['coverLetter'],
      feedback: json['feedback'],
      interviewDate: json['interviewDate'] != null
          ? DateTime.parse(json['interviewDate'])
          : null,
    );
  }

  // Convert application instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': job.id,
      'status': status,
      'appliedDate': appliedDate.toIso8601String(),
      'attachments': attachments,
      'coverLetter': coverLetter,
      'feedback': feedback,
      'interviewDate': interviewDate?.toIso8601String(),
    };
  }

  // Create a copy of the application with modified fields
  Application copyWith({
    String? id,
    Job? job,
    String? status,
    DateTime? appliedDate,
    List<String>? attachments,
    String? coverLetter,
    String? feedback,
    DateTime? interviewDate,
  }) {
    return Application(
      id: id ?? this.id,
      job: job ?? this.job,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      attachments: attachments ?? this.attachments,
      coverLetter: coverLetter ?? this.coverLetter,
      feedback: feedback ?? this.feedback,
      interviewDate: interviewDate ?? this.interviewDate,
    );
  }

  // Get a human-readable status label
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Review';
      case 'reviewing':
        return 'Under Review';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Not Selected';
      case 'interview':
        return 'Interview Scheduled';
      default:
        return status;
    }
  }

  // Check if the application has a scheduled interview
  bool get hasInterview {
    return interviewDate != null;
  }

  // Check if the application process is complete
  bool get isCompleted {
    return status.toLowerCase() == 'accepted' ||
        status.toLowerCase() == 'rejected';
  }

  // Check if the application is still active
  bool get isActive {
    return !isCompleted;
  }

  // Get days since application was submitted
  int get daysSinceApplied {
    return DateTime.now().difference(appliedDate).inDays;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Application && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}