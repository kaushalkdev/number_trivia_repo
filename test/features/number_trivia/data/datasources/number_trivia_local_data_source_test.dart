import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/errors/exceptions.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import '../../../../fixtures/fixtrue_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourcesImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourcesImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumbertriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPrefences when there is one in the cache',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      //act
      final result = await dataSource.getLastNumberTrivia();

      //assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumbertriviaModel));
    });

    test('should throw CacheException when there is no cache value', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      //act
      final call = dataSource.getLastNumberTrivia;

      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');
    test('should call SharedPreferences to chache the data', () async {
      //act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      //assert
      final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });
}
