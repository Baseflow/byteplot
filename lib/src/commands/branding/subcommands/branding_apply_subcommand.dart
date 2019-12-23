import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:byteplot/src/utilities/utilities.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

class BrandingApplySubCommand extends Command {
  BrandingApplySubCommand();

  @override
  String get name => 'apply';

  @override
  String get description => 'Apply a brand to your Flutter project.';

  Map _brandingConfig = {};
  Map _brand = {};

  Future<void> run() async {
    projectRootCheck();

    if (argResults.rest.isEmpty) {
      printErrorAndExit('No brand alias specified.');
    } else if (argResults.rest.length == 1) {
      _brandingConfig = await _loadConfig();
      _brand = _setBrand(brandAlias: argResults.rest.first);
      await _replaceIOSBundleIdentifier();
      await _replaceIOSDevelopmentTeam();
      await _replaceAndroidBundleIdentifier();
      await _replaceAndroidApplicationId();
      await _applyBrandFiles();
      //printSuccess('Replaced brand files...');
    } else if (argResults.rest.length > 1) {
      printErrorAndExit('Too many arguments specified');
    }
  }

  Future<dynamic> _loadConfig() async {
    //printProgress('Loading config');
    if (fs.file('branding_config.yaml').existsSync()) {
      //printSuccess('Loaded config');
      return await loadYaml(await fs.file('branding_config.yaml').readAsString());
    } else {
      printErrorAndExit('No branding config found.');
    }
  }

  Map _setBrand({String brandAlias}) {
    if (_brandingConfig[brandAlias] != null) {
      return _brandingConfig[brandAlias];
    } else {
      printErrorAndExit('Brand not found in config.');
    }
    return null;
  }

  _replaceIOSBundleIdentifier() async {
    File sourceFile = fs.file(_brandingConfig['PATH_TO_PBXPROJ']);
    await sourceFile.readAsString().then((String sourceFileString) {
      sourceFile.writeAsStringSync(sourceFileString.replaceAll(
          RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = .*?;'),
          'PRODUCT_BUNDLE_IDENTIFIER = ${_brand['bundle_identifier']};'));
    });
    //printSuccess('Replaced bundle identifier in Xcode project file');
  }

  _replaceIOSDevelopmentTeam() async {
    File sourceFile = fs.file(_brandingConfig['PATH_TO_PBXPROJ']);
    await sourceFile.readAsString().then((String sourceFileString) {
      sourceFile.writeAsString(sourceFileString.replaceAll(
          RegExp(r'DEVELOPMENT_TEAM = .*?;'),
          'DEVELOPMENT_TEAM = ${_brand['development_team']};'));
    });
    //printSuccess('Replaced development team in Xcode project file');
  }

  _replaceAndroidBundleIdentifier() async {
    File sourceFile = fs.file(_brandingConfig['PATH_TO_ANDROIDMANIFEST']);
    await sourceFile.readAsString().then((String sourceFileString) {
      sourceFile.writeAsString(sourceFileString.replaceAll(
          RegExp(r'package=".*?"'),
          'package="${_brand['bundle_identifier']}"'));
    });
    //printSuccess('Replaced bundle identifier in Android Manifest...');
  }

  _replaceAndroidApplicationId() async {
    final File sourceFile = fs.file(_brandingConfig['PATH_TO_BUILDGRADLE']);
    await sourceFile.readAsString().then((String sourceFileString) {
      sourceFile.writeAsString(sourceFileString.replaceAll(
          RegExp(r'applicationId ".*?"'),
          'applicationId "${_brand['bundle_identifier']}"'));
    });
    //printSuccess('Replaced application id in build.gradle...');
  }

  _applyBrandFiles() async {
    Directory sourceDir = fs.directory(path.join(
        _brandingConfig['PATH_TO_PROJECT_BRANDING_FOLDER'], _brand['alias']));
    Directory destinationDir = fs.directory(_brandingConfig['PATH_TO_PROJECT_DESTINATION_FOLDER']);

   await _replaceBrandFiles(sourceDir, destinationDir);
  }

  Future<void> _checkFolderStructure(
      Directory sourceDir, Directory destinationDir) async {
    bool correctStructure = true;

    await for (var sourceDirEntity in sourceDir.list(recursive: true)) {

      String sourceDirEntityPath = sourceDirEntity.path.split(
          _brandingConfig['PATH_TO_PROJECT_BRANDING_FOLDER'] + _brand['alias'] + "/")[1];
    
      if (sourceDirEntity is Directory) {
        if (!fs
            .directory(path.join(_brandingConfig['PATH_TO_PROJECT_DESTINATION_FOLDER'], sourceDirEntityPath))
            .existsSync()) {
          printError(
              sourceDirEntityPath + ' directory doesn\'t exists in project.');
          correctStructure = false;
        }
      }
      if (sourceDirEntity is File) {
        if (!fs
            .file(path.join(_brandingConfig['PATH_TO_PROJECT_DESTINATION_FOLDER'], sourceDirEntityPath))
            .existsSync()) {
          printError(sourceDirEntityPath + ' file doesn\'t exists in project.');
          correctStructure = false;
        }
      }
    }
    if (!correctStructure) {
      print(" ");
      printErrorAndExit(
          'Please match your branding folder structure with the project folder structure.');
    }
  }

  Future<void> _replaceBrandFiles(
      Directory sourceDir, Directory destinationDir) async {
    await _checkFolderStructure(sourceDir, destinationDir);

    await for (var entity in sourceDir.list(recursive: false)) {


      if (entity is Directory) {
        var newDirectory = fs.directory(
            path.join(destinationDir.absolute.path, path.basename(entity.path)));
        await newDirectory.create();
        await _replaceBrandFiles(entity.absolute, newDirectory);
      } else if (entity is File) {
        await entity.copy(path.join(destinationDir.path, path.basename(entity.path)));
      }
    }
  }
}
