import 'package:jaspr/ui.dart' hide header, footer;
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/basic_hero_layout.dart';

class ExampleHeroCustomLayout extends BasicHeroLayout {
  ExampleHeroCustomLayout({required super.children})
      : super(heroContent: [
          p([text("Hero Title")], classes: "title"),
          p([text("Hero Subtitle")], classes: "subtitle")
        ]);

  // final List<Component> heroContent;

  // ExampleHeroCustomLayout(
  //     {required this.heroContent,
  //     ConfigModel? configModel,
  //     super.logo,
  //     required super.children})
  //     : super(title: configModel!.title);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([header()], classes: "container");
    yield section([
      div([
        div(heroContent),
      ], classes: "hero-body "),
    ], classes: "hero is-link is-fullheight-with-navbar");
    yield section(children, classes: "container");
    yield footer();
  }
}
