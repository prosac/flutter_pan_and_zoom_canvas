import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/core/data/test_data.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/features/plain_text_files/presentation/plain_text_file_presentation.dart';

void addPlainTextFile(offset, BuildContext context) async {
  final newNode =
      Node(offset: offset, payload: TestData(text: 'Some other Payload'));
  final model = context.read<GraphModel>();

  PlainTextFile file = await PlainTextFile.asyncNew(randomString(10));

  newNode.presentation = PlainTextFilePresentation(
      node: newNode,
      file: file,
      onAddPressed: () => addThingFromExisting(newNode, context));

  model.add(newNode);
  context.read<ViewerState>().exitSpaceCommandMode();
}
