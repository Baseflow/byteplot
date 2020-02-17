import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:byteplot/src/utilities/utilities.dart';

class CreateCommand extends Command {
  CreateCommand() {
    argParser.addFlag(
      'pub',
      defaultsTo: true,
      help:
          'Whether to run "flutter pub get" after the project has been created.',
    );
    argParser.addFlag(
      'offline',
      defaultsTo: false,
      help:
          'When "flutter pub get" is run by the create command, this indicates '
          'whether to run it in offline mode or not. In offline mode, it will need to '
          'have all dependencies already available in the pub cache to succeed.',
    );
    argParser.addFlag(
      'with-driver-test',
      negatable: true,
      defaultsTo: false,
      help:
          "Also add a flutter_driver dependency and generate a sample 'flutter drive' test.",
    );
    argParser.addOption(
      'template',
      abbr: 't',
      allowed: ['app', 'package', 'plugin'],
      help: 'Specify the type of project to create.',
      valueHelp: 'type',
      allowedHelp: <String, String>{
        'app': '(default) Generate a Flutter application.',
        'package': 'Generate a shareable Flutter project containing modular '
            'Dart code.',
        'plugin': 'Generate a shareable Flutter project containing an API '
            'in Dart code with a platform-specific implementation for Android, for iOS code, or '
            'for both.',
      },
      defaultsTo: null,
    );
    argParser.addOption(
      'sample',
      abbr: 's',
      help:
          'Specifies the Flutter code sample to use as the main.dart for an application. Implies '
          '--template=app. The value should be the sample ID of the desired sample from the API '
          'documentation website (http://docs.flutter.dev). An example can be found at '
          'https://master-api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html',
      defaultsTo: null,
      valueHelp: 'id',
    );
    argParser.addOption(
      'list-samples',
      help:
          'Specifies a JSON output file for a listing of Flutter code samples '
          'that can created with --sample.',
      valueHelp: 'path',
    );
    argParser.addFlag(
      'overwrite',
      negatable: true,
      defaultsTo: false,
      help: 'When performing operations, overwrite existing files.',
    );
    argParser.addOption(
      'description',
      defaultsTo: 'A new Flutter project.',
      help:
          'The description to use for your new Flutter project. This string ends up in the pubspec.yaml file.',
    );
    argParser.addOption(
      'org',
      defaultsTo: 'com.example',
      help:
          'The organization responsible for your new Flutter project, in reverse domain name notation. '
          'This string is used in Java package names and as prefix in the iOS bundle identifier.',
    );
    argParser.addOption(
      'project-name',
      defaultsTo: null,
      help:
          'The project name for this new Flutter project. This must be a valid dart package name.',
    );
    argParser.addOption(
      'ios-language',
      abbr: 'i',
      defaultsTo: 'swift',
      allowed: <String>['objc', 'swift'],
    );
    argParser.addOption(
      'android-language',
      abbr: 'a',
      defaultsTo: 'kotlin',
      allowed: <String>['java', 'kotlin'],
    );
    argParser.addFlag(
      'androidx',
      negatable: true,
      defaultsTo: false,
      help: 'Generate a project using the AndroidX support libraries',
    );
    argParser.addFlag(
      'web',
      negatable: true,
      defaultsTo: false,
      hide: true,
      help: '(Experimental) Generate the web specific tooling. Only supported '
          'on non-stable branches',
    );
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Create a brand new Flutter project.';

  @override
  Future<void> run() async {
    if (argResults.rest.isEmpty) {
      printErrorAndExit('No project name specified.');
    } else if (argResults.rest.isNotEmpty) {
      //printProgress('Creating Flutter project');

      var arguments = ['create'];
      arguments.addAll(argResults.arguments);

      await Process.run('flutter', arguments)
          .then((ProcessResult results) {
        if (results.exitCode == 0) {
          //printSuccess('Created ${argResults.rest.first} project');
        } else {
          printErrorAndExit(results.stderr);
        }
      });
    }
  }
}
