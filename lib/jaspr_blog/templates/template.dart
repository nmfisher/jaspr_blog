import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:markdown/markdown.dart' as md;

class Template<K extends PageModel> extends StatelessComponent {
  final K page;

  Template(this.page);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield Text(md.markdownToHtml(page.markdown), rawHtml: true);
  }
}
