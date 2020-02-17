import 'package:args/command_runner.dart';
import 'package:byteplot/src/utilities/utilities.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:yamlicious/yamlicious.dart';

class BrandingAddSubCommand extends Command {
  BrandingAddSubCommand() {
    argParser.addOption('name',
        abbr: 'n', help: 'The name of the app.', valueHelp: 'CounterApp');
    argParser.addOption('bundle_identifier',
        abbr: 'b',
        help:
            'The bundle identifier (on iOS) or application identifier (on Android).',
        valueHelp: 'com.example.counterapp');
    argParser.addOption('development_team',
        abbr: 'd',
        help: 'The Apple Development Team identifier.',
        defaultsTo: '',
        valueHelp: '1A2B3C4D5E');
  }

  @override
  String get name => 'add';

  @override
  String get description => 'Add a brand to your Flutter project.';

  @override
  Future<void> run() async {
    projectRootCheck();

    var brandingConfig = {};
    var newBrandingConfig = {};

    if (argResults.rest.isEmpty) {
      printErrorAndExit('No brand alias specified');
    } else if (argResults.rest.length > 1) {
      printErrorAndExit('Too many arguments specified');
    }

    if (argResults['name'] == null) {
      printErrorAndExit('No app name specified');
    }

    if (argResults['bundle_identifier'] == null) {
      printErrorAndExit('No bundle identifier specified');
    }

    //printProgress('Adding ${argResults.rest.first} brand');

    if (!fs.file('branding_config.yaml').existsSync()) {
      await fs
          .file(join(byteplotDirPath,
              'lib/src/commands/branding/files/branding_config.yaml'))
          .copy('branding_config.yaml');
      brandingConfig =
          await loadYaml(await fs.file('branding_config.yaml').readAsString());
    } else {
      brandingConfig =
          await loadYaml(await fs.file('branding_config.yaml').readAsString());
    }

    newBrandingConfig[argResults.rest.first] = {
      'alias': argResults.rest.first,
      'app_name': argResults['name'],
      'bundle_identifier': argResults['bundle_identifier'],
      'development_team': argResults['development_team']
    };

    if (brandingConfig != null) {
      await newBrandingConfig.addAll(brandingConfig);
    }

    await fs
        .file('branding_config.yaml')
        .writeAsString(toYamlString(newBrandingConfig));

    //printSuccess('Added ${argResults.rest.first} brand');
  }
}
