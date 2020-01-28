import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  @override
  ExampleState get initialState => InitialExampleState();

  @override
  Stream<ExampleState> mapEventToState(
    ExampleEvent event,
  ) async* {
    // TODO: Add Logic
  }
}