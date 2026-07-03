import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

/// Web-only PWA yardımcısı.
enum PwaPlatform { ios, android, desktop, unknown }

class PwaInstall {
  static bool get isSupported => true;

  static JSObject? _pendingPrompt;
  static bool _listenerAttached = false;

  static void _attachListener() {
    if (_listenerAttached) return;
    _listenerAttached = true;
    web.window.addEventListener(
      'beforeinstallprompt',
      ((web.Event event) {
        event.preventDefault();
        _pendingPrompt = event as JSObject;
      }).toJS,
    );
  }

  /// Ana ekrandan mı açılmış? true ise banner GÖSTERMEK gereksiz.
  static bool get isStandalone {
    _attachListener();
    try {
      final match = web.window.matchMedia('(display-mode: standalone)');
      if (match.matches) return true;
    } catch (_) {}
    // iOS Safari için ekstra kontrol (navigator.standalone)
    try {
      final nav = (web.window.navigator as JSObject);
      final flag = nav.getProperty<JSAny?>('standalone'.toJS);
      if (flag != null && (flag.dartify() == true)) return true;
    } catch (_) {}
    return false;
  }

  static PwaPlatform get platform {
    _attachListener();
    final ua = web.window.navigator.userAgent.toLowerCase();
    if (ua.contains('iphone') || ua.contains('ipad') || ua.contains('ipod')) {
      return PwaPlatform.ios;
    }
    if (ua.contains('android')) return PwaPlatform.android;
    if (ua.contains('mac') || ua.contains('win') || ua.contains('linux')) {
      return PwaPlatform.desktop;
    }
    return PwaPlatform.unknown;
  }

  /// Chrome / Edge native install prompt (varsa) çağır. Yoksa false döner.
  static Future<bool> promptNativeInstall() async {
    _attachListener();
    final p = _pendingPrompt;
    if (p == null) return false;
    try {
      p.callMethod<JSAny?>('prompt'.toJS);
      final choicePromise =
          p.getProperty<JSPromise<JSObject>>('userChoice'.toJS);
      final choice = await choicePromise.toDart;
      final outcome = choice.getProperty<JSAny?>('outcome'.toJS)?.dartify();
      _pendingPrompt = null;
      return outcome == 'accepted';
    } catch (_) {
      return false;
    }
  }
}
