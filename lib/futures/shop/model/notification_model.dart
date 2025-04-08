// models/notification_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? imageUrl;
  final String? type;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.createdAt,
    this.imageUrl,
    this.type,
    this.data,
  });

  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return NotificationModel(
      id: snapshot.id,
      userId: data['userId'],
      title: data['title'],
      body: data['body'],
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
      type: data['type'],
      data:
          data['data'] != null ? Map<String, dynamic>.from(data['data']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrl': imageUrl,
      'type': type,
      'data': data,
    };
  }
}
