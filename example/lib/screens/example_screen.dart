import 'package:example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:example/blocs/example/bloc.dart';

class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example')),
      body: BlocBuilder<ExampleBloc, ExampleState>(
        builder: (BuildContext context, ExampleState state) {
          return ExampleWidget();
        },
      ),
    );
  }
}
