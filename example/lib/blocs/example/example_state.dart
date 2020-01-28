import 'package:equatable/equatable.dart';

abstract class ExampleState extends Equatable {
  const ExampleState();
}

class InitialExampleState extends ExampleState {
  @override
  List<Object> get props => [];
}
