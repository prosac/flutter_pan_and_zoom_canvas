import 'package:file/file.dart';
import 'package:org_parser/org_parser.dart' as org;

class PlainTextFile {
  PlainTextFile._constructor(this.file);

  late File file;

  get path => file.path;

  String title() {
    final doc = org.OrgDocument.parse(file.readAsStringSync());
    String value = '';

    doc.children[0].visit<org.OrgMeta>((thing) {
      if (thing.keyword.contains('title')) {
        value = thing.trailing.trim();
        return false;
      } else {
        value = file.basename;
        return true;
      }
    });

    return value;
  }
}
