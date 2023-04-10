import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/base_presentation.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:provider/provider.dart';
import 'model/node.dart';
import 'presentation_container.dart';

class ImagePresentation extends BasePresentation {
  final double width = 300;
  final double height = 200;
  final Node node;
  final VoidCallback onAddPressed;

  ImagePresentation({required this.node, required this.onAddPressed}) : super(node: node);

  @override
  Widget build(BuildContext context) {
    Widget presentation;

    presentation = Consumer<ViewerState>(builder: (context, viewerState, child) {
      if (viewerState.scale > 0.5) {
        return PresentationContainer(
            child: Column(
          children: [
            image(),
            row(label('Name', context), name('Rick Sanchez', context)),
            row(label('Email', context), text('admin@multiverse', context)),
            row(label('Phone', context), text('+00005996666', context))
          ],
        ));
      }

      if (viewerState.scale <= 0.5 && viewerState.scale > 0.3) {
        return CircleAvatar(backgroundImage: imageFile());
      }

      return Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      );
    });

    return presentation;
  }

  Row row(label, text) {
    return Row(
      children: [label, text],
    );
  }

  Text name(content, context) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.left,
    );
  }

  Text text(content, context) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.left,
    );
  }

  Text label(content, context) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.left,
    );
  }

  FileImage imageFile() {
    return FileImage(File('/home/johannes.vonbargen/Pictures/Rick_Sanchez.webp'));
  }

  Image image() {
    return Image.file(File('/home/johannes.vonbargen/Pictures/Rick_Sanchez.webp'),
        width: width, height: height, fit: BoxFit.fitWidth);
  }
}
