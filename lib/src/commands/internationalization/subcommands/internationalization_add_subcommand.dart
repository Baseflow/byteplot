import 'package:args/command_runner.dart';
import 'package:byteplot/src/utilities/utilities.dart';
import 'package:file/file.dart';

import 'package:path/path.dart' as path;
import 'package:path/path.dart';

class InternationalizationAddSubCommand extends Command {
  InternationalizationAddSubCommand();

  @override
  String get name => 'add';

  @override
  String get description =>
      'Add internationalization functionality to your Flutter project.';

  @override
  Future<void> run() async {
    projectRootCheck();

    final _sourceDir = fs.directory(join(libDirPath,
        'src/commands/internationalization/files/internationalization'));
    final _destinationDir = fs.directory(fs.currentDirectory.path + '/lib');

    await _addInternationalization(_sourceDir, _destinationDir);
  }

  Future<void> _addInternationalization(
      Directory sourceDir, Directory destinationDir) async {
    await for (var entity in sourceDir.list(recursive: false)) {
      if (entity is Directory) {
        var newDirPath = path.join(destinationDir.absolute.path,
            path.basename(entity.path).replaceAll('.intl', ''));
        var newDir = fs.directory(newDirPath);
        await newDir.create();
        await _addInternationalization(entity.absolute, newDir);
      } else if (entity is File) {
        var filePath = path
            .join(destinationDir.path, path.basename(entity.path))
            .replaceAll('.intl', '');
        await entity.copy(filePath);
      }
    }
  }
}
