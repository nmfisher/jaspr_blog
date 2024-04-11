import 'package:jaspr/jaspr.dart';
import 'package:jaspr/ui.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
import 'package:jaspr_blog/jaspr_blog/templates/template.dart';
import 'package:markdown/markdown.dart' as md;

class IndexTemplate extends Template<IndexPageModel> {
  IndexTemplate(super.page);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    for (var child in page.children) {
      yield Column(children: [
        a([Text(child.title)], href: child.route),
        Text(child.blurb ?? ""),
      ]);
    }
  }
}
