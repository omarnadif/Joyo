/// Le lingue giocabili: si sceglie quella del tavolo, non solo quella del
/// telefono di chi ospita.
enum AppLocale {
  it('it', 'Italiano', '🇮🇹'),
  en('en', 'English', '🇬🇧'),
  es('es', 'Español', '🇪🇸'),
  fr('fr', 'Français', '🇫🇷'),
  de('de', 'Deutsch', '🇩🇪');

  const AppLocale(this.code, this.label, this.flag);

  final String code;
  final String label;
  final String flag;

  static AppLocale fromCode(String? code) {
    for (final locale in AppLocale.values) {
      if (locale.code == code) return locale;
    }
    return AppLocale.en;
  }

  /// Lingua di partenza dedotta dal telefono, se la conosciamo.
  static AppLocale fromSystem(String systemCode) =>
      fromCode(systemCode.split('_').first.split('-').first.toLowerCase());
}
