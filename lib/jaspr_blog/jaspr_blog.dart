import 'dart:io';

import 'package:jaspr/jaspr.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/layout.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:path/path.dart' as p;
import 'package:jaspr_router/jaspr_router.dart';

class JasprBlog {
  ConfigModel? configModel;
  final List<PageModel> pages = [];
  final List<StyleRule> styles = [];
  final _templateFactory = TemplateFactory();

  void addTemplate(String template, TemplateBuilder builder) {
    _templateFactory.register(template, builder);
  }

  static Layout _buildDefaultLayout(
      ConfigModel? config, List<Component> children) {
    return Layout(config, null, children);
  }

  LayoutBuilder _layoutBuilder = _buildDefaultLayout;
  void setDefaultLayout(LayoutBuilder layoutBuilder) {
    _layoutBuilder = layoutBuilder;
  }

  Component _layout(PageModel page) {
    var pageTemplate = _templateFactory.getInstance(page.layoutId, page);
    var layout = _layoutBuilder(configModel, [pageTemplate]);
    return layout;
  }

  void _generateFrom(Directory directory, Directory baseDirectory) {
    var pages = <PageModel>[];

    for (final child in directory.listSync()) {
      if (child is File && child.path.endsWith(".md")) {
        pages.add(PageModel.from(child, baseDirectory));
      } else if (child is Directory) {
        _generateFrom(child, baseDirectory);
      }
    }
    pages.sort((a, b) => a.date?.compareTo(b.date ?? DateTime.now()) ?? -1);

    this.pages.addAll(pages);

    if (directory != baseDirectory) {
      var index = PageModel.index(directory, baseDirectory, pages);
      this.pages.add(index);
    }
  }

  void generateFrom(Directory directory) {
    pages.clear();
    var configFile = File(p.join(directory.path, "config.yaml"));
    if (configFile.existsSync()) {
      configModel = ConfigModel.parse(configFile);
    }
    _generateFrom(directory, directory);
  }

  List<RouteBase> buildRoutes() {
    return pages.map((page) {
      return Route(
          path: page.route,
          builder: (_, __) => Document(
              title: page.title,
              head: [
                link(href: '/styles.css', rel: 'stylesheet'),
              ],
              meta: page.metadata,
              body: _layout(page)));
    }).toList();
  }
}
