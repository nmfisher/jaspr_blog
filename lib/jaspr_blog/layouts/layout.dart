import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

typedef LayoutBuilder = Layout Function(ConfigModel?, List<Component> children);

class Layout extends StatelessComponent {
  final String? id;
  final ConfigModel? configModel;
  final List<Component> children;

  Layout(this.configModel, this.id, this.children);

  Component _header() {
    return div(
        styles: Styles.combine([
          Styles.flexbox(
            direction: FlexDirection.row,
            justifyContent: JustifyContent.center,
            alignItems: AlignItems.center,
            wrap: FlexWrap.nowrap,
          )
        ]),
        [
          a([text(configModel?.title ?? "Untitled Page")], href: "/"),
          img(src: "images/logo.png"),
          div([], styles: Styles.flexItem(flex: Flex(grow: 1))),
          a([Text("Blog")], href: "/posts")
        ],
        classes: "header");
  }

  Component _footer() {
    return div(
        styles: Styles.combine([
          Styles.flexbox(
            direction: FlexDirection.row,
            justifyContent: JustifyContent.center,
            alignItems: AlignItems.center,
            wrap: FlexWrap.nowrap,
          )
        ]),
        [
          text(configModel?.owner ?? "Unknown Owner"),
          text(" | "),
          text(DateTime.now().year.toString()),
        ],
        classes: "footer");
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      _header(),
      div(children,
          styles: Styles.combine([
            Styles.flexbox(
                justifyContent: JustifyContent.start,
                alignItems: AlignItems.center,
                direction: FlexDirection.column),
            Styles.flexItem(
              flex: Flex(grow: 1),
            ),
          ]),
          classes: "inner"),
      _footer(),
    ], id: id, classes: "layout");
  }
}
