import 'package:dartz/dartz.dart';
import 'package:number_trivia_app/core/errors/failure.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  /// Gets concrete number trivia with the passed number
  /// if the network is present.
  ///
  /// Else return locally cached data which was stored previously
  ///
  /// Throws [ServerFailure] in case of any network failure
  /// and [CacheFailure] in case of local data failure
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);

  /// Gets random number trivia with the passed number
  /// if the network is present.
  ///
  /// Else return locally cached data which was stored previously
  ///
  /// Throws [ServerFailure] in case of any network failure
  /// and [CacheFailure] in case of local data failure
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
