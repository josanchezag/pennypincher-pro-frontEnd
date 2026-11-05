import 'package:equatable/equatable.dart';

/// Loading state of one part of the ant expenses screen, loaded and
/// retried on its own so one failing part never hides the others.
sealed class AntSection<T> extends Equatable {
  const AntSection();

  /// The loaded value, or `null` while loading or after a failure.
  T? get valueOrNull => switch (this) {
        AntSectionLoaded<T>(:final value) => value,
        _ => null,
      };

  @override
  List<Object?> get props => const [];
}

final class AntSectionLoading<T> extends AntSection<T> {
  const AntSectionLoading();
}

/// The part could not be loaded; it can be retried.
final class AntSectionFailure<T> extends AntSection<T> {
  const AntSectionFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AntSectionLoaded<T> extends AntSection<T> {
  const AntSectionLoaded(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}
