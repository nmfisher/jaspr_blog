import 'package:jaspr_blog/jaspr_blog/templates/index_template.dart';
import 'package:jaspr_blog/jaspr_blog/templates/template.dart';
import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';

typedef TemplateBuilder = Template Function(PageModel model);

class TemplateFactory {
  final _builders = <String, TemplateBuilder>{};

  void register(String name, TemplateBuilder builder) {
    _builders[name] = builder;
  }

  Template getInstance(String? name, PageModel model) {
    var builder = _builders[name];
    if (builder != null) {
      return builder(model);
    }
    if (model is PageIndexPageModel) {
      return PageIndexTemplate(model);
    }
    return Template(model);
  }
}
