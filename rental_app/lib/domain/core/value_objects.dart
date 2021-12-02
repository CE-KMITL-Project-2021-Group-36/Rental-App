import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_app/domain/core/errors.dart';

import 'failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();

  Either<ValueFailure<T>, T> get value;

  T getOrCrash() {
    return value.fold((l) => throw UnexpectedValueError(l), (r) => r);
  }

  bool isValid() => value.isRight();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ValueObject &&
          runtimeType == other.runtimeType &&
          value == other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'ValueObject{' ' value: $value,' '}';
  }
}

//todo
// class UniqueId extends ValueObject<String> {
//   @override
//   final Either<ValueFailure, String> value;
//
//   factory UniqueId() {
//     return UniqueId._(
//         //
//         );
//   }
//
//   factory UniqueId.fromUniqueString(String? uniqueId) {
//     return UniqueId._(
//         //
//         );
//   }
// }
