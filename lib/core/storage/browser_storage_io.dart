/// Native platforms and tests keep the values in memory only.
final Map<String, String> _values = {};

String? readStoredValue(String key) => _values[key];

void writeStoredValue(String key, String value) => _values[key] = value;
