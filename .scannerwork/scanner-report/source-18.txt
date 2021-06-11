import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/util/inout_converter.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';
import '../../domain/entities/number_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required this.getConcreteNumberTrivia,
      @required this.getRandomNumberTrivia,
      @required this.inputConverter})
      : super(Empty());

  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumberEvent) {
      print("event is $event");

      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      print(inputEither);

      // yield* inputEither.fold((failure) async* {
      //   print("A failure");
      //   yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      // }, (integer) async* {
      //   print("A Success");
      // });

    }

    yield Loaded(trivia: NumberTrivia(number: 1, text: "some"));
  }
}
