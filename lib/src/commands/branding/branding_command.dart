import 'package:args/command_runner.dart';
import 'package:byteplot/src/commands/branding/subcommands/branding_add_subcommand.dart';
import 'package:byteplot/src/commands/branding/subcommands/branding_apply_subcommand.dart';

class BrandingCommand extends Command {
  BrandingCommand() {
    addSubcommand(BrandingAddSubCommand());
    addSubcommand(BrandingApplySubCommand());
  }

  @override
  String get name => 'branding';

  @override
  String get description => 'Manage whitelabel brands in your Flutter app.';
}
