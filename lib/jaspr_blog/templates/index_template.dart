import 'package:intl/intl.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/ui.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:jaspr_blog/jaspr_blog/templates/template.dart';

class PageIndexTemplate extends Template<PageIndexPageModel> {
  final bool useCard;
  final bool textCentered;
  final String? classes;

  PageIndexTemplate(super.page, super.blog,
      {super.styles = null,
      this.useCard = false,
      this.textCentered = true,
      this.classes});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      div([], classes: "column"),
      div([
        h1([text(page.title)], classes: "title is-2 is-inline-block mt-6"),
        ...page.children
            .where((model) => !model.draft)
            .map((child) => a([
                  div([
                    div([
                      p([text(child.title)],
                          classes: "title is-4 mb-4 has-text-left"),
                      div([], classes: "is-flex-grow-1"),
                      p([
                        text(DateFormat("yyyy-MM-dd")
                            .format(child.date ?? DateTime.now()))
                      ], classes: "is-size-7 has-text-dark")
                    ],
                        classes:
                            "is-flex is-flex-direction-column is-justify-content-flex-start is-align-items-flex-start"),
                    p([text("${child.blurb ?? ""}...")],
                        classes: "subtitle mt-4 mb-4 has-text-left"),
                  ], classes: "content ${useCard ? 'card p-6 mb-4' : ''} "),
                ], href: child.route))
            .toList(),
      ], classes: "column is-half"),
      div([], classes: "column"),
    ],
        classes:
            "columns content is-size-5 has-text-dark post index ${textCentered ? "has-text-centered" : ''}");
  }
}
