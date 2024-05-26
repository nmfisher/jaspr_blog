import 'dart:io';
import 'package:yaml/yaml.dart';

class LogoConfig {
  final int? height;
  final int? width;
  final String url;

  LogoConfig(this.height, this.width, this.url);

  factory LogoConfig.fromYaml(YamlMap itemConfig) {
    return LogoConfig(
        itemConfig["height"], itemConfig["width"], itemConfig["url"]);
  }
}

class NavbarLink {
  final String? id;
  final String? route;
  final String text;
  final String classes;
  final Map<String, String> attributes;

  NavbarLink(this.id, this.route, this.text, this.classes, this.attributes);

  factory NavbarLink.fromYaml(YamlMap itemConfig) {
    return NavbarLink(
        itemConfig["id"] ?? "",
        itemConfig["route"],
        itemConfig["text"],
        itemConfig["classes"] ?? "",
        Map<String, String>.from(itemConfig["attributes"] ?? {}));
  }
}

class NavbarConfigModel {
  final String classes;
  final String itemClasses;
  final List<NavbarLink> items;
  final LogoConfig? logoConfig;

  factory NavbarConfigModel.fromYaml(YamlMap navbarConfig) {
    LogoConfig? logoConfig;
    if (navbarConfig.containsKey("logo")) {
      logoConfig = LogoConfig.fromYaml(navbarConfig["logo"]);
    }
    var classes = navbarConfig["classes"];
    var itemClasses = navbarConfig["item-classes"];
    var items = navbarConfig["items"]
        .map((l) => NavbarLink.fromYaml(l))
        .cast<NavbarLink>()
        .toList();
    return NavbarConfigModel(
        classes ?? "", itemClasses ?? "", items, logoConfig);
  }

  NavbarConfigModel(
      this.classes, this.itemClasses, this.items, this.logoConfig);
}

class ConfigModel {
  final String? title;
  final String? owner;
  final Map<String, String> metadata;
  final String? logo;

  final NavbarConfigModel navbarConfigModel;

  ConfigModel({
    this.title,
    required this.metadata,
    this.owner,
    this.logo,
    required this.navbarConfigModel,
  });

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

    print("PARSING CFG $cfg");

    return ConfigModel(
        navbarConfigModel: NavbarConfigModel.fromYaml(cfg["navbar"]),
        title: cfg["title"],
        metadata: metadata,
        owner: cfg["owner"],
        logo: cfg["logo"]);
  }
}
