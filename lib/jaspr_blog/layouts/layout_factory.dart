import 'dart:math';

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/jaspr_blog/layouts/bulma/basic_layout.dart';
import 'package:jaspr_blog/jaspr_blog/models/config_model.dart';

typedef LayoutBuilder = Component Function(
    ConfigModel, List<Component> children, Component? logo);

class LayoutFactory {
  final _builders = <String, LayoutBuilder>{};

  LayoutFactory() {
    _default = (configModel, children, logo) => BasicLayout(
        title: configModel.title,
        owner: configModel.owner,
        children: children,
        navbarConfigModel: configModel.navbarConfigModel,
        logo: logo,
        footerComponent: _footer,
        headerComponent: _header);
  }

  void register(String name, LayoutBuilder builder) {
    _builders[name] = builder;
  }

  late LayoutBuilder _default;

  void setDefault(LayoutBuilder builder) {
    _default = builder;
  }

  Component? _footer;
  void setFooter(Component component) {
    this._footer = component;
  }

  Component? _header;
  void setHeader(Component component) {
    this._header = component;
  }

  Component getInstance(String? name, ConfigModel configModel, String? id,
      List<Component> children, Component? logo) {
    var builder = _builders[name];
    if (builder != null) {
      return builder(configModel, children, logo);
    }
    return _default(configModel, children, logo);
  }
}
