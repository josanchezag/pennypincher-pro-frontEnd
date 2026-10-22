/// Converts Dart enum values to and from the `SCREAMING_SNAKE_CASE` names
/// the backend uses, for example `realEstate` <-> `REAL_ESTATE`.
abstract final class ApiEnum {
  static final RegExp _upperCase = RegExp('[A-Z]');

  static String nameOf(Enum value) => value.name
      .replaceAllMapped(_upperCase, (match) => '_${match[0]}')
      .toUpperCase();

  /// Value of [values] named [json]. A name this client does not know yet
  /// becomes [fallback]; a value that is not a string is a format error.
  static T parse<T extends Enum>(
    List<T> values,
    Object? json, {
    required T fallback,
  }) {
    if (json is! String) {
      throw FormatException('Invalid enum value', json);
    }
    for (final value in values) {
      if (nameOf(value) == json) {
        return value;
      }
    }
    return fallback;
  }
}
