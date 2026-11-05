import 'package:web/web.dart';

/// Sets the `lang` attribute of the page (`es` in `index.html`) to the
/// interface language, so screen readers and the browser's translation
/// offer follow it.
void setDocumentLanguage(String languageCode) =>
    document.documentElement?.setAttribute('lang', languageCode);
