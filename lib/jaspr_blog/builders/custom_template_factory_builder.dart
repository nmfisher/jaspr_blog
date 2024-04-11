import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

Builder customTemplateFactoryBuilder(BuilderOptions options) =>
    CustomTemplateFactoryBuilder();

Type typeOf<T>() => T;

class _Visitor extends RecursiveElementVisitor<String> {
  final Map<ClassElement, String> _names = {};

  @override
  String? visitLibraryElement(LibraryElement element) {
    element.visitChildren(this);
    return null;
  }

  @override
  String? visitClassElement(ClassElement element) {
    if (!element.supertype!.element
        .getDisplayString(withNullability: true)
        .startsWith("abstract class Template")) {
      // if (!element.supertype!.typeArguments.contains(typeOf<Layout>())) {
      throw Exception(
          "Unsupported type ${element.supertype!.element.getDisplayString(withNullability: true)}");
    }
    var annotation =
        element.metadata.cast<ElementAnnotation?>().firstWhere((element) {
      return element!.element!.displayName == "Name";
    }, orElse: () => null);
    if (annotation == null) {
      throw Exception("Custom layout must have a @Name annotation");
    }
    var name =
        (annotation.computeConstantValue())!.getField("name")!.toStringValue()!;
    _names[element] = name;

    element.visitChildren(this);
    return null;
  }
}

class CustomTemplateFactoryBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final visitor = _Visitor();
    var customLayouts =
        await buildStep.findAssets(Glob("lib/templates/*dart")).toList();

    var imports = [
      "package:jaspr/server.dart",
      "package:jaspr_blog/jaspr_blog.dart"
    ];
    for (final layout in customLayouts) {
      var libraryElement = await buildStep.resolver.libraryFor(layout);
      visitor.visitLibraryElement(libraryElement);
      imports.add(libraryElement.location.toString());
    }

    var template = "";
    for (final import in imports) {
      template += "import '$import';\n";
    }

    template += """

void main() {
  Jaspr.initializeApp();
  final templateFactory = TemplateFactory();
""";

    for (final classElement in visitor._names.keys) {
      var name = visitor._names[classElement]!;
      final constructor = classElement.constructors.first;

      template += """
  templateFactory.register("$name", (model) => ${constructor.displayName}(model));
""";
    }

    template += """
  var doc = loadYaml("YAML: YAML Ain't Markup Language");

  // runApp(App("FOO", [], [], templateFactory));
}
""";

    final outputId = AssetId(inputId.package, "lib/main.dart");
    await buildStep.writeAsString(outputId, template);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        'main_template.dart': ['main.dart'],
      };
}
