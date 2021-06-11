import 'dart:convert';

import 'package:number_trivia_app/core/errors/exceptions.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSources {
  /// Gets the chached [NumberTriviaModel] which was gotten the last time
  ///  when the user had an internet connection
  ///
  /// Throws [CacheException] if no cache is there.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Cache the number trivia [NumberTriviaModel] which was gotten the last time
  /// when the user had an internet connection
  ///
  /// Throws [CacheException] in case of saving faliure
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourcesImpl implements NumberTriviaLocalDataSources {
  final SharedPreferences _sharedPreferences;
  NumberTriviaLocalDataSourcesImpl(this._sharedPreferences);

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonData = _sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (jsonData != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonData)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel) async {
    final numberTriviaModelString = jsonEncode(triviaModel.toJson());
    await _sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, numberTriviaModelString);
  }
}
