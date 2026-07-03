import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/api/admin_service.dart';
import '../../core/api/auth_service.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/botanical_scaffold.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return DefaultTabController(
      length: 3,
      child: BotanicalScaffold(
        appBar: AppBar(
          title: Text(l.adminHomeTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: l.signOut,
              onPressed: () async {
                await AuthService.instance.signOut();
                if (context.mounted) context.go(AppRoutes.root);
              },
              icon: const Icon(Icons.logout, color: AppColors.sageDark),
            ),
          ],
          bottom: TabBar(isScrollable: true, tabs: [
            Tab(text: l.authorizeGuest),
            Tab(text: l.activeGuests),
            Tab(text: l.doctors),
          ]),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +
                kToolbarHeight +
                kTextTabBarHeight,
          ),
          child: const TabBarView(
            children: [
              _AuthorizeGuestTab(),
              _ActiveGuestsTab(),
              _DoctorsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthorizeGuestTab extends StatefulWidget {
  const _AuthorizeGuestTab();

  @override
  State<_AuthorizeGuestTab> createState() => _AuthorizeGuestTabState();
}

class _AuthorizeGuestTabState extends State<_AuthorizeGuestTab> {
  final _formKey = GlobalKey<FormState>();
  final _passport = TextEditingController();
  final _room = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _nationality = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  bool _loading = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _passport.dispose();
    _room.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _nationality.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    try {
      final result = await AdminService.instance.authorizeGuest(
        fullPassport: _passport.text,
        roomNumber: _room.text,
        firstName: _firstName.text,
        lastName: _lastName.text,
        nationality: _nationality.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
      );
      if (!mounted) return;
      final l = AppL10n.of(context);
      final wasUpdated = result['updated'] == true;
      setState(() {
        _successMessage =
            wasUpdated ? l.guestUpdatedSuccess : l.guestAuthorizedSuccess;
        _passport.clear();
        _room.clear();
        _firstName.clear();
        _lastName.clear();
        _nationality.clear();
        _email.clear();
        _phone.clear();
      });
    } on AdminException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = AppL10n.of(context).connectionError);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _passport,
              decoration: InputDecoration(labelText: l.passportFull),
              textCapitalization: TextCapitalization.characters,
              validator: (v) =>
                  (v == null || v.trim().length < 6) ? l.requiredField : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _room,
              decoration: InputDecoration(labelText: l.roomNumber),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.requiredField : null,
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _firstName,
                  decoration: InputDecoration(labelText: l.guestFirstName),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l.requiredField : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _lastName,
                  decoration: InputDecoration(labelText: l.guestLastName),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l.requiredField : null,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nationality,
              decoration: InputDecoration(
                  labelText: '${l.nationality} (${l.optional})'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration:
                  InputDecoration(labelText: '${l.email} (${l.optional})'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              decoration:
                  InputDecoration(labelText: '${l.phone} (${l.optional})'),
              keyboardType: TextInputType.phone,
            ),
            if (_successMessage != null) ...[
              const SizedBox(height: 16),
              _AlertBanner(message: _successMessage!, isError: false),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              _AlertBanner(message: _errorMessage!, isError: true),
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
                  : Text(l.submit),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveGuestsTab extends StatelessWidget {
  const _ActiveGuestsTab();

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final dateFmt = DateFormat('dd.MM.yyyy');
    return StreamBuilder<List<GuestSummary>>(
      stream: AdminService.instance.activeGuestsStream(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('${l.loadFailed}: ${snap.error}'),
            ),
          );
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final guests = snap.data!;
        if (guests.isEmpty) {
          return Center(child: Text(l.noActiveGuests));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: guests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final g = guests[i];
            return Card(
              child: ListTile(
                title: Text(g.fullName.isEmpty ? '—' : g.fullName),
                subtitle: Text(
                  '${l.roomLabel} ${g.roomNumber}'
                  '${g.expiresAt != null ? " · ${l.expiresLabel}: ${dateFmt.format(g.expiresAt!)}" : ""}',
                ),
                trailing: IconButton(
                  tooltip: l.revokeAccess,
                  icon: const Icon(Icons.block, color: AppColors.terracotta),
                  onPressed: () => _confirmDeactivate(context, g),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDeactivate(
      BuildContext context, GuestSummary g) async {
    final l = AppL10n.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.revokeAccess),
        content: Text(
            '${g.fullName} · ${l.roomLabel} ${g.roomNumber}\n${l.revokeAccessConfirm}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.revoke),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await AdminService.instance.deactivateGuest(g.guestId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${g.fullName} — ${l.accessRevoked}')),
      );
    } on AdminException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l.error}: ${e.message}')),
      );
    }
  }
}

class _DoctorsTab extends StatefulWidget {
  const _DoctorsTab();

  @override
  State<_DoctorsTab> createState() => _DoctorsTabState();
}

class _DoctorsTabState extends State<_DoctorsTab> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _specialty = TextEditingController();
  final _title = TextEditingController(text: 'Dr.');
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _specialty.dispose();
    _title.dispose();
    super.dispose();
  }

  Future<void> _createDoctor() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    try {
      await AdminService.instance.createDoctor(
        email: _email.text,
        password: _password.text,
        firstName: _firstName.text,
        lastName: _lastName.text,
        specialty: _specialty.text,
        title: _title.text.trim().isEmpty ? 'Dr.' : _title.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _successMessage = AppL10n.of(context).doctorAddedSuccess;
        _email.clear();
        _password.clear();
        _firstName.clear();
        _lastName.clear();
        _specialty.clear();
      });
    } on AdminException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = AppL10n.of(context).connectionError);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.addNewDoctor,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          controller: _title,
                          decoration:
                              InputDecoration(labelText: l.titleField),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _firstName,
                          decoration:
                              InputDecoration(labelText: l.firstName),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? '—' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lastName,
                          decoration: InputDecoration(labelText: l.lastName),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? '—' : null,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _specialty,
                      decoration: InputDecoration(labelText: l.specialty),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(labelText: l.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? '—' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      decoration:
                          InputDecoration(labelText: l.temporaryPassword),
                      obscureText: true,
                      validator: (v) =>
                          (v == null || v.length < 8) ? l.passwordTooShort : null,
                    ),
                    if (_successMessage != null) ...[
                      const SizedBox(height: 12),
                      _AlertBanner(message: _successMessage!, isError: false),
                    ],
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      _AlertBanner(message: _errorMessage!, isError: true),
                    ],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _loading ? null : _createDoctor,
                      child: _loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(l.createDoctor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.registeredDoctors,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<DoctorSummary>>(
            stream: AdminService.instance.doctorsStream(),
            builder: (context, snap) {
              if (snap.hasError) {
                return Text('${l.loadFailed}: ${snap.error}');
              }
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snap.data!;
              if (docs.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l.noDoctorsYet),
                  ),
                );
              }
              return Column(
                children: docs
                    .map(
                      (d) => Card(
                        child: ListTile(
                          leading: Icon(
                            d.active
                                ? Icons.medical_services_outlined
                                : Icons.block,
                            color: d.active
                                ? AppColors.sageDark
                                : AppColors.inkSoft,
                          ),
                          title: Text(d.displayName),
                          subtitle: Text(
                            [
                              if (d.specialty.isNotEmpty) d.specialty,
                              d.email,
                            ].join(' · '),
                          ),
                          trailing: d.active
                              ? IconButton(
                                  tooltip: l.revokeAccess,
                                  icon: const Icon(Icons.block,
                                      color: AppColors.terracotta),
                                  onPressed: () async {
                                    final ok = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(l.revokeAccess),
                                        content: Text(
                                            '${d.displayName}\n${l.revokeAccessConfirm}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(false),
                                            child: Text(l.cancel),
                                          ),
                                          FilledButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text(l.revoke),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (ok == true) {
                                      await AdminService.instance
                                          .deactivateDoctor(d.doctorId);
                                    }
                                  },
                                )
                              : Text(l.inactive,
                                  style: const TextStyle(
                                      color: AppColors.inkSoft)),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final String message;
  final bool isError;
  const _AlertBanner({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    final color = isError
        ? Theme.of(context).colorScheme.errorContainer
        : AppColors.sage.withValues(alpha: 0.2);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message),
    );
  }
}
