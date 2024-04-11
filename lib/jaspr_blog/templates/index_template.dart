import 'package:jaspr/jaspr.dart';
import 'package:jaspr/ui.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:jaspr_blog/jaspr_blog/templates/template.dart';
import 'package:markdown/markdown.dart' as md;

class PageIndexTemplate extends Template<PageIndexPageModel> {
  PageIndexTemplate(super.page);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    for (var child in page.children) {
      yield div([
        div([
          div([
            a([
              p([text(child.title)], classes: "title is-4")
            ], href: child.route),
            p([text(child.blurb ?? "")], classes: "subtitle"),
          ], classes: "content")
        ], classes: "card-content")
      ], classes: "card");
    }
  }
}
