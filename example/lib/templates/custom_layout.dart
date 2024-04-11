import 'package:jaspr/src/framework/framework.dart';
import 'package:jaspr_blog/jaspr_blog.dart';
import 'package:jaspr/ui.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/layout.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

class CustomLayout extends Layout {
  CustomLayout({ConfigModel? configModel, required List<Component> children})
      : super(configModel, "my-custom-id", children);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
          text("This is a custom layout for the site ${configModel!.title}")
        ] +
        children);
  }
}
