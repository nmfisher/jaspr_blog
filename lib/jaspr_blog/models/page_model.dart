import 'dart:io';
import 'dart:math';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class PageModel {
  final String? layoutId;
  final String? templateId;
  final String title;
  final String route;
  final Map<String, String>? metadata;
  final String markdown;
  final DateTime? date;
  final String? blurb;
  final String source;
  final bool draft;

  PageModel(
      {required this.title,
      required this.route,
      required this.markdown,
      required this.source,
      this.draft = true,
      this.metadata,
      this.layoutId,
      this.templateId,
      this.date,
      this.blurb});

  ///
  /// Parse a Markdown (.md) file.
  ///
  factory PageModel.from(File file, Directory baseDir) {
    var content = file.readAsStringSync();
    var split = content.split("---").skip(1).toList();

    var doc = loadYaml(split[0]);

    if (doc == null) {
      throw Exception(
          "Failed to parse markdown @ ${file.path} (content was ${content})");
    }

    var layoutId = doc["layout"];
    var templateId = doc["template"] ?? p.basename(file.parent.path);

    var title = doc["title"];
    DateTime? date;
    if (doc["date"] != null) {
      try {
        date = DateTime.parse(doc["date"]);
      } catch (err) {
        print("Error parsing date : $err");
        // pass
      }
    }

    var markdown = split[1];

    var html = md.markdownToHtml(markdown);

    var blurb = html
        .substring(0, min(html.length, 200))
        .replaceAll("\n", " ")
        .replaceAll(RegExp("<[^>]*>"), "")
        .replaceAll(RegExp(r"{{}}"), "");
    var metadata = <String, String>{
      "og:description": blurb,
      "og:title": title.replaceAll("&quot;", "")
    };

    if (doc["meta"] != null) {
      for (final key in doc["meta"].keys) {
        metadata[key] = doc["meta"][key].toString();
      }
    }

    var route = doc["route"];

    route ??= p.basename(file.path) == "index.md"
        ? "/"
        : file.path.replaceAll(baseDir.path, "").replaceAll(".md", "");

    return PageModel(
        source: file.path,
        layoutId: layoutId,
        templateId: templateId,
        title: title,
        route: route,
        date: date,
        blurb: blurb,
        markdown: markdown,
        metadata: metadata,
        draft: doc["draft"]);
  }

  ///
  /// Creates a PageModel representing the "index" for a number of sub-pages (e.g. the "Articles" page for a blog)  .
  ///
  factory PageModel.index(
      Directory directory, Directory baseDirectory, List<PageModel> children) {
    var fullpath = directory.path.replaceAll(baseDirectory.path, "");
    var dirname = p.basename(directory.path);
    var title = dirname[0].toUpperCase() + dirname.substring(1);

    var indexConfigFile = File(p.join(directory.path, "config.yaml"));

    if (indexConfigFile.existsSync()) {
      var indexConfig = loadYaml(indexConfigFile.readAsStringSync());
      title = indexConfig["title"];
    }

    return PageIndexPageModel(
        source: directory.path,
        title: title,
        route: fullpath,
        children: children);
  }
}

class PageIndexPageModel extends PageModel {
  final List<PageModel> children;

  PageIndexPageModel(
      {required this.children,
      required super.source,
      required super.title,
      required super.route,
      super.markdown = "",
      super.templateId = "index",
      super.draft = false}) {}
}
