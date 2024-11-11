// import 'package:jaspr_blog/jaspr_blog/templates/index_template.dart';
// import 'package:jaspr_blog/jaspr_blog/templates/template.dart';
// import 'package:jaspr_blog/jaspr_blog/models/page_model.dart';
// import 'package:jaspr_blog/jaspr_blog.dart';

// typedef TemplateBuilder = Template Function(PageModel model);

// class TemplateFactory {
//   final Map<String, TemplateBuilder> builders;

//   const TemplateFactory({this.builders = const {}});

//   void register(String name, TemplateBuilder builder) {
//     builders[name] = builder;
//   }

//   Template getInstance(String? name, PageModel model, JasprBlog blog) {
//     var builder = builders[name];
//     if (builder != null) {
//       return builder(model);
//     }
//     if (model is PageIndexPageModel) {
//       return PageIndexTemplate(model, blog);
//     }
//     return Template(model, blog);
//   }
// }
