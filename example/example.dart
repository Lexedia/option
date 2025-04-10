import 'package:option/option.dart';

void main(List<String> args) {
  final someInt = Some(42);

  final someNullableString = None<String?>();

  print(someInt.isSome);
  print(someInt.unwrap()); // 42

  print(someNullableString.isNone);
  print(someNullableString.unwrapOr('Hello')); // Hello

  print(None() == someNullableString); // true

  print(someInt.map((val) => '${val + 42}') == const Some('84'));
}
