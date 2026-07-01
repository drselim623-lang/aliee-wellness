import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/auth_service.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/routing/app_router.dart';

class GuestLoginForm extends StatefulWidget {
  const GuestLoginForm({super.key});

  @override
  State<GuestLoginForm> createState() => _GuestLoginFormState();
}

class _GuestLoginFormState extends State<GuestLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _passport = TextEditingController();
  final _room = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passport.dispose();
    _room.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await AuthService.instance.guestSignIn(
        passportLast6: _passport.text.trim(),
        roomNumber: _room.text.trim(),
      );
      if (!mounted) return;
      context.go(AppRoutes.guestHome);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Bağlantı hatası. Lütfen tekrar deneyin.';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _passport,
            decoration: InputDecoration(labelText: l.passportLast6),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            ],
            validator: (v) =>
                (v == null || v.trim().length != 6) ? '—' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _room,
            decoration: InputDecoration(labelText: l.roomNumber),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? '—' : null,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Text(l.login),
          ),
        ],
      ),
    );
  }
}
