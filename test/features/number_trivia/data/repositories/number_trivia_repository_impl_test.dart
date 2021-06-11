import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/core/errors/exceptions.dart';
import 'package:number_trivia_app/core/errors/failure.dart';
import 'package:number_trivia_app/core/network/network_info.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSources {
}

class MockRemoteDataSource extends Mock
    implements NumberTirviaRemoteDataSource {}

class MockNetWorkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetWorkInfo mockNetWorkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetWorkInfo = MockNetWorkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSources: mockRemoteDataSource,
      localDataSources: mockLocalDataSource,
      networkInfo: mockNetWorkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetWorkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcerteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test text');
    final NumberTrivia tNumbertrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      //arrange
      when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetWorkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        //arrage
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumbertrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
        //arrage
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return failure when the call to remote data source is unsuccessfull',
          () async {
        //arrage
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cache data when the cache data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumbertrivia)));
      });

      test('should return CacheException when the cache data is not present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'Test text');
    final NumberTrivia tNumbertrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      //arrange
      when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getRandomNumberTrivia();
      //assert
      verify(mockNetWorkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        //arrage
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumbertrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
        //arrage
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        await repository.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return failure when the call to remote data source is unsuccessfull',
          () async {
        //arrage
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        //act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cache data when the cache data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumbertrivia)));
      });

      test('should return CacheException when the cache data is not present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
