part 'errors.dart';

/// Represents an [Option]al value that is either [Some] if it contains a value, or [None] if it doesn't contain one.
///
/// The [Option] class is an abstraction that allows you to represent values that may or may not be present.
/// It helps to avoid the pitfalls of using `null` to indicate the absence of a value, which can lead to ambiguity
/// and potential runtime errors.
/// By using [Option], you can clearly differentiate between a value that is intentionally absent and a value that is present.
///
/// See this example:
/// ```dart
/// Future<void> updateUser({String? name, Uint8List? avatar}) async {
///   if (name != null) {
///     await updateUserName(name);
///   }
///
///   if (avatar != null) {
///     await updateUserAvatar(avatar);
///   }
/// }
///
/// void main() async {
///   await updateUser(avatar: null);
/// }
/// ```
///
/// When setting the `avatar` parameter explicitely to `null`, indicating the user want to delete it, this will not be ran because of the if clause guard.
/// Using [Option] can solve this issue:
/// ```dart
/// Future<void> updateUser({Option<String> name = const None(), Option<Uint8List?> avatar = const None()}) async {
///   if (name.isSome) {
///     await updateUserName(name.unwrap());
///   }
///
///   if (avatar.isSome) {
///     await updateUserAvatar(avatar.unwrap());
///   }
/// }
///
/// void main() async {
///   await updateUser(avatar: const Some(null));
/// }
/// ```
sealed class Option<T extends Object?> {
  const Option._();

  /// Creates [Some] value from [value].
  ///
  /// This is the same as invoking the [Some] constructor.
  const factory Option.some(T value) = Some<T>;

  /// Creates [None] value.
  ///
  /// This is the same as invoking the [None] constructor.
  const factory Option.none() = None<T>;

  /// Creates [Some] value if [value] isn't `null`, [None] either.
  factory Option.fromNullable(T? value) => switch (value) {
    final value? => Some(value),
    _ => None(),
  };

  /// Returns `true` if the [Option] is [Some] value.
  bool get isSome => this is Some<T>;

  /// Returns `true` if the [Option] is [Some] and matches [predicate].
  bool isSomeAnd(bool Function(T value) predicate) => switch (this) {
    Some(:final value) => predicate(value),
    None() => false,
  };

  /// Returns `true` if the [Option] is [None].
  bool get isNone => this is None;

  /// Returns `true` if the [Option] is [None] or the value inside it matches [predicate].
  bool isNoneOr(bool Function(T value) predicate) => switch (this) {
    Some(:final value) => predicate(value),
    None() => true,
  };

  /// Returns the contained [Some] value or throws an [ExpectError] if it is [None].
  T expect(String message) => switch (this) {
    Some(:final value) => value,
    None() => throw ExpectError._(message),
  };

  /// Unwrap this [Option] to return it's [Some] value or throw an [UnwrapError].
  T unwrap() => switch (this) {
    Some(:final value) => value,
    None() => throw UnwrapError<T>._(),
  };

  /// [unwrap]s this [Option] to return it's [Some] value or fallback to [defaultValue] if this is [None].
  T unwrapOr(T defaultValue) => switch (this) {
    Some(:final value) => value,
    None() => defaultValue,
  };

  /// [unwrap]s this [Option] to return it's [Some] value or call the [f] if this is [None].
  T unwrapOrElse(T Function() f) => switch (this) {
    Some(:final value) => value,
    None() => f(),
  };

  /// Transform this [Option] to [map] it's value if it is [Some], or return [None] otherwise.
  /// You can think of [map] as a more practical optional chaining (`?.`) operator.
  /// 
  /// Note that the returned [Option] will be then bound to [E] and not [T].
  Option<E> map<E>(E Function(T) mapper) => switch (this) {
    Some(:final value) => Some<E>(mapper(value)),
    None() => None<E>(),
  };

  /// The [|] operator is used to either select [this] or [other] if [this] is [None].
  /// You can think of [|] as an equivalent to `??` for nullable types.
  Option<T> operator |(Option<T> other) => switch (this) {
    Some() => this,
    None() => other,
  };

  /// If this [Option] has [Some] value, returns it, `null` otherwise.
  T? toNullable() => switch (this) {
    Some(:final value) => value,
    None() => null,
  };
}

/// Represents a [Some] value of type [T].
///
/// The [Some] class is a concrete implementation of the [Option] type that
/// encapsulates a value of type [T].
///
/// Use the [Some] class when you want to represent a value that is guaranteed
/// to be present. This is particularly useful in scenarios where you want to
/// differentiate between a value that is explicitly set to `null` and a value
/// that is simply not present.
///
/// Example:
/// ```dart
/// const someValue = Option.some(42);
/// if (someValue.isSome) {
///   print('The value is: ${someValue.unwrap()}'); // Outputs: The value is: 42
/// }
/// ```
///
/// The [value] property holds the actual value of type [T].
final class Some<T extends Object?> extends Option<T> {
  const Some(this.value) : super._();

  /// The [value] held by this [Some] instance.
  final T value;

  @override
  String toString() => 'Some<$T>($value)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is Some<T> && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// No value.
///
/// The [None] class is defined with a generic type parameter [T] to ensure compatibility with methods like
/// [Option.unwrapOr] and [Option.unwrapOrElse].
///
/// If we were to use `Never` as the type parameter, it would lead to type errors because `Never` has no subtypes (unless itself),
/// meaning it cannot represent any actual value.
/// Therefore, we use [T] to allow [None] to be used with any type, even though semantically it may seem
/// counterintuitive.
///
/// The [==] operator doesn't differentiate [None] bound to an other type. This means that `None<int>() == None<String>()` will
/// returns `true`, because every instance of [None] should always be equals to itself.
final class None<T extends Object?> extends Option<T> {
  const None() : super._();

  @override
  String toString() => 'None';

  @override
  bool operator ==(Object other) => identical(this, other) || other is None;

  @override
  int get hashCode => 0xB16B00B5;
}
