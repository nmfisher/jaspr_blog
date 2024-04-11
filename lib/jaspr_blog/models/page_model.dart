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

  PageModel(
      {required this.title,
      required this.route,
      required this.markdown,
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

    var route = doc["route"];

    route ??= p.basename(file.path) == "index.md"
        ? "/"
        : file.path.replaceAll(baseDir.path, "").replaceAll(".md", "");

    return PageModel(
        layoutId: layoutId,
        templateId: templateId,
        title: title,
        route: route,
        date: date,
        blurb: blurb,
        markdown: markdown,
        metadata: metadata);
  }

  ///
  /// Creates a PageModel representing the "index" for a number of sub-pages (e.g. the "Articles" page for a blog)  .
  ///
  factory PageModel.index(
      Directory directory, Directory baseDirectory, List<PageModel> children) {
    var fullpath = directory.path.replaceAll(baseDirectory.path, "");
    var dirname = p.basename(directory.path);
    var title = dirname[0].toUpperCase() + dirname.substring(1);
    return PageIndexPageModel(
        title: title, route: fullpath, children: children);
  }
}

class PageIndexPageModel extends PageModel {
  final List<PageModel> children;

  PageIndexPageModel(
      {required this.children,
      required super.title,
      required super.route,
      super.markdown = "",
      super.layoutId = "index"}) {}
}
