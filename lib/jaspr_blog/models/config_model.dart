import 'dart:io';
import 'package:yaml/yaml.dart';

class ConfigModel {
  final String? title;
  final String? owner;
  final Map<String, String> metadata;
  final String? logo;

  ConfigModel({this.title, required this.metadata, this.owner, this.logo});

  factory ConfigModel.parse(File configFile) {
    var cfg = loadYaml(configFile.readAsStringSync());
    var metadata = <String, String>{};
    try {
      for (final key in (cfg["meta"] as YamlMap).keys) {
        metadata[key] = cfg["meta"][key] as String;
      }
    } catch (err) {
      print(err);
      // usually if meta is empty, ignore
    }
    return ConfigModel(
        title: cfg["title"],
        metadata: metadata,
        owner: cfg["owner"],
        logo: cfg["logo"]);
  }
}
