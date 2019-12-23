
import 'package:args/command_runner.dart';
import 'package:byteplot/src/commands/template/template_apply_subcommand.dart';
import 'package:byteplot/src/commands/template/template_list_command.dart';

class TemplateCommand extends Command {
  TemplateCommand() {
    addSubcommand(TemplateApplySubCommand());
    addSubcommand(TemplateListSubCommand());
  }

  @override
  String get name => 'template';

  @override
  String get description => 'Manage templates in your Flutter project.';

  Future<void> run() async {}
}
