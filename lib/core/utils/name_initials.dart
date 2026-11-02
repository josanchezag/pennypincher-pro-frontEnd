/// Words and initials of a person's display name.
abstract final class NameInitials {
  static final RegExp _whitespace = RegExp(r'\s+');

  /// Non-empty words of [name], in order.
  static List<String> words(String name) =>
      name.trim().split(_whitespace).where((w) => w.isNotEmpty).toList();

  /// Upper-case initials of the first and last words: `JS` for
  /// `Josimar Sanchez`; empty when the name is blank.
  static String of(String name) {
    final parts = words(name);
    if (parts.isEmpty) {
      return '';
    }
    final last = parts.length > 1 ? _initial(parts.last) : '';
    return '${_initial(parts.first)}$last'.toUpperCase();
  }

  static String _initial(String word) => String.fromCharCode(word.runes.first);
}
