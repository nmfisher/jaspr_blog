import 'package:jaspr/jaspr.dart' hide footer;
import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/navbar.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

typedef LayoutBuilder = Layout Function(ConfigModel?, List<Component> children);

class Layout extends StatelessComponent {
  final String? id;
  final ConfigModel? configModel;
  final List<Component> children;

  Layout(this.configModel, this.id, this.children);

  Component header() {
    return NavBar(
      brand: NavbarBrand(children: [
        NavbarItem(child: img(src: "/images/logo.png"), href: '/'),
      ]),
      menu: NavbarMenu(items: [
        NavbarItem(
            child: Text(configModel?.title ?? "Untitled Page"), href: "/"),
        NavbarItem(child: Text('Blog'), href: "/posts"),
      ]),
    );
  }

  Component footer() {
    return jaspr.footer([
      div([
        text(configModel?.owner ?? "Unknown Owner"),
        text(" | "),
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
