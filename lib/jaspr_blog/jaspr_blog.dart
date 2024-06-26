import 'dart:io';

import 'package:jaspr/jaspr.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/basic_hero_layout.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/basic_layout.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/layout_factory.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:path/path.dart' as p;
import 'package:jaspr_router/jaspr_router.dart';

class JasprBlog {
  final bool excludeDraft;
  ConfigModel? configModel;
  final List<PageModel> pages = [];
  final List<StyleRule> styles;
  final _templateFactory = TemplateFactory();
  final _layoutFactory = LayoutFactory();

  JasprBlog(
      {Directory? directory,
      this.excludeDraft = true,
      this.styles = const [
        StyleRule.import("/style.css"),
        StyleRule.import(
            "https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css")
      ]}) {
    directory ??= Directory(Directory.current.path + "/content");
    var configFile = File(p.join(directory.path, "config.yaml"));
    if (!configFile.existsSync()) {
      throw Exception("No config.yaml found under ${directory.path}");
    }
    configModel = ConfigModel.parse(configFile);

    _generateFrom(directory, directory);
    print("Generation complete from ${pages.length} pages");
  }

  void addTemplate(String name, TemplateBuilder builder) {
    _templateFactory.register(name, builder);
  }

  void addLayout(String name, LayoutBuilder builder) {
    _layoutFactory.register(name, builder);
  }

  void setDefaultLayout(LayoutBuilder layoutBuilder) {
    _layoutFactory.setDefault(layoutBuilder);
  }

  Component? _header;
  void addHeaderComponent(Component component) {
    _layoutFactory.setHeader(component);
  }

  void addFooterComponent(Component component) {
    _layoutFactory.setFooter(component);
  }

  Component _layout(PageModel page) {
    var pageTemplate = _templateFactory.getInstance(page.templateId, page);
    var layout = _layoutFactory
        .getInstance(page.layoutId, configModel!, null, [pageTemplate]);
    return layout;
  }

  void _generateFrom(Directory directory, Directory baseDirectory) {
    var pages = <PageModel>[];

    for (final child in directory.listSync()) {
      if (child is File && child.path.endsWith(".md")) {
        try {
          pages.add(PageModel.from(child, baseDirectory));
        } catch (err, st) {
          throw Exception("Error parsing markdown @ ${child.path}\n$err\n$st");
        }
      } else if (child is Directory) {
        _generateFrom(child, baseDirectory);
      }
    }
    pages.sort((a, b) {
      if (a.date == null) {
        return -1;
      }
      if (b.date == null) {
        return 1;
      }
      return b.date!.compareTo(a.date!);
    });

    this.pages.addAll(pages);

    if (directory != baseDirectory &&
        !pages.any((element) => element.source.endsWith("index.md"))) {
      print("Creating index for ${directory.path}");
      var index = PageModel.index(directory, baseDirectory, pages);
      this.pages.add(index);
    }
  }

  Route buildRouteForComponents(
      String route, String title, List<Component> components,
      {String? layoutId}) {
    var layout =
        _layoutFactory.getInstance(layoutId, configModel!, null, components);
    return Route(path: route, builder: (_, __) =>  div([
            Head(
              meta: configModel?.metadata,
              children:[Style(styles: styles)]
            ),
            layout]));
  }

  List<Route> buildRoutes() {
    var routes = pages
        .map((page) {
          if (excludeDraft && page.draft) {
            print("Ignoring draft ${page.title}");
            return null;
          }
          return Route(path: page.route, builder: (_, __) => div([
            Head(
              meta: page.metadata,
              children:[Style(styles: styles)]
            ),
            _layout(page)]));

        })
        .where((x) => x != null)
        .cast<Route>()
        .toList();
    return routes;
  }
}
