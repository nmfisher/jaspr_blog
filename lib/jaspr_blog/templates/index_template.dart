import 'package:jaspr/jaspr.dart';
import 'package:jaspr/ui.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:jaspr_blog/jaspr_blog/templates/template.dart';

class PageIndexTemplate extends Template<PageIndexPageModel> {
  PageIndexTemplate(super.page);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      div([], classes: "column"),
      div([
        h1([text(page.title)], classes: "title is-1 is-inline-block"),
        ...page.children
            .map((child) => div([
                  a([
                    p([text(child.title)], classes: "title is-4 mb-4")
                  ], href: child.route),
                  p([text(child.blurb ?? "")], classes: "subtitle"),
                ], classes: "content"))
            .toList(),
      ], classes: "column is-half"),
      div([], classes: "column"),
    ],
        classes:
            "columns content is-size-5 has-text-dark post index has-text-centered");
  }
}
