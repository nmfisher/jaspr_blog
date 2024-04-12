import 'package:jaspr/src/framework/framework.dart';
import 'package:jaspr/ui.dart' hide header, footer;
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/basic_layout.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

class ExampleFullWidthCustomLayout extends BasicLayout {
  ExampleFullWidthCustomLayout(
      {ConfigModel? configModel, required List<Component> children})
      : super(owner: configModel!.owner, children: children);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([header()]);
    yield section(children);
    yield footer();
  }
}
