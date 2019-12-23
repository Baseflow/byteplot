import 'dart:io';

import 'package:byteplot/src/utilities/utilities.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart';

const FileSystem localFileSystem = LocalFileSystem();

FileSystem get fs => localFileSystem;

Directory get execDir => fs.directory(Platform.script.path).parent.parent;
String get execDirPath => execDir.path;

Directory get binDir => fs.directory(Platform.script.path).parent;
String get binDirPath => binDir.path;

Directory get libDir => fs.directory(join(binDir.parent.path, 'lib'));
String get libDirPath => libDir.path;

void projectRootCheck() {
  if(!fs.file('pubspec.yaml').existsSync()) {
    printErrorAndExit('Please perform this action from project root.');
  }
}