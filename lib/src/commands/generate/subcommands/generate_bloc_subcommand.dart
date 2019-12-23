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

  Map<String, dynamic> _context = {}..addAll(mustache_recase.cases);

  Future<void> run() async {

    if (argResults.rest.isEmpty) {
      printErrorAndExit('No bloc name specified');
    } else if (argResults.rest.length > 1) {
      printErrorAndExit('Too many arguments specified');
    }

    final Directory _sourceDir = fs.directory(join(libDirPath, 'src/commands/generate/files/bloc'));
    Directory _destinationDir = fs.currentDirectory;
   
    if (argResults['path'] != null) {
      _destinationDir = fs.directory(argResults['path']);
    }

    _context['blocName'] = argResults.rest.first;

    await _generateBloc(_sourceDir, _destinationDir);
  }

  Future<void> _generateBloc(Directory sourceDir, Directory destinationDir) async {
    await for (var entity in sourceDir.list(recursive: false)) {
      if (entity is Directory) {
        String newDirPath = path.join(destinationDir.absolute.path, path.basename(entity.path)).replaceAll('blocName', _context['blocName']).replaceAll('.tmpl', '');
        var newDir = fs.directory(newDirPath);
        await newDir.create();
        await _generateBloc(entity.absolute, newDir);
      } else if (entity is File) {

        final String entityString = await entity.readAsString();
        final String renderedContents = mustache.Template(entityString).renderString(_context);
        String filePath = path.join(destinationDir.path, path.basename(entity.path)).replaceAll('blocName', _context['blocName']).replaceAll('.tmpl', '');
        File newFile = fs.file(filePath);
        await newFile.writeAsString(renderedContents);
      }
    }
  }

  // Map<String /* relative */, String /* absolute source */ > filePaths = <String, String>{};

  // void _render(Directory sourceDir, Directory destinationDir,
  //     Map<String, dynamic> context) {

  //   print('sourceDir: ' + sourceDir.path);
  //   print('destinationDir: ' + destinationDir.path);    
  
  //   final List<FileSystemEntity> templateFiles =
  //       sourceDir.listSync(recursive: true);

  //   for (FileSystemEntity entity in templateFiles) {
  //     if (entity.path.contains('.DS_Store')) {
  //       entity.deleteSync();
  //     }
  //     if (entity is! File) {
  //       continue;
  //     }
  //     final String relativePath = fs.path.relative(entity.path, from: sourceDir.absolute.path);
  //     filePaths[relativePath] = fs.path.absolute(entity.path);
  //     //print(relativePath);
  //   }

  //   destinationDir.createSync(recursive: true);
    
  //   filePaths.forEach((String relativeDestinationPath, String absoluteSourcePath) {
  //     final String destinationDirPath = destinationDir.absolute.path;
     
  //     print(destinationDirPath);

  //     String finalDestinationPath = fs.path
  //         .join(destinationDirPath, relativeDestinationPath)
  //         .replaceAll('blocName', _context['name']);

  //     print(finalDestinationPath);    

  //     if (finalDestinationPath == null) return;

  //     final File finalDestinationFile = fs.file(finalDestinationPath);    
  //     finalDestinationFile.createSync(recursive: true);
  //     final File sourceFile = fs.file(absoluteSourcePath);

  //     context.addAll(mustache_recase.cases);
  //     final String templateContents = sourceFile.readAsStringSync();
  //     final String renderedContents = mustache.Template(templateContents).renderString(context);
  //     finalDestinationFile.writeAsStringSync(renderedContents);    
  //   });  
  // }
}
