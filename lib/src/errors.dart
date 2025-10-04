part of 'option.dart';

/// An [Error] thrown when [Option.unwrap] fails.
///
/// This should (in theory) not be caught,
/// if you want to safely [Option.unwrap], use either [Option.unwrapOr] or [Option.unwrapOrElse].
final class UnwrapError<T> extends Error {
  UnwrapError._();

  @override
  String toString() => 'Failed to unwrap None to $T';
}

/// An [Error] thrown when [Option.expect] fails.
///
/// This should (in theory) not be caught.
final class ExpectError extends Error {
  final String _message;

  ExpectError._(this._message);

  @override
  String toString() => _message;
}
