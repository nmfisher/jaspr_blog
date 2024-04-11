import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/layout.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

class LayoutFactory {
  final _builders = <String, LayoutBuilder>{};

  void register(String name, LayoutBuilder builder) {
    _builders[name] = builder;
  }

  LayoutBuilder _default =
      (configModel, children) => Layout(configModel, null, children);

  void setDefault(LayoutBuilder builder) {
    _default = builder;
  }

  Layout getInstance(String? name, ConfigModel configModel, String? id,
      List<Component> children) {
    var builder = _builders[name];
    if (builder != null) {
      return builder(configModel, children);
    }
    return _default(configModel, children);
  }
}
