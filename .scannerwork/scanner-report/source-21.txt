import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/errors/failure.dart';
import 'package:number_trivia_app/core/util/inout_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      //arrange
      final str = '123';

      //act
      final result = inputConverter.stringToUnsignedInteger(str);

      //assert
      expect(result, Right(123));
    });

    test(
        'should return an InvalidInputFailure when the string is not an unsigned integer',
        () async {
      //arrange
      final str = 'abc';

      //act
      final result = inputConverter.stringToUnsignedInteger(str);

      //assert
      expect(result, Left(InvalidInputFailure()));
    });

    test(
        'should return an InvalidInputFailure when the string is a negative integer',
        () async {
      //arrange
      final str = '-123';

      //act
      final result = inputConverter.stringToUnsignedInteger(str);

      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
