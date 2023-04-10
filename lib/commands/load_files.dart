import 'dart:math';

import 'package:file/file.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/commands/add_thing_from_existing.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/model/local_storage_directory.dart';
import 'package:flutter_pan_and_zoom/model/node.dart';
import 'package:flutter_pan_and_zoom/model/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:flutter_pan_and_zoom/plain_text_file_presentation.dart';
import 'package:flutter_pan_and_zoom/test_data.dart';
import 'package:provider/provider.dart';

void loadFiles(BuildContext context) async {
  final model = context.read<GraphModel>();
  var files = await LocalStorageDirectory().files();

  files.forEach((entity) async {
    if (entity is File) {
      PlainTextFile file = await PlainTextFile.asyncFromFile((entity));

      var offset = Offset(Random().nextInt(1000).toDouble(), Random().nextInt(1000).toDouble());
      final newNode = Node(offset: offset, payload: TestData(text: 'Some file loaded from storage dir'));
      newNode.presentation = PlainTextFilePresentation(
          node: newNode, file: file, onAddPressed: () => addThingFromExisting(newNode, context));

      model.add(newNode);
    }

    context.read<ViewerState>().exitSpaceCommandMode();
  });
}
