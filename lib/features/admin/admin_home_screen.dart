import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/widgets/botanical_scaffold.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return DefaultTabController(
      length: 2,
      child: BotanicalScaffold(
        appBar: AppBar(
          title: Text(l.adminHomeTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(tabs: [
            Tab(text: l.authorizeGuest),
            Tab(text: l.activeGuests),
          ]),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight + kTextTabBarHeight,
          ),
          child: const TabBarView(
            children: [
              _AuthorizeGuestTab(),
              _ActiveGuestsTab(),
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
  final _passport = TextEditingController();
  final _room = TextEditingController();

  @override
  void dispose() {
    _passport.dispose();
    _room.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _passport,
            decoration: InputDecoration(labelText: l.passportFull),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _room,
            decoration: InputDecoration(labelText: l.roomNumber),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              // TODO: Cloud Function — pasaport hash + 1 yıl erişim açma.
            },
            child: Text(l.submit),
          ),
        ],
      ),
    );
  }
}

class _ActiveGuestsTab extends StatelessWidget {
  const _ActiveGuestsTab();

  @override
  Widget build(BuildContext context) {
    // TODO: Firestore listesi.
    return const Center(child: Text('—'));
  }
}
