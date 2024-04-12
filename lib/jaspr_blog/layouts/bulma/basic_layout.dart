import 'package:jaspr/jaspr.dart' hide footer;
import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/navbar.dart';

class BasicLayout extends StatelessComponent {
  final String? title;
  final String? owner;
  final Component? logo;
  final List<Component> children;
  final Map<String, String> navBarLinks;

  BasicLayout(
      {this.title = "Untitled",
      this.owner,
      required this.children,
      this.logo,
      this.navBarLinks = const <String, String>{"Blog": "/posts"}});

  Component header() {
    return NavBar(
      brand: NavbarBrand(children: [
        NavbarItem(child: logo ?? text(title ?? ""), href: '/'),
      ]),
      menu: NavbarMenu(
          items: [],
          endItems: navBarLinks.keys
              .map(
                (text) => NavbarItem(
                    child: p([jaspr.text(text)], classes: "subtitle"),
                    href: navBarLinks[text]!),
              )
              .toList()),
    );
  }

  Component footer() {
    return jaspr.footer([
      div([
        if (owner != null) text(owner!),
        if (owner != null) text(" | "),
        text(DateTime.now().year.toString()),
      ], classes: "content has-text-centered"),
    ], classes: "footer");
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([header()], classes: "container");
    yield section(children, classes: "container");
    yield footer();
  }
}
