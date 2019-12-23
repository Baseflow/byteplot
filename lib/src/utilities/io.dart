import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

AnsiPen _green = AnsiPen()..green();
AnsiPen _red = AnsiPen()..red();
AnsiPen _yellow = AnsiPen()..yellow();

print(message) {
  stdout.writeln(message);
}

printSuccess(message) {
  stdout.writeln(_green(message));
}

printError(message) {
  stdout.writeln(_red(message));
}

printProgress(message) {
  stdout.writeln(_yellow(message));
}

printYellow(message) {
  stdout.writeln(_yellow(message));
}

printErrorAndExit(message) {
  printError(message);
  exit(64);
}
