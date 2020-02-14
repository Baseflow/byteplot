import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:byteplot/src/utilities/utilities.dart';
import 'package:path/path.dart';
import 'package:version/version.dart';
import 'package:yaml/yaml.dart';

void pubGet() {
  Process.run('flutter', ['pub', 'get']).then((ProcessResult results) {
    if (results.exitCode == 0) {
      printSuccess(results.stdout);
    } else {
      printErrorAndExit(results.stderr);
    }
  });
}

String get byteplotVersion {

  File pubspec = fs.file(join(execDirPath + '/pubspec.yaml'));
  Map pubspecYaml = loadYaml(pubspec.readAsStringSync());

  return pubspecYaml['version'];
}

Future<void> versionCheck() async {
  String currentVersionString;
  String latestVersionString;

  File pubSpecLock = await fs.file(join(execDirPath + '/pubspec.lock'));
  Map pubSpecLockYaml = await loadYaml(pubSpecLock.readAsStringSync());

  if (pubSpecLockYaml == null) {
    return;
  }

  if (pubSpecLockYaml['packages']['byteplot'] != null) {
    currentVersionString =
        pubSpecLockYaml['packages']['byteplot']['version'].toString();
  } else {
    return;
  }

  var response = await http.get('https://pub.dev/api/packages/byteplot');

  if (response.statusCode == 200) {
    Map<String, dynamic> package = jsonDecode(response.body);

    latestVersionString = package['latest']['version'];
  } else {
    return;
  }

  Version currentVersion;
  currentVersion = Version.parse(currentVersionString);

  Version latestVersion;
  latestVersion = Version.parse(latestVersionString);

  if (latestVersion > currentVersion) {
    printError(' ');
    printError('A new version of the BytePlot CLI is available!');
    printError(
        'Run "byteplot upgrade" to update from $currentVersionString to $latestVersionString');
    printError(' ');
  }
}
