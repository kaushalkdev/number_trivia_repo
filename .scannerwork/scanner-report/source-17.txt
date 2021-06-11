part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;
  GetTriviaForConcreteNumberEvent(this.numberString);

  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {
  @override
  List<Object> get props => [];
}
