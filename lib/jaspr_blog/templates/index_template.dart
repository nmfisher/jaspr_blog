import 'package:intl/intl.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/ui.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:jaspr_blog/jaspr_blog/templates/template.dart';

class PageIndexTemplate extends Template<PageIndexPageModel> {
  final bool useCard;
  final bool textCentered;

  PageIndexTemplate(super.page,
      {this.useCard = false, this.textCentered = true});

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
                      p([text(child.title)], classes: "title is-4 mb-4"),
                      div([], classes: "is-flex-grow-1"),
                      p([
                        text(DateFormat(DateFormat.YEAR_NUM_MONTH_DAY)
                            .format(page.date ?? DateTime.now()))
                      ], classes: "is-size-7")
                    ], classes: "is-flex"),
                    p([text("${child.blurb ?? ""}...")],
                        classes: "subtitle mt-4"),
                  ], classes: "content ${useCard ? 'card p-6' : ''} "),
                ], href: child.route))
            .toList(),
      ], classes: "column is-half"),
      div([], classes: "column"),
    ],
        classes:
            "columns content is-size-5 has-text-dark post index ${textCentered ? "has-text-centered" : ''}");
  }
}
