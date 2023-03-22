import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/model/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:provider/provider.dart';

import 'model/node.dart';
import 'presentation_container.dart';

class PlainTextFilePresentation extends BasePresentation {
  final double width = 300;
  final double height = 500;
  final Node node;
  final VoidCallback onAddPressed;
  final PlainTextFile file;
  final textEditingController = TextEditingController();

  PlainTextFilePresentation({required this.node, required this.onAddPressed, required this.file}) : super(node: node);

  @override
  Widget build(BuildContext context) {
    Widget presentation;

    if (file.file.existsSync()) textEditingController.text = file.file.readAsStringSync();

    presentation = Consumer<ViewerState>(builder: (context, viewerState, child) {
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
                            Text(file.path),
                            TextFormField(
                              controller: textEditingController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(),
                                filled: true,
                                labelText: 'Notes',
                              ),
                              onTap: (() {
                                viewerState.disableSpaceCommandMode();
                              }),
                              maxLines: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await file.writeAsString(textEditingController.text);

                                    viewerState.requestFocus();
                                    viewerState.enableSpaceCommandMode();
                                  },
                                  child: Text('Save')),
                            )
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
    });

    return presentation;
  }
}
