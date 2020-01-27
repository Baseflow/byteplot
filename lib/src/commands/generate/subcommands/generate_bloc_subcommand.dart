import 'package:args/command_runner.dart';
import 'package:byteplot/src/utilities/utilities.dart';
import 'package:file/file.dart';

import 'package:path/path.dart' as path;

import 'package:mustache/mustache.dart' as mustache;
import 'package:mustache_recase/mustache_recase.dart' as mustache_recase;
import 'package:path/path.dart';

class GenerateBlocSubCommand extends Command {
  GenerateBlocSubCommand() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Specify the path where the bloc needs to be rendered.',
    );
  }

  @override
  String get name => 'bloc';

  @override
  String get description => 'Generate a BLoC snippet';

  Map<String, dynamic> context = {}..addAll(mustache_recase.cases);

  @override
  Future<void> run() async {
    if (argResults.rest.isEmpty) {
      printErrorAndExit('No bloc name specified');
    } else if (argResults.rest.length > 1) {
      printErrorAndExit('Too many arguments specified');
    }

    final _sourceDir =
        fs.directory(join(libDirPath, 'src/commands/generate/files/bloc'));
    var _destinationDir = fs.currentDirectory;

    if (argResults['path'] != null) {
      _destinationDir = fs.directory(argResults['path']);
    }

    context['blocName'] = argResults.rest.first;

    await _generateBloc(_sourceDir, _destinationDir);
  }

  Future<void> _generateBloc(
      Directory sourceDir, Directory destinationDir) async {
    await for (var entity in sourceDir.list(recursive: false)) {
      if (entity is Directory) {
        var newDirPath = path
            .join(destinationDir.absolute.path, path.basename(entity.path))
            .replaceAll('blocName', context['blocName'])
            .replaceAll('.tmpl', '');
        var newDir = fs.directory(newDirPath);
        await newDir.create();
        await _generateBloc(entity.absolute, newDir);
      } else if (entity is File) {
        final entityString = await entity.readAsString();
        final renderedContents =
            mustache.Template(entityString).renderString(context);
        var filePath = path
            .join(destinationDir.path, path.basename(entity.path))
            .replaceAll('blocName', context['blocName'])
            .replaceAll('.tmpl', '');
        var newFile = fs.file(filePath);
        await newFile.writeAsString(renderedContents);
      }
    }
  }
}
