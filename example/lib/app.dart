import 'dart:io';

import 'package:example/templates/custom_template.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:path/path.dart' as p;

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
    blog.addTemplate("post", (page) => CustomPostTemplate(page));
    blog.generateFrom(Directory(p.join(Directory.current.path, "content")));
  }
}
