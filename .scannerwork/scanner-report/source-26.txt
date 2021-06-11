import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixtrue_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test('should be a subclass of number trivia entiry', () async {
    //arrange

    //act

    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from Json', () {
    test('should return a valid model when the json number is an integer',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when the json number is a double',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return JSON map containing proper data', () async {
      //arrange
      //act
      final result = tNumberTriviaModel.toJson();

      //assert

      final expectedMap = {"text": 'Test text', "number": 1};

      expect(result, expectedMap);
    });
  });
}
