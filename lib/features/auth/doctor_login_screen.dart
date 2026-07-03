import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/auth_service.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/widgets/botanical_scaffold.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await AuthService.instance.emailSignIn(
        email: _email.text,
        password: _password.text,
        expectedRole: 'doctor',
      );
      if (!mounted) return;
      context.go(AppRoutes.doctorHome);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = AppL10n.of(context).connectionError);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return BotanicalScaffold(
      appBar: AppBar(
        title: Text(l.doctorLogin),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          MediaQuery.of(context).padding.top + kToolbarHeight + 24,
          24,
          24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: l.usernameOrEmail,
                  hintText: l.hintDoctor,
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.username],
                validator: (v) => (v == null || v.trim().isEmpty) ? '—' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(labelText: l.password),
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                validator: (v) => (v == null || v.length < 6) ? '—' : null,
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
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(l.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
