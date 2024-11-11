import 'dart:io';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/basic_layout.dart';
import 'package:path/path.dart' as p;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:yaml/yaml.dart';

import 'templates/index_template.dart';

typedef TemplateBuilder = Template Function(PageModel model);
typedef LayoutBuilder = Component Function(ConfigModel, Component children);

class JasprBlog {
  final bool excludeDraft;
  ConfigModel? configModel;
  final List<PageModel> pages = [];
  final List<StyleRule> styles;

  // Template management (formerly TemplateFactory)
  final Map<String, TemplateBuilder> _templateBuilders = {};

  // Layout management (formerly LayoutFactory)
  final Map<String, LayoutBuilder> _layoutBuilders = {};

  JasprBlog(
      {Directory? directory,
      this.excludeDraft = true,
      Map<String, TemplateBuilder>? templates,
      Map<String, LayoutBuilder>? layouts,
      this.styles = const [
        StyleRule.import(
            "https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css"),
        StyleRule.import("/style.css"),
      ]}) {
    // Initialize template builders
    if (templates != null) {
      _templateBuilders.addAll(templates);
    }

    // Initialize layout builders
    if (layouts != null) {
      _layoutBuilders.addAll(layouts);
    }

    // Initialize content
    directory ??= Directory(Directory.current.path + "/content");
    var configFile = File(p.join(directory.path, "config.yaml"));
    if (!configFile.existsSync()) {
      throw Exception("No config.yaml found under ${directory.path}");
    }
    configModel = ConfigModel.parse(configFile);

    _generateFrom(directory, directory);
    print("Generation complete from ${pages.length} pages");
  }

  // Template management methods
  void addTemplate(String name, TemplateBuilder builder) {
    _templateBuilders[name] = builder;
  }

  Template _getTemplate(String? name, PageModel model) {
    var builder = _templateBuilders[name];
    if (builder != null) {
      return builder(model);
    }
    if (model is PageIndexPageModel) {
      return PageIndexTemplate(model, this);
    }
    return Template(model, this);
  }

  // Layout management methods
  void addLayout(String name, LayoutBuilder builder) {
    _layoutBuilders[name] = builder;
  }

  Component _getLayout(
      String? name, ConfigModel configModel, Component children) {
    var builder = _layoutBuilders[name];

    return builder!.call(configModel, children);
  }

  Component _buildPage(PageModel page) {
    var pageTemplate = _getTemplate(page.templateId, page);
    print("Getting page for layout id ${page.layoutId}");

    var layout = page.layoutId == null
        ? _layoutBuilders.values.first.call(configModel!, pageTemplate)
        : _getLayout(page.layoutId, configModel!, pageTemplate);
    return layout;
  }

  void _generateFrom(Directory directory, Directory baseDirectory) {
    var pages = <PageModel>[];

    for (final child in directory.listSync()) {
      if (child is File) {
        if (child.path.endsWith(".md")) {
          try {
            pages.add(PageModel.from(child, baseDirectory));
          } catch (err, st) {
            throw Exception(
                "Error parsing markdown @ ${child.path}\n$err\n$st");
          }
        }
      } else if (child is Directory) {
        _generateFrom(child, baseDirectory);
      }
    }
    pages.sort((a, b) {
      if (a.date == null) return -1;
      if (b.date == null) return 1;
      return b.date!.compareTo(a.date!);
    });

    this.pages.addAll(pages);

    print("Finishing directory ${directory.path}");
    print(pages.map((p) => p.source).join("\n"));

    if (directory != baseDirectory &&
        !pages.any((element) => element.source.endsWith("index.md"))) {
      var index = PageModel.index(directory, baseDirectory, pages);
      this.pages.add(index);
    }
  }

  Route buildRouteForComponents(String route, String title, Component component,
      {String? layoutId}) {
    var layout = _getLayout(layoutId, configModel!, component);
    return Route(path: route, builder: (_, __) => div([layout]));
  }

  List<Route> buildRoutes() {
    var routes = pages
        .map((page) {
          if (excludeDraft && page.draft) {
            print("Ignoring draft ${page.title}");
            return null;
          }
          if (page.route.isEmpty) {
            throw Exception("Route cannot be empty");
          }
          return Route(
              path: page.route, builder: (_, __) => div([_buildPage(page)]));
        })
        .where((x) => x != null)
        .cast<Route>()
        .toList();
    return routes;
  }
}

class JasprBlogBuilder {
  Directory? _directory;
  bool _excludeDraft = true;
  final List<StyleRule> _styles = [
    StyleRule.import(
        "https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css"),
    StyleRule.import("/style.css"),
  ];
  final Map<String, TemplateBuilder> _templates = {};
  final Map<String, LayoutBuilder> _layouts = {};
  LayoutBuilder? _defaultLayout;
  Component? _headerComponent;
  Component? _footerComponent;

  // Set directory
  JasprBlogBuilder setDirectory(Directory directory) {
    _directory = directory;
    return this;
  }

  // Set draft exclusion
  JasprBlogBuilder setExcludeDraft(bool exclude) {
    _excludeDraft = exclude;
    return this;
  }

  // Set styles
  JasprBlogBuilder setStyles(List<StyleRule> styles) {
    _styles.clear();
    _styles.addAll(styles);
    return this;
  }

  // Add individual style
  JasprBlogBuilder addStyle(StyleRule style) {
    _styles.add(style);
    return this;
  }

  // Add template
  JasprBlogBuilder setTemplate(String name, TemplateBuilder builder) {
    _templates[name] = builder;
    return this;
  }

  // Set layout
  JasprBlogBuilder setLayout(String name, LayoutBuilder builder) {
    _layouts[name] = builder;
    return this;
  }

  // Set default layout
  JasprBlogBuilder setDefaultLayout(LayoutBuilder builder) {
    _defaultLayout = builder;
    return this;
  }

  // Add header component
  JasprBlogBuilder setHeader(Component component) {
    _headerComponent = component;
    return this;
  }

  // Add footer component
  JasprBlogBuilder setFooter(Component component) {
    _footerComponent = component;
    return this;
  }

  // Build method to create JasprBlog instance
  JasprBlog build() {
    final blog = JasprBlog(
      directory: _directory,
      excludeDraft: _excludeDraft,
      templates: Map.unmodifiable(_templates),
      layouts: Map.unmodifiable(_layouts),
      styles: List.unmodifiable(_styles),
    );

    return blog;
  }
}
