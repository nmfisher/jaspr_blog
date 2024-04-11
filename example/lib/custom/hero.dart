import 'package:jaspr/ui.dart' hide header, footer;
import 'package:jaspr_blog/jaspr_blog/layouts/layout.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

class ExampleHeroCustomLayout extends Layout {
  ExampleHeroCustomLayout(
      {ConfigModel? configModel, required List<Component> children})
      : super(configModel, "my-custom-id", children);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([header()], classes: "container");
    yield section([
      div([
        div([
          p([text("Hero Title")], classes: "title"),
          p([text("Hero Subtitle")], classes: "subtitle")
        ]),
      ], classes: "hero-body "),
    ], classes: "hero is-link is-fullheight-with-navbar");
    yield section(children, classes: "container");
    yield footer();
  }
}
