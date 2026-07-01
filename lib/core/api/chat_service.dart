import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat.dart';

class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'europe-west1');
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  // ---- Doctors --------------------------------------------------------------
  Stream<List<Doctor>> activeDoctorsStream() {
    return _db
        .collection('doctors')
        .where('active', isEqualTo: true)
        .orderBy('firstName')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Doctor.fromDoc(d.id, d.data())).toList());
  }

  // ---- Questions ------------------------------------------------------------
  /// Guest'in kendi konuşmaları.
  Stream<List<Question>> guestQuestionsStream() {
    return _db
        .collection('questions')
        .where('guestId', isEqualTo: _uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Question.fromDoc(d.id, d.data())).toList());
  }

  /// Doktora gelen konuşmalar.
  Stream<List<Question>> doctorQuestionsStream() {
    return _db
        .collection('questions')
        .where('doctorId', isEqualTo: _uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Question.fromDoc(d.id, d.data())).toList());
  }

  /// Belirli bir konuşmanın mesajları (yeni → eski).
  Stream<List<ChatMessage>> messagesStream(String questionId) {
    return _db
        .collection('questions')
        .doc(questionId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(200)
        .snapshots()
        .map((s) => s.docs.map((d) => ChatMessage.fromDoc(d.id, d.data())).toList());
  }

  Future<Question?> getQuestion(String questionId) async {
    final doc = await _db.collection('questions').doc(questionId).get();
    if (!doc.exists) return null;
    return Question.fromDoc(doc.id, doc.data()!);
  }

  // ---- Actions --------------------------------------------------------------
  Future<String> startQuestion({
    required String doctorId,
    String? text,
    String? attachmentUrl,
    String? attachmentType,
  }) async {
    final result = await _functions.httpsCallable('startQuestion').call({
      'doctorId': doctorId,
      if (text != null && text.isNotEmpty) 'text': text,
      if (attachmentUrl != null && attachmentUrl.isNotEmpty)
        'attachmentUrl': attachmentUrl,
      if (attachmentType != null && attachmentType.isNotEmpty)
        'attachmentType': attachmentType,
    });
    return (result.data as Map)['questionId'] as String;
  }

  Future<void> sendMessage({
    required String questionId,
    String? text,
    String? attachmentUrl,
    String? attachmentType,
  }) async {
    await _functions.httpsCallable('sendMessage').call({
      'questionId': questionId,
      if (text != null && text.isNotEmpty) 'text': text,
      if (attachmentUrl != null && attachmentUrl.isNotEmpty)
        'attachmentUrl': attachmentUrl,
      if (attachmentType != null && attachmentType.isNotEmpty)
        'attachmentType': attachmentType,
    });
  }

  Future<void> markRead(String questionId) async {
    try {
      await _functions.httpsCallable('markQuestionRead').call({
        'questionId': questionId,
      });
    } catch (_) {
      // sessiz — okundu işareti fail olabilir, kritik değil
    }
  }

  /// Bir resim/dosyayı Storage'a yükler, download URL döner.
  Future<({String url, String type})> uploadAttachment({
    required String questionId,
    required Uint8List bytes,
    required String fileName,
    required String contentType,
  }) async {
    final ref = _storage
        .ref('questions/$questionId/attachments/${DateTime.now().millisecondsSinceEpoch}_$fileName');
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    final url = await ref.getDownloadURL();
    final type = contentType.startsWith('image/') ? 'image' : 'file';
    return (url: url, type: type);
  }

  /// startQuestion henüz yokken (ilk mesaj) önce bir geçici id ile yükleme yap,
  /// sonra startQuestion çağır. Kolay tutmak için: soru id'sini vermeden önce
  /// timestamp bazlı geçici path kullanırız.
  Future<({String url, String type})> uploadNewQuestionAttachment({
    required Uint8List bytes,
    required String fileName,
    required String contentType,
  }) async {
    final tempId = 'new_${DateTime.now().millisecondsSinceEpoch}';
    return uploadAttachment(
      questionId: tempId,
      bytes: bytes,
      fileName: fileName,
      contentType: contentType,
    );
  }
}
