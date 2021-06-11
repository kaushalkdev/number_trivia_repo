import 'package:dartz/dartz.dart';
import 'package:number_trivia_app/core/errors/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw FormatException();
      } else {
        return Right(integer);
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}
