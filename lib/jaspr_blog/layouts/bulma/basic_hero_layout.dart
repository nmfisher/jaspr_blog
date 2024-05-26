import 'package:jaspr/ui.dart' hide header, footer;
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/basic_layout.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/navbar.dart';

class BasicHeroLayout extends BasicLayout {
  final List<Component> heroContent;

  BasicHeroLayout(
      {required this.heroContent,
      super.title,
      required super.navbarConfigModel,
      required super.children,
      super.footerComponent,
      super.headerComponent});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(header().toList(), classes: "container");

    yield section([
      div([
        div(heroContent, classes: "container"),
      ], classes: "hero-body"),
    ], classes: "hero container is-fullheight-with-navbar has-text-centered");
    yield section(children, classes: "container");
    yield* footer();
  }
}
