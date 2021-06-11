import 'dart:convert';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/errors/exceptions.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixtrue_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

main() {
  NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure400() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test('''should perform a GET request ona URL with number being 
        the endpoint and with application-json headder''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSourceImpl.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return Numbertrivia when the response code is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);

      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when the response code is 400 or other',
        () async {
      //arrange
      setUpMockHttpClientFailure400();
      //act
      final call = dataSourceImpl.getConcreteNumberTrivia;

      //assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test('''should perform a GET request ona URL with number being 
        the endpoint and with application-json headder''', () async {
      //arrange
      setUpMockHttpClientSuccess200();

      //act
      dataSourceImpl.getRandomNumberTrivia();

      //assert
      verify(mockHttpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return Numbertrivia when the response code is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSourceImpl.getRandomNumberTrivia();

      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when the response code is 400 or other',
        () async {
      //arrange
      setUpMockHttpClientFailure400();
      //act
      final call = dataSourceImpl.getRandomNumberTrivia();

      //assert
      expect(() => call, throwsA(TypeMatcher<ServerException>()));
    });
  });
}
