import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:byteplot/src/utilities/utilities.dart';

import 'package:path/path.dart' as path;

import 'package:mustache/mustache.dart' as mustache;
import 'package:mustache_recase/mustache_recase.dart' as mustache_recase;
import 'package:path/path.dart';

class TemplateApplySubCommand extends Command {
  TemplateApplySubCommand() {
    argParser.addFlag('internationalization',
        abbr: 'i',
        help: 'Specify wheter to include support for internationalization',
        defaultsTo: false);
  }

  @override
  String get name => 'apply';

  @override
  String get description => 'Apply a template to your Flutter project.';

  Map<String, dynamic> _context = {}..addAll(mustache_recase.cases);

  Future<void> run() async {
    projectRootCheck();

     if (argResults.rest.isEmpty) {
      printErrorAndExit('No template specified');
    } else if (argResults.rest.length > 1) {
      printErrorAndExit('Too many arguments specified');
    }

    final Directory _sourceDir = fs.directory(join(libDirPath, 'src/commands/template/files/${argResults.rest.first}'));
    final Directory _destinationDir = fs.currentDirectory;

    _context['projectName'] = _destinationDir.path.split('/').last;
    _context['internationalization'] = argResults['internationalization'];

    await _renderTemplate(_sourceDir, _destinationDir);
  }

  Future<void> _renderTemplate(
      Directory sourceDir, Directory destinationDir) async {
    await for (var entity in sourceDir.list(recursive: false)) {
      if (entity.path.contains('.DS_Store')) {
        await entity.delete();
      }

      if (entity is Directory) {
        if (entity.path.contains('.intl') &&
            argResults['internationalization'] == false) {
          return;
        }

        String newDirPath = path
            .join(destinationDir.absolute.path, path.basename(entity.path))
            .replaceAll('projectName', _context['projectName'])
            .replaceAll('.tmpl', '')
            .replaceAll('.intl', '');
        var newDir = fs.directory(newDirPath);
        await newDir.create();
        await _renderTemplate(entity.absolute, newDir);
      } else if (entity is File) {
        if (entity.path.contains('.intl') &&
            !argResults['internationalization']) {
          return;
        }

        final String entityString = entity.readAsStringSync();
        final String renderedContents =
            mustache.Template(entityString).renderString(_context);
        String filePath = path
            .join(destinationDir.path, path.basename(entity.path))
            .replaceAll('projectName', _context['projectName'])
            .replaceAll('.tmpl', '')
            .replaceAll('.intl', '');
        File newFile = fs.file(filePath);
        await newFile.writeAsString(renderedContents);
      }
    }
  }
}
