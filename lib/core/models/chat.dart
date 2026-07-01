import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String firstName;
  final String lastName;
  final String title;
  final String specialty;
  final bool active;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.specialty,
    required this.active,
  });

  String get displayName => '$title $firstName $lastName'.trim();

  factory Doctor.fromDoc(String id, Map<String, dynamic> data) {
    return Doctor(
      id: id,
      firstName: (data['firstName'] as String?) ?? '',
      lastName: (data['lastName'] as String?) ?? '',
      title: (data['title'] as String?) ?? 'Dr.',
      specialty: (data['specialty'] as String?) ?? '',
      active: (data['active'] as bool?) ?? true,
    );
  }
}

class Question {
  final String id;
  final String guestId;
  final String doctorId;
  final String guestName;
  final String doctorName;
  final String lastMessagePreview;
  final DateTime? lastMessageAt;
  final int unreadForDoctor;
  final int unreadForGuest;
  final String status;

  Question({
    required this.id,
    required this.guestId,
    required this.doctorId,
    required this.guestName,
    required this.doctorName,
    required this.lastMessagePreview,
    this.lastMessageAt,
    required this.unreadForDoctor,
    required this.unreadForGuest,
    required this.status,
  });

  factory Question.fromDoc(String id, Map<String, dynamic> data) {
    return Question(
      id: id,
      guestId: (data['guestId'] as String?) ?? '',
      doctorId: (data['doctorId'] as String?) ?? '',
      guestName: (data['guestName'] as String?) ?? '',
      doctorName: (data['doctorName'] as String?) ?? '',
      lastMessagePreview: (data['lastMessagePreview'] as String?) ?? '',
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
      unreadForDoctor: (data['unreadForDoctor'] as int?) ?? 0,
      unreadForGuest: (data['unreadForGuest'] as int?) ?? 0,
      status: (data['status'] as String?) ?? 'open',
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderRole; // 'guest' | 'doctor'
  final String? text;
  final String? attachmentUrl;
  final String? attachmentType;
  final DateTime? createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderRole,
    this.text,
    this.attachmentUrl,
    this.attachmentType,
    this.createdAt,
  });

  factory ChatMessage.fromDoc(String id, Map<String, dynamic> data) {
    return ChatMessage(
      id: id,
      senderId: (data['senderId'] as String?) ?? '',
      senderRole: (data['senderRole'] as String?) ?? '',
      text: data['text'] as String?,
      attachmentUrl: data['attachmentUrl'] as String?,
      attachmentType: data['attachmentType'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  bool get isImage => attachmentType == 'image';
}
