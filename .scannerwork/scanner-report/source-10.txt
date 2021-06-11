import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia_app/core/errors/exceptions.dart';

import 'package:number_trivia_app/core/errors/failure.dart';
import 'package:number_trivia_app/core/network/network_info.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTrivia> _ConcreteOrRandom();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTirviaRemoteDataSource remoteDataSources;
  final NumberTriviaLocalDataSources localDataSources;
  final NetworkInfo networkInfo;
  NumberTriviaRepositoryImpl({
    @required this.remoteDataSources,
    @required this.localDataSources,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(() => remoteDataSources.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() => remoteDataSources.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandom getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      // if connected then fetch from remote data source
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSources.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // else  fetch from locale data source
      try {
        final remoteTrivia = await localDataSources.getLastNumberTrivia();
        return Right(remoteTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
