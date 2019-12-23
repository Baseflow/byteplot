import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:byteplot/src/commands/commands.dart';
import 'package:byteplot/src/utilities/utilities.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('byteplot', 'The official BytePlot command-line interface.')
    ..addCommand(TemplateCommand())
    ..addCommand(InternationalizationCommand())
    ..addCommand(CreateCommand())
    ..addCommand(GenerateCommand())
    ..addCommand(BrandingCommand())
    ..addCommand(UpgradeCommand());
  try {
    await versionCheck();
    await runner.run(arguments);
  } catch (error) {
    stderr.writeln(error);
  }
}