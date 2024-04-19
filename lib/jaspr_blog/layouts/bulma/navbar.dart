import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

/// Bulma Navbar Component
/// Supports a limited subset of the available options
/// See https://bulma.io/documentation/components/navbar/ for a detailed description
class NavBar extends StatelessComponent {
  final NavbarConfigModel navbarConfigModel;
  const NavBar(
      {this.brand, this.menu, required this.navbarConfigModel, super.key});

  final NavbarBrand? brand;
  final NavbarMenu? menu;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield nav(
      classes: 'navbar block ${navbarConfigModel.classes}',
      [
        if (brand != null) brand!,
        if (menu != null) menu!,
      ],
    );
  }
}

class NavbarBrand extends StatelessComponent {
  const NavbarBrand({required this.children, super.key});

  final List<Component> children;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'navbar-brand', children);
  }
}

class NavbarMenu extends StatelessComponent {
  const NavbarMenu({required this.items, this.endItems = const [], super.key});

  final List<Component> items;
  final List<Component> endItems;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'navbar-menu is-active', [
      div(classes: 'navbar-start', items),
      div(classes: 'navbar-end', endItems),
    ]);
  }
}

class NavbarItem extends StatelessComponent {
  const NavbarItem(
      {required this.child,
      this.href,
      this.attributes,
      this.classes,
      super.key})
      : items = null;

  const NavbarItem.dropdown(
      {required this.child,
      required this.items,
      super.key,
      this.attributes,
      this.classes})
      : href = null;

  final Component child;
  final String? href;
  final List<Component>? items;
  final Map<String, String>? attributes;
  final String? classes;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    if (items == null) {
      yield a(
          href: href ?? '',
          classes: 'navbar-item $classes',
          [child],
          attributes: attributes);
    } else {
      yield div(
          classes: 'navbar-item has-dropdown is-hoverable $classes',
          [
            a(href: '', classes: 'navbar-link', [child]),
            div(classes: 'navbar-dropdown', items!),
          ],
          attributes: attributes);
    }
  }
}

class NavbarDivider extends StatelessComponent {
  const NavbarDivider({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield hr(classes: 'navbar-divider');
  }
}
