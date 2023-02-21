import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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

  PlainTextFilePresentation(
      {required this.node, required this.onAddPressed, required this.file})
      : super(node: node);

  @override
  Widget build(BuildContext context) {
    Widget presentation;

    presentation =
        Consumer<ViewerState>(builder: (context, viewerState, child) {
      if (viewerState.scale > 0.5) {
        return PresentationContainer(
            child: Material(
          child: SizedBox(
            width: width - 10,
            height: height - 10,
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
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Write something...',
                            labelText: 'Content',
                          ),
                          onTap: (() {
                            viewerState.disableSpaceCommandMode();
                          }),
                          // onChanged: (value) => textEditingController.text = value,
                          maxLines: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NeumorphicButton(
                              onPressed: () async {
                                await file
                                    .writeAsString(textEditingController.text);

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
