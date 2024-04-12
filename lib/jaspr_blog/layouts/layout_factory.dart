import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/basic_layout.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

typedef LayoutBuilder = Component Function(
    ConfigModel?, List<Component> children);

class LayoutFactory {
  final _builders = <String, LayoutBuilder>{};

  void register(String name, LayoutBuilder builder) {
    _builders[name] = builder;
  }

  LayoutBuilder _default = (configModel, children) => BasicLayout(
      title: configModel?.title,
      owner: configModel?.owner,
      children: children,
      logo: configModel?.logo == null ? null : img(src: configModel!.logo!));

  void setDefault(LayoutBuilder builder) {
    _default = builder;
  }

  Component getInstance(String? name, ConfigModel configModel, String? id,
      List<Component> children) {
    var builder = _builders[name];
    if (builder != null) {
      return builder(configModel, children);
    }
    return _default(configModel, children);
  }
}
