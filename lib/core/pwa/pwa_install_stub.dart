/// Non-web platformlarda kullanılan stub. Native mobil app zaten kurulu,
/// PWA install prompt anlamsız — bu yüzden hiçbir şey döndürmez.
enum PwaPlatform { ios, android, desktop, unknown }

class PwaInstall {
  static bool get isSupported => false;
  static bool get isStandalone => false;
  static PwaPlatform get platform => PwaPlatform.unknown;
  static Future<bool> promptNativeInstall() async => false;
}
