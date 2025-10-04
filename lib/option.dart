/// A library that provides an implementation of the `Option` type,
/// which represents optional values that may or may not be present.
///
/// Example usage:
/// ```dart
/// final someValue = Option.some(42);
/// final noneValue = Option.none();
///
/// if (someValue.isSome) {
///   print('Value: ${someValue.unwrap()}'); // Outputs: Value: 42
/// }
///
/// if (noneValue.isNone) {
///   print('No value present.');
/// }
/// ```
library;

export 'src/option.dart' show ExpectError, None, Option, Some, UnwrapError;
