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

  Future<void> run() async {
    _listTemplates();
  }

  void _listTemplates() {
    final Directory sourceDir =
        fs.directory(join(libDirPath, 'src/commands/template/files'));

    print("Available templates: ");
    for (FileSystemEntity entity in sourceDir.listSync(recursive: false)) {
      if (entity is Directory) {
        print(entity.path.split('/').last);
      }
    }
  }
}
