import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/simple_bloc_delegate.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:example/localizations.dart';

import 'package:example/blocs/blocs.dart';
import 'package:example/screens/screens.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      home: BlocProvider<ExampleBloc>(
        create: (context) => ExampleBloc(),
        child: ExampleScreen(),
      ),
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
    );
  }
}
