import 'dart:io';

import 'package:jaspr/jaspr.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/layout.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/layout_factory.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:path/path.dart' as p;
import 'package:jaspr_router/jaspr_router.dart';

class JasprBlog {
  ConfigModel? configModel;
  final List<PageModel> pages = [];
  final List<StyleRule> styles = [];
  final _templateFactory = TemplateFactory();
  final _layoutFactory = LayoutFactory();

  void addTemplate(String name, TemplateBuilder builder) {
    _templateFactory.register(name, builder);
  }

  void addLayout(String name, LayoutBuilder builder) {
    _layoutFactory.register(name, builder);
  }

  void setDefaultLayout(LayoutBuilder layoutBuilder) {
    _layoutFactory.setDefault(layoutBuilder);
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
        pages.add(PageModel.from(child, baseDirectory));
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
