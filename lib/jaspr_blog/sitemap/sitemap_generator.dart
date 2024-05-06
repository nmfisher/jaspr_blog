import 'dart:io';

import 'package:xml/xml.dart';
import 'package:jaspr_router/jaspr_router.dart';

class SitemapGenerator {
  static void generate(List<Route> routes, String host, { String outFile = "build/jaspr/sitemap.xml"}) {
    XmlElement urlset = XmlElement(
      XmlName('urlset'),
      [
        XmlAttribute(
            XmlName('xmlns'), 'http://www.sitemaps.org/schemas/sitemap/0.9'),
        XmlAttribute(
            XmlName('xmlns:xsi'), 'http://www.w3.org/2001/XMLSchema-instance'),
        XmlAttribute(XmlName('xsi:schemaLocation'),
            'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd')
      ],
      [],
    );

    for (final route in routes) {
      urlset.children.add(
        XmlElement(
          XmlName('url'),
          [],
          [
            XmlElement(XmlName('loc'), [],
                [XmlText("${host}${route.path}")]),
            XmlElement(XmlName('lastmod'), [], [
              XmlText(DateTime.parse("2023-04-23").toUtc().toIso8601String())
            ]),
            XmlElement(XmlName('priority'), [], [
              XmlText(route.path == "/"
                  ? "1.0"
                  : route.path.startsWith("/chinese")
                      ? "0.1"
                      : "0.5")
            ]),
          ],
        ),
      );
    }
    var document = XmlDocument([urlset]);
    File(outFile)
        .writeAsStringSync(document.toXmlString(pretty: true));
  }
}
