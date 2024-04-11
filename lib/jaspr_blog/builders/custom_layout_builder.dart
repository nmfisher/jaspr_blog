// import 'package:build/build.dart';

// import 'package:analyzer/dart/element/visitor.dart';
// import 'package:analyzer/dart/element/element.dart';

// Builder customLayoutBuilder(BuilderOptions options) => CustomLayoutBuilder();

// Type typeOf<T>() => T;

// class _Visitor extends RecursiveElementVisitor<String> {
//   final Map<ClassElement, String> _names = {};
//   @override
//   String? visitClassElement(ClassElement element) {
//     if (!element.supertype!.element
//         .getDisplayString(withNullability: true)
//         .startsWith("abstract class Layout")) {
//       // if (!element.supertype!.typeArguments.contains(typeOf<Layout>())) {
//       throw Exception(
//           "Unsupported type ${element.supertype!.element.getDisplayString(withNullability: true)}");
//     }
//     var annotation =
//         element.metadata.cast<ElementAnnotation?>().firstWhere((element) {
//       return element!.element!.displayName == "LayoutName";
//     }, orElse: () => null);
//     if (annotation == null) {
//       throw Exception("Custom layout must have a @LayoutName annotation");
//     }
//     var name =
//         (annotation.computeConstantValue())!.getField("name")!.toStringValue()!;
//     _names[element] = name;
//     element.visitChildren(this);
//     return null;
//   }
// }

// class CustomLayoutBuilder implements Builder {
//   @override
//   Future build(BuildStep buildStep) async {
//     var entryLib = await buildStep.inputLibrary;

//     final inputId = buildStep.inputId;

//     final outputId = AssetId(
//         inputId.package,
//         inputId.path
//             .replaceAll("layouts", "generated")
//             .replaceAll(".dart", ".part"));

//     final visitor = _Visitor();

//     entryLib.visitChildren(visitor);

//     for (final classElement in visitor._names.keys) {
//       final layoutName = visitor._names[classElement];
//       final constructor = classElement.constructors.first;
//       await buildStep.writeAsString(outputId, """
//         factory.register($layoutName, new ${constructor.displayName}());
//         """);
//     }

//     // var customLayoutDir = Directory(p.join(srcDir, "layouts"));

//     // final layoutFactory = LayoutFactory();

//     // if (customLayoutDir.existsSync()) {
//     //   var layoutBuilders = ClassMapBuilder().build(customLayoutDir);
//     //   for (final builder in layoutBuilders) {
//     //     layoutFactory.register(builder.$1, builder.$2);
//     //   }
//     // }
//   }

//   @override
//   Map<String, List<String>> get buildExtensions => const {
//         // To implement directory moves, this builder uses capture groups
//         // ({{}}). Capture groups can match anything in the input's path,
//         // including subdirectories. The `^assets` at the beginning ensures that
//         // only jsons under the top-level `assets/` folder will be considered.
//         '^lib/layouts/{{}}.dart': ['lib/generated/{{}}.part'],
//       };
// }
