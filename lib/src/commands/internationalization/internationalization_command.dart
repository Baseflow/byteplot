import 'package:args/command_runner.dart';
import 'package:byteplot/src/commands/internationalization/subcommands/internationalization_add_subcommand.dart';

class InternationalizationCommand extends Command {
  InternationalizationCommand() {
    addSubcommand(InternationalizationAddSubCommand());
  }

  @override
  String get name => 'intl';

  @override
  String get description =>
      'Manage internationalization in your Flutter project.';
}
