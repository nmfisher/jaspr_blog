import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:markdown/markdown.dart' as md;

class Template<K extends PageModel> extends StatelessComponent {
  final K page;

  Template(this.page);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      div([], classes: "column"),
      div([
        h1([text(page.title)], classes: "title is-1 pb-5"),
        div(
          [raw(md.markdownToHtml(page.markdown))],
        ),
      ], classes: "column is-half"),
      div([], classes: "column")
    ], classes: "columns content is-size-5 has-text-dark post");
  }
}
