import 'package:jaspr/src/framework/framework.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr/ui.dart';
import 'package:markdown/markdown.dart' as md;

class ExampleTemplateWithPreamble extends Template {
  ExampleTemplateWithPreamble(super.page);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      p([
        text(
            "This is a custom page template for the post titled ${page.title}.")
      ]),
      p([
        text(
            "This uses the same layout, but overrides the default template to add this preamble as text.")
      ]),
      p([text("This page formatted with the default template is below.")]),
      p([text("-----------")])
    ]);
    yield Template(page);
  }
}
