import 'package:dartz/dartz.dart';
import 'package:rental_app/domain/core/failures.dart';
import 'package:rental_app/domain/core/value_objects.dart';
import 'package:rental_app/domain/core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) {
    return EmailAddress._(value: validateEmailAddress(input));
  }

  const EmailAddress._({required this.value});
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) {
    return Password._(value: validatePassword(input));
  }

  const Password._({required this.value});
}
