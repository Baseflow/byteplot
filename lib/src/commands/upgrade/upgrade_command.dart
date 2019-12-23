import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:byteplot/src/utilities/utilities.dart';

class UpgradeCommand extends Command {
  UpgradeCommand();

  @override
  String get name => 'upgrade';

  @override
  String get description => 'Upgrade to the newest version of the CLI.';

  Future<void> run() async {
    //print('Upgrading BytePlot CLI');
    await Process.run('pub', ['global', 'activate', 'byteplot'])
        .then((ProcessResult results) {
      if (results.exitCode == 0) {
        printSuccess(results.stdout);
      } else {
        printError(results.stderr);
      }
    });
  }
}
