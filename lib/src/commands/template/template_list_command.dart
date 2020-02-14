import 'package:args/command_runner.dart';
import 'package:byteplot/src/utilities/utilities.dart';
import 'package:file/file.dart';
import 'package:path/path.dart';

class TemplateListSubCommand extends Command {
  TemplateListSubCommand();

  @override
  String get name => 'list';

  @override
  String get description => 'List the available templates.';

  @override
  Future<void> run() async {
    _listTemplates();
  }

  void _listTemplates() {
    final sourceDir =
        fs.directory(join(byteplotDirPath, 'lib/src/commands/template/files'));

    print('Available templates: ');
    FileSystemEntity entity;
    for (entity in sourceDir.listSync(recursive: false)) {
      if (entity is Directory) {
        print(entity.path.split('/').last);
      }
    }
  }
}
