import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

AnsiPen _green = AnsiPen()..green();
AnsiPen _red = AnsiPen()..red();

void print(message) => stdout.writeln(message);

void printSuccess(message) => stdout.writeln(_green(message));

void printError(message) => stdout.writeln(_red(message));

void printErrorAndExit(message) {
  printError(message);
  exit(64);
}
