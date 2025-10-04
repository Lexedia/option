import 'package:option/option.dart';
import 'package:test/test.dart';

void main() {
  group('Option', () {
    test('Option.some should create a Some value', () {
      const option = Option.some(42);
      expect(option, isA<Some<int>>());
      expect(option.unwrap(), 42);
    });

    test('Option.none should create a None value', () {
      const option = Option.none();
      expect(option, isA<None>());
    });

    test('Option.fromNullable should create Some for non-null', () {
      final option = Option.fromNullable(42);
      expect(option, isA<Some>());
      expect(option.unwrap(), 42);
    });

    test('Option.fromNullable should create None for null', () {
      final option = Option.fromNullable(null);
      expect(option, isA<None>());
    });

    test('isSome should be true for Some', () {
      const option = Some(42);
      expect(option.isSome, isTrue);
    });

    test('isSome should be false for None', () {
      const option = None();
      expect(option.isSome, isFalse);
    });

    test('isSomeAnd should be true for Some with matching predicate', () {
      const option = Some(42);
      expect(option.isSomeAnd((value) => value > 40), isTrue);
    });

    test('isSomeAnd should be false for Some with non-matching predicate', () {
      const option = Some(42);
      expect(option.isSomeAnd((value) => value < 40), isFalse);
    });

    test('isSomeAnd should be false for None', () {
      const option = None<int>();
      expect(option.isSomeAnd((value) => value > 40), isFalse);
    });

    test('isNone should be true for None', () {
      const option = None();
      expect(option.isNone, isTrue);
    });

    test('isNone should be false for Some', () {
      const option = Some(42);
      expect(option.isNone, isFalse);
    });

    test('isNoneOr should be true for None', () {
      const option = None<int>();
      expect(option.isNoneOr((value) => value > 40), isTrue);
    });

    test('isNoneOr should be true for Some with matching predicate', () {
      const option = Some(42);
      expect(option.isNoneOr((value) => value > 40), isTrue);
    });

    test('isNoneOr should be false for Some with non-matching predicate', () {
      const option = Some(42);
      expect(option.isNoneOr((value) => value < 40), isFalse);
    });

    test('expect should return value for Some', () {
      const option = Some(42);
      expect(option.expect('should not throw'), 42);
    });

    test('expect should throw for None', () {
      const option = None();
      expect(() => option.expect('should throw'), throwsA(isA<ExpectError>()));
    });

    test('unwrap should return value for Some', () {
      const option = Some(42);
      expect(option.unwrap(), 42);
    });

    test('unwrap should throw for None', () {
      const option = None();
      expect(() => option.unwrap(), throwsA(isA<UnwrapError>()));
    });

    test('unwrapOr should return value for Some', () {
      const option = Some(42);
      expect(option.unwrapOr(0), 42);
    });

    test('unwrapOr should return default value for None', () {
      const option = None<int>();
      expect(option.unwrapOr(0), 0);
    });

    test('unwrapOrElse should return value for Some', () {
      const option = Some(42);
      expect(option.unwrapOrElse(() => 0), 42);
    });

    test('unwrapOrElse should return result of function for None', () {
      const option = None<int>();
      expect(option.unwrapOrElse(() => 0), 0);
    });

    test('map should transform Some value', () {
      const option = Some(42);
      final mapped = option.map((value) => value.toString());
      expect(mapped, isA<Some>());
      expect(mapped.unwrap(), '42');
    });

    test('map should be None for None', () {
      const option = None<int>();
      final mapped = option.map((value) => value.toString());
      expect(mapped, isA<None>());
    });

    test('operator | should return self for Some', () {
      const option = Some(42);
      const other = Some(0);
      expect(option | other, option);
    });

    test('operator | should return other for None', () {
      const option = None<int>();
      const other = Some(0);
      expect(option | other, other);
    });

    test('toNullable should return value for Some', () {
      const option = Some(42);
      expect(option.toNullable(), 42);
    });

    test('toNullable should return null for None', () {
      const option = None();
      expect(option.toNullable(), isNull);
    });
  });

  group('Some', () {
    test('toString should be correct', () {
      const some = Some(42);
      expect(some.toString(), 'Some<int>(42)');
    });

    test('== should be true for same value', () {
      const some1 = Some(42);
      const some2 = Some(42);
      expect(some1 == some2, isTrue);
    });

    test('== should be true even for non-const value', () {
        final some1 = Some(42);
        final some2 = Some(42);
        expect(some1 == some2, isTrue);
    });

    test('== should be false for different value', () {
      const some1 = Some(42);
      const some2 = Some(43);
      expect(some1 == some2, isFalse);
    });


    test('hashCode should be same for same value', () {
      const some1 = Some(42);
      const some2 = Some(42);
      expect(some1.hashCode, some2.hashCode);
    });
  });

  group('None', () {
    test('toString should be correct', () {
      const none = None();
      expect(none.toString(), 'None');
    });

    test('== should be true for any None', () {
      const none1 = None<int>();
      const none2 = None<String>();
      expect(none1 == none2, isTrue);
    });

    test('hashCode should be same for any None', () {
      const none1 = None<int>();
      const none2 = None<String>();
      expect(none1.hashCode, none2.hashCode);
    });
  });
}
