import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:markdown/markdown.dart' as md;

class Template<K extends PageModel> extends StatelessComponent {
  final K page;
  final JasprBlog blog;
  final List<StyleRule>? styles;

  Template(this.page, this.blog, {this.styles = null});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      // if (styles != null) Head(children: [Style(styles: styles!)]),
      div([], classes: "column"),
      div([
        h1([text(page.title)], classes: "title is-1 p-5 mt-6 mb-0"),
        div([raw(md.markdownToHtml(page.markdown))], classes: "card p-5"),
      ], classes: "column is-two-thirds"),
      div([], classes: "column")
    ], classes: "columns content is-size-5 has-text-dark post");
  }
}
