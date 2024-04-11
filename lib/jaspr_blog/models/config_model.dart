import 'dart:io';
import 'package:yaml/yaml.dart';

class ConfigModel {
  final String title;
  final String owner;
  final Map<String, dynamic> metadata;

  ConfigModel(this.title, this.metadata, this.owner);

  factory ConfigModel.parse(File configFile) {
    var cfg = loadYaml(configFile.readAsStringSync());
    return ConfigModel(cfg["title"], cfg["metadata"] ?? {}, cfg["owner"]);
  }
}
