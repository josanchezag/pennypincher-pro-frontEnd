/// Native platforms and tests keep the choice in memory only.
String? _languageCode;

String? readStoredLanguageCode() => _languageCode;

void writeStoredLanguageCode(String languageCode) =>
    _languageCode = languageCode;
