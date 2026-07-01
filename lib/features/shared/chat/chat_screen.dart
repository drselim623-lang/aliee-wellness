import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/api/chat_service.dart';
import '../../../core/models/chat.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/botanical_scaffold.dart';

// Aynı ekran hem misafir hem doktor kullanır. Rol chat mesajı sender'ına göre
// otomatik ayrılır (senderRole 'guest' / 'doctor').
//
// questionIdOrNew:
//   - Var olan konuşma id'si → onu açar
//   - "new_" prefix + doctorId → henüz kayıt olmamış, ilk mesajı gönderirken
//     startQuestion çağrılır ve yeni id ile devam edilir.
class ChatScreen extends StatefulWidget {
  final String questionIdOrNew;
  const ChatScreen({super.key, required this.questionIdOrNew});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _picker = ImagePicker();

  bool _sending = false;
  String? _questionId;
  String? _headerName;

  bool get _isNew => widget.questionIdOrNew.startsWith('new_');
  String? get _pendingDoctorId =>
      _isNew ? widget.questionIdOrNew.substring('new_'.length) : null;

  @override
  void initState() {
    super.initState();
    if (!_isNew) {
      _questionId = widget.questionIdOrNew;
      _loadQuestion();
    }
  }

  Future<void> _loadQuestion() async {
    final q = await ChatService.instance.getQuestion(_questionId!);
    if (!mounted) return;
    setState(() {
      final me = FirebaseAuth.instance.currentUser?.uid;
      _headerName = q == null
          ? null
          : (me == q.guestId ? q.doctorName : q.guestName);
    });
    if (q != null) {
      await ChatService.instance.markRead(q.id);
    }
  }

  Future<void> _pickAndSendAttachment() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeriden seç'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final xfile = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (xfile == null || !mounted) return;

    setState(() => _sending = true);
    try {
      final bytes = await xfile.readAsBytes();
      final contentType = xfile.mimeType ?? 'image/jpeg';
      final fileName = xfile.name;
      final upload = _isNew
          ? await ChatService.instance.uploadNewQuestionAttachment(
              bytes: bytes,
              fileName: fileName,
              contentType: contentType,
            )
          : await ChatService.instance.uploadAttachment(
              questionId: _questionId!,
              bytes: bytes,
              fileName: fileName,
              contentType: contentType,
            );
      if (_isNew) {
        final newId = await ChatService.instance.startQuestion(
          doctorId: _pendingDoctorId!,
          attachmentUrl: upload.url,
          attachmentType: upload.type,
        );
        _questionId = newId;
        await _loadQuestion();
      } else {
        await ChatService.instance.sendMessage(
          questionId: _questionId!,
          attachmentUrl: upload.url,
          attachmentType: upload.type,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yükleme hatası: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendText() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      if (_isNew) {
        final newId = await ChatService.instance.startQuestion(
          doctorId: _pendingDoctorId!,
          text: text,
        );
        _questionId = newId;
        _textCtrl.clear();
        await _loadQuestion();
      } else {
        await ChatService.instance.sendMessage(
          questionId: _questionId!,
          text: text,
        );
        _textCtrl.clear();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gönderilemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser?.uid ?? '';
    return BotanicalScaffold(
      appBar: AppBar(
        title: Text(_headerName ?? (_isNew ? 'Yeni Soru' : 'Konuşma')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        child: Column(
          children: [
            Expanded(
              child: _questionId == null
                  ? const _EmptyChat()
                  : StreamBuilder<List<ChatMessage>>(
                      stream: ChatService.instance.messagesStream(_questionId!),
                      builder: (context, snap) {
                        if (snap.hasError) {
                          return Center(
                              child: Text('Yüklenemedi: ${snap.error}'));
                        }
                        if (!snap.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final msgs = snap.data!;
                        if (msgs.isEmpty) return const _EmptyChat();
                        return ListView.builder(
                          controller: _scrollCtrl,
                          reverse: true,
                          padding: const EdgeInsets.all(16),
                          itemCount: msgs.length,
                          itemBuilder: (_, i) {
                            final m = msgs[i];
                            final mine = m.senderId == me;
                            return _MessageBubble(message: m, isMine: mine);
                          },
                        );
                      },
                    ),
            ),
            _Composer(
              controller: _textCtrl,
              sending: _sending,
              onSend: _sendText,
              onAttach: _pickAndSendAttachment,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Sohbet burada başlayacak.\nİlk mesajını yaz veya fotoğraf gönder.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.inkSoft),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  const _MessageBubble({required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    final bg = isMine ? AppColors.sageDark : AppColors.creamSoft;
    final fg = isMine ? Colors.white : AppColors.ink;
    final align = isMine ? Alignment.centerRight : Alignment.centerLeft;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMine ? 16 : 4),
      bottomRight: Radius.circular(isMine ? 4 : 16),
    );
    return Align(
      alignment: align,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(message.isImage ? 6 : 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: Border.all(color: AppColors.line.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isImage && message.attachmentUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: message.attachmentUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const SizedBox(
                    height: 180,
                    width: 240,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            if (message.text != null && message.text!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: message.isImage ? 6 : 0),
                child: Text(
                  message.text!,
                  style: TextStyle(color: fg, fontSize: 15),
                ),
              ),
            if (message.createdAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  DateFormat('HH:mm').format(message.createdAt!),
                  style: TextStyle(
                    color: fg.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          color: AppColors.cream.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(color: AppColors.line.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: sending ? null : onAttach,
              tooltip: 'Fotoğraf gönder',
              icon: const Icon(Icons.attach_file, color: AppColors.sageDark),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Mesaj yaz…',
                  border: InputBorder.none,
                ),
                onSubmitted: sending ? null : (_) => onSend(),
              ),
            ),
            IconButton(
              onPressed: sending ? null : onSend,
              icon: sending
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send, color: AppColors.sageDark),
            ),
          ],
        ),
      ),
    );
  }
}
