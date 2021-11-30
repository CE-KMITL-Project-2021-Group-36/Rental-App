import 'package:dartz/dartz.dart';
import 'package:rental_app/domain/auth/auth_failure.dart';
import 'package:rental_app/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  //Unit is just a void
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}
