class TaskNotification {
  final int id;
  final int userId;
  final String type;
  final String message;
  final DateTime timestamp;
  final String status;

  TaskNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.status,
  });

  factory TaskNotification.fromJson(Map<String, dynamic> json) {
    return TaskNotification(
      id: json['notification_ID'],
      userId: json['user_ID'],
      type: json['notification_type'],
      message: json['notification_message'],
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_ID': id,
      'user_ID': userId,
      'notification_type': type,
      'notification_message': message,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}