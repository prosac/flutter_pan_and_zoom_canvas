import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/presentation/base_presentation.dart';
import 'package:flutter_pan_and_zoom/core/presentation/presentation_container.dart';
import 'package:flutter_pan_and_zoom/features/filesystem/domain/entities/plain_text_file.dart';
import 'package:org_flutter/org_flutter.dart';

class PlainTextFilePresentation extends BasePresentation {
  final double width = 300;
  final double height = 500;
  final Node node;
  final VoidCallback onAddPressed;
  final PlainTextFile file;
  final textEditingController = TextEditingController();
  late final OrgDocument orgDoc;

  PlainTextFilePresentation({required this.node, required this.onAddPressed, required this.file}) : super(node: node) {
    if (file.file.existsSync()) {
      textEditingController.text = file.file.readAsStringSync();
      this.orgDoc = OrgDocument.parse(this.file.file.readAsStringSync());
    } else {
      this.orgDoc = OrgDocument.parse('* Nothing');
    }
  }

  OrgController org({String rawString = 'Empty...'}) {
    return OrgController(
        root: orgDoc,
        child: OrgRootWidget(
          child: OrgDocumentWidget(orgDoc),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget presentation;

    if (file.file.existsSync()) textEditingController.text = file.file.readAsStringSync();

    if (viewerState.scale > 0.5) {
      return PresentationContainer(
          borderRadius: BorderRadius.all(Radius.zero),
          child: Material(
            child: SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    child: Builder(builder: (context) {
                      return Column(
                        children: [
                          Text(file.title()),
                          // TextFormField(
                          //   controller: textEditingController,
                          //   decoration: const InputDecoration(
                          //     contentPadding: EdgeInsets.all(10),
                          //     border: OutlineInputBorder(),
                          //     filled: true,
                          //     labelText: 'Notes',
                          //   ),
                          //   onTap: (() {
                          //     viewerState.disableSpaceCommandMode();
                          //   }),
                          //   maxLines: 5,
                          // ),
                          SizedBox(
                            child: org(rawString: textEditingController.text),
                            width: width - 10,
                            height: height - 10,
                          )
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: ElevatedButton(
                          //       onPressed: () async {
                          //         await file.writeAsString(textEditingController.text);

                          //         viewerState.requestFocus();
                          //         viewerState.enableSpaceCommandMode();
                          //       },
                          //       child: Text('Save')),
                          // )
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ));
    }

    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
    );

    return presentation;
  }
}
