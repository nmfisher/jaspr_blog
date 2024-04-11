import 'package:jaspr/src/framework/framework.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr/ui.dart';

@Name("post")
class CustomPostTemplate extends Template {
  CustomPostTemplate(super.page);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      text("This is a custom page template for the post titled ${page.title}")
    ], classes: "my-custom-class");
  }
}
