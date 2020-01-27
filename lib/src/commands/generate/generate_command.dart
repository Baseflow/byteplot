import 'package:args/command_runner.dart';
import 'package:byteplot/src/commands/generate/subcommands/generate_bloc_subcommand.dart';

class GenerateCommand extends Command {
  GenerateCommand() {
    addSubcommand(GenerateBlocSubCommand());
  }

  @override
  String get name => 'generate';

  @override
  String get description => 'Generate a code snippet.';
}
