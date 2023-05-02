import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pan_and_zoom/core/data/test_data.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/edge.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/delete_all_the_things.dart';
import 'package:flutter_pan_and_zoom/core/presentation/simple_connection_painter.dart';
import 'package:flutter_pan_and_zoom/features/files/domain/use_case/load_files.dart';
import 'package:flutter_pan_and_zoom/features/humans/domain/use_cases/add_contact.dart';
import 'package:flutter_pan_and_zoom/features/plain_text_files/domain/use_cases/add_plain_text_file.dart';
import 'package:flutter_pan_and_zoom/features/nodes/domain/use_cases/add_node.dart';

import 'draggable_item.dart';

class WorkBench extends StatefulWidget {
  final double width;
  final double height;

  WorkBench({super.key, required this.width, required this.height});

  @override
  WorkBenchState createState() => WorkBenchState();
}

class WorkBenchState extends State<WorkBench> {
  final transformationController = TransformationController();
  final dragTargetKey = GlobalKey();
  late MediaQueryData mediaQueryData;

  Offset get center => Offset(widget.width / 2, widget.height / 2);

  List get draggableItems {
    var viewerState = context.watch<ViewerState>();
    var model = context.watch<GraphModel>();

    return model.nodes.map((Node node) {
      Offset offset = node.offset;

      return DraggableItem(
          key: UniqueKey(),
          offset: offset,
          scale: viewerState.scale,
          node: node,
          onDragStarted: () {
            model.drag(node);
            viewerState.drag(node); // should be implicit!
          },
          onDragCompleted: () {
            viewerState.stopDragging();
          });
    }).toList();
  }

  RenderBox get dragTargetRenderBox =>
      dragTargetKey.currentContext!.findRenderObject() as RenderBox;

  List<CustomPaint> get visualConnections {
    var model = context.read<GraphModel>();

    return model.edges.map((Edge edge) {
      Size size1 =
          Size(edge.node1.presentation.width, edge.node1.presentation.height);
      Size size2 =
          Size(edge.node2.presentation.width, edge.node1.presentation.height);

      Offset nodeOffset1 = edge.node1.presentation.offset;
      Offset nodeOffset2 = edge.node2.presentation.offset;

      Offset offset1AdaptedToBackground = nodeOffset1;
      Offset offset2AdaptedToBackground = nodeOffset2;

      Offset offset1 = Offset(offset1AdaptedToBackground.dx + size1.width / 2,
          offset1AdaptedToBackground.dy + size1.height / 2);
      Offset offset2 = Offset(offset2AdaptedToBackground.dx + size2.width / 2,
          offset2AdaptedToBackground.dy + size2.height / 2);

      return CustomPaint(
          painter: SimpleConnectionPainter(start: offset1, end: offset2));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var viewerState = context.read<ViewerState>();
    viewerState.parametersFromMatrix(transformationController.value);
    mediaQueryData = MediaQuery.of(context);

    return KeyboardListener(
      focusNode: viewerState.focusNode,
      autofocus: true,
      onKeyEvent: (event) => handleKeyboardOnKey(context, event, viewerState),
      child: Container(
        child: maximizedThing,
      ),
    );
  }

  void centerView() {
    var matrix = Matrix4.identity();
    matrix.translate(-center.dx, -center.dy);
    transformationController.value = matrix;
  }

  void handleKeyboardOnKey(
      BuildContext context, KeyEvent event, ViewerState viewerState) {
    var model = context.read<GraphModel>();

    if (event.logicalKey == LogicalKeyboardKey.space) {
      viewerState.enterSpaceCommandMode();
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      viewerState.exitSpaceCommandMode();
      return;
    }

    if (viewerState.spaceCommandModeActive) {
      if (event.logicalKey == LogicalKeyboardKey.keyN) {
        addThing(center, context);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyT) {
        addPlainTextFile(center, context);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyX) {
        deleteAllTheThings(context);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        deleteAllTheThings(context);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyH) {
        addContact(model, center, context);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyR) {
        resetViewport();
        return;
      }

      if (event.logicalKey == LogicalKeyboardKey.keyL) {
        loadFiles(context);
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    centerView();
  }

  InteractiveViewer get interactiveViewer {
    return InteractiveViewer(
        maxScale: 10.0,
        minScale: 0.01,
        boundaryMargin: EdgeInsets.all(1000.0),
        transformationController: transformationController,
        onInteractionEnd: (details) {
          // TODO: why the hell this is ok for flutter when called in setState(),
          // but not without plus an internal notifyListeners() (which calls setState())?
          setState(() {
            context
                .read<ViewerState>()
                .parametersFromMatrix(transformationController.value);
          });
        },
        constrained:
            false, // this does the trick to make the "canvas" bigger than the view port
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black45, width: 1)),
          child: Consumer<GraphModel>(builder: (context, model, child) {
            return DragTarget(
              key: dragTargetKey,
              onAcceptWithDetails: (DragTargetDetails details) {
                Offset offset =
                    dragTargetRenderBox.globalToLocal(details.offset);
                model.leaveDraggingItemAtNewOffset(offset);
              },
              builder: (BuildContext context, List<TestData?> candidateData,
                  List rejectedData) {
                return Stack(
                    children: [...visualConnections, ...draggableItems]);
              },
            );
          }),
        ));
  }

  Stack get mainCanvas {
    var viewerState = context.read<ViewerState>();

    return Stack(children: [
      Stack(
        children: <Widget>[interactiveViewer],
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
              onPressed: () => viewerState.enterSpaceCommandMode(),
              label: Text('Things')),
        ),
      ),
      spaceCommands
    ]);
  }

  Widget? get maximizedThing {
    ViewerState viewerState = context.read<ViewerState>();
    if (viewerState.maximizedThing != null) {
      return viewerState.maximizedThing;
    } else {
      return mainCanvas;
    }
  }

  void resetViewport() {
    centerView();
    context.read<ViewerState>().resetView();
  }

  void deleteAllTheThingsPassingContext() => deleteAllTheThings(context);

  Visibility get spaceCommands {
    var viewerState = context.read<ViewerState>();
    var model = context.read<GraphModel>();

    var commands = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: resetViewport,
              child: Text('r → Reset'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: deleteAllTheThingsPassingContext,
                child: Text('d → Delete all the things')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => addPlainTextFile(center, context),
                child: Text('n → Add plain text file')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => addThing(center, context),
                child: Text('n → Add thing')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => addContact(model, center, context),
                child: Text('h → Add Human')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => loadFiles(context),
                child: Text('l → Load all the files')),
          )
        ]);

    var innerCommandPallette = Container(
        child: Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 400, padding: const EdgeInsets.all(20), child: commands),
          ],
        )
      ],
    ));

    return Visibility(
        visible: viewerState.spaceCommandModeActive,
        child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Container(
              width: mediaQueryData.size.width,
              color: Colors.black.withOpacity(0.1),
              child: Align(
                  child: innerCommandPallette,
                  alignment: Alignment.bottomCenter),
            )));
  }
}
