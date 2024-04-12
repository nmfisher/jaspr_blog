import 'dart:io';

import 'package:example/custom/hero.dart';
import 'package:example/custom/preamble.dart';
import 'package:example/custom/full_width.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:path/path.dart' as path;

class App extends StatefulComponent {
  @override
  State<StatefulComponent> createState() => _AppState();
}

class _AppState extends State<App> with PreloadStateMixin {
  late JasprBlog blog;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield Router(routes: blog.buildRoutes());
  }

  @override
  Future<void> preloadState() async {
    blog = JasprBlog();
    // blog.setDefaultLayout((config, components) =>
    //     CustomLayout(configModel: config, children: components));
    blog.addTemplate("preamble", (page) => ExampleTemplateWithPreamble(page));
    blog.addLayout(
        "full-width",
        (page, children) => ExampleFullWidthCustomLayout(
            configModel: blog.configModel!, children: children));
    blog.addLayout("hero",
        (page, children) => ExampleHeroCustomLayout(children: children));
    blog.generateFrom(Directory(path.join(Directory.current.path, "content")));
  }
}
