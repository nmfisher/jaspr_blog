import 'package:jaspr/jaspr.dart' hide footer;
import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/navbar.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

class BasicLayout extends StatelessComponent {
  final String? title;
  final String? owner;
  final List<Component> children;
  final NavbarConfigModel navbarConfigModel;
  final String classes;
  final Component? footerComponent;
  final Component? headerComponent;

  BasicLayout(
      {this.title = "Untitled",
      this.owner,
      required this.children,
      required this.navbarConfigModel,
      this.footerComponent,
      this.headerComponent,
      this.classes = ""});

  Iterable<Component> header() sync* {
    if (headerComponent != null) {
      yield headerComponent!;
    }
    var logo = NavbarItem(
        child: a(href: '/', [
          navbarConfigModel.logoConfig != null
            ? 
                img(
                    src: navbarConfigModel.logoConfig!.url,
                    height: navbarConfigModel.logoConfig?.height,
                    width: navbarConfigModel.logoConfig?.width) : text(title ?? "")
              ]) );

    yield NavBar(
      navbarConfigModel: navbarConfigModel,
      brand: NavbarBrand(children: [logo]),
      menu: NavbarMenu(
          items: [],
          endItems: navbarConfigModel.items
              .map(
                (item) => NavbarItem(
                    classes: item.classes,
                    child: p([jaspr.text(item.text)],
                        classes: navbarConfigModel.itemClasses),
                    href: item.route,
                    attributes: item.attributes),
              )
              .toList()),
    );
  }

  Iterable<Component> footer() sync* {
    yield jaspr.footer([
      div([
        if (footerComponent != null) footerComponent!,
        if (owner != null) text(owner!),
        if (owner != null) text(" | "),
        text(DateTime.now().year.toString()),
      ], classes: "content has-text-centered"),
    ], classes: "footer");
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(header().toList(), classes: "container");
    yield section(children, classes: "container $classes");
    yield* footer();
  }
}
