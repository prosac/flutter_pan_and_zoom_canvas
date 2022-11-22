import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/common_action_buttons_mixin.dart';
import 'package:flutter_pan_and_zoom/model/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:provider/provider.dart';

import 'model/node.dart';
import 'presentation_container.dart';

class PlainTextFilePresentation extends BasePresentation
    with CommonActionButtons {
  final double width = 300;
  final double height = 500;
  final Node node;
  final VoidCallback onAddPressed;
  final PlainTextFile file;
  final textEditingController = TextEditingController();

  PlainTextFilePresentation(
      {required this.node, required this.onAddPressed, required this.file})
      : super(node: node, onAddPressed: onAddPressed);

  @override
  Widget build(BuildContext context) {
    Widget presentation;

    presentation =
        Consumer<ViewerState>(builder: (context, viewerState, child) {
      if (viewerState.scale > 0.5) {
        return PresentationContainer(
            child: Material(
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Builder(builder: (context) {
                    return Column(
                      children: [
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
                          maxLines: 5,
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        Text(
                          'File',
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.left,
                        ),
                        Text(file.path,
                            style: Theme.of(context).textTheme.bodyText1),
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildRemoveButton(context),
                                Padding(padding: EdgeInsets.only(left: 10.0)),
                                buildAddButton(context),
                                Padding(padding: EdgeInsets.only(left: 10.0)),
                                NeumorphicButton(
                                  padding: const EdgeInsets.all(20.0),
                                  style: NeumorphicStyle(
                                      boxShape: NeumorphicBoxShape.circle()),
                                  onPressed: () async {
                                    await file.writeAsString(
                                        textEditingController.text);

                                    viewerState.requestFocus();
                                    viewerState.enableSpaceCommandMode();
                                  },
                                  child: Center(
                                      child: NeumorphicIcon(Icons.save,
                                          style: NeumorphicStyle(
                                              color: Colors.grey.shade500))),
                                )
                              ]),
                        )
                      ],
                    );
                  }),
                ],
              ),
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
