import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/delete_all_nodes_things.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/reset_viewport.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';
import 'package:flutter_pan_and_zoom/core/presentation/node_with_presentation.dart';
import 'package:flutter_pan_and_zoom/core/presentation/simple_connection_painter.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'draggable_item.dart';

class WorkBench extends StatefulWidget with GetItStatefulWidgetMixin {
  final double width;
  final double height;

  WorkBench({super.key, required this.width, required this.height});

  @override
  WorkBenchState createState() => WorkBenchState();
}

class WorkBenchState extends State<WorkBench> with GetItStateMixin {
  final transformationController = TransformationController();
  final dragTargetKey = GlobalKey();
  late MediaQueryData mediaQueryData;
  // TODO: let's see if it is ok to have them as instance vaes
  late ViewerState viewerState;
  late Graph graph;
  late InteractionState interactionState;

  Offset get center => Offset(widget.width / 2, widget.height / 2);

  List get draggableItems {
    return graph.nodes.map((Node rawNode) {
      var node = NodeWithPresentation(node: rawNode);
      return DraggableItem(
          key: UniqueKey(),
          offset: node.offset,
          scale: viewerState.scale,
          node: node,
          onDragStarted: () {
            graph.drag(node);
            viewerState.drag(node); // should be implicit!
          },
          onDragCompleted: () {
            viewerState.stopDragging();
          });
    }).toList();
  }

  RenderBox get dragTargetRenderBox => dragTargetKey.currentContext!.findRenderObject() as RenderBox;

  List<CustomPaint> get visualConnections {
    return graph.edges.map((Edge edge) {
      Size size1 = Size(edge.source.width, edge.destination.height);
      Size size2 = Size(edge.source.width, edge.destination.height);

      Offset nodeOffset1 = Offset(edge.source.dx, edge.source.dy);
      Offset nodeOffset2 = Offset(edge.destination.dx, edge.destination.dy);

      Offset offset1AdaptedToBackground = nodeOffset1;
      Offset offset2AdaptedToBackground = nodeOffset2;

      Offset offset1 =
          Offset(offset1AdaptedToBackground.dx + size1.width / 2, offset1AdaptedToBackground.dy + size1.height / 2);
      Offset offset2 =
          Offset(offset2AdaptedToBackground.dx + size2.width / 2, offset2AdaptedToBackground.dy + size2.height / 2);

      return CustomPaint(painter: SimpleConnectionPainter(start: offset1, end: offset2));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    viewerState = get<ViewerState>();
    graph = get<Graph>();
    viewerState.parametersFromMatrix(transformationController.value);
    mediaQueryData = MediaQuery.of(context);

    return KeyboardListener(
      focusNode: viewerState.focusNode,
      autofocus: true,
      onKeyEvent: (event) => handleKeyboardOnKey(context, event),
      child: Container(
        child: maximizedThing(viewerState),
      ),
    );
  }

  void centerView() {
    var matrix = Matrix4.identity();
    matrix.translate(-center.dx, -center.dy);
    transformationController.value = matrix;
  }

  // TODO: dose get<>ing the use cases here count as "within the build method?"
  void handleKeyboardOnKey(BuildContext context, KeyEvent event) async {
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
        var useCase = get<CreateNode>();
        await useCase(Params(dx: center.dx, dy: center.dy));
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyX) {
        var useCase = get<DeleteAllNodes>();
        useCase();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        var useCase = get<DeleteAllNodes>();
        useCase();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyR) {
        var useCase = get<ResetViewport>();
        useCase();
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
            viewerState.parametersFromMatrix(transformationController.value);
          });
        },
        constrained: false, // this does the trick to make the "canvas" bigger than the view port
        child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1)),
            child: DragTarget(
              key: dragTargetKey,
              onAcceptWithDetails: (DragTargetDetails details) {
                Offset offset = dragTargetRenderBox.globalToLocal(details.offset);
                // TODO: search on main branch how this has been before
                // https://github.com/search?q=repo%3Aprosac%2Fflutter_pan_and_zoom_canvas+leaveDraggingItemAtNewOffset&type=code
                graph.leaveDraggingItemAtNewOffset(offset);
              },
              builder: (BuildContext context, List candidateData, List rejectedData) {
                return Stack(children: [...visualConnections, ...draggableItems]);
              },
            )));
  }

  Stack get mainCanvas {
    return Stack(children: [
      Stack(
        children: <Widget>[interactiveViewer],
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
              onPressed: () => viewerState.enterSpaceCommandMode(), label: Text('Things')),
        ),
      ),
      spaceCommands
    ]);
  }

  // TODO: better use some null object
  Widget? maximizedThing(ViewerState viewerState) {
    if (viewerState.maximizedThing != null) {
      return viewerState.maximizedThing;
    } else {
      return mainCanvas;
    }
  }

  void resetViewport() {
    centerView();
    viewerState.resetView();
  }

  Visibility get spaceCommands {
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
            child: ElevatedButton(onPressed: () => get<DeleteAllNodes>()(), child: Text('d → Delete all the things')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => get<CreateNode>()(Params(dx: center.dx, dy: center.dy)), child: Text('n → Add thing')),
          )
        ]);

    var innerCommandPallette = Container(
        child: Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 400, padding: const EdgeInsets.all(20), child: commands),
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
              child: Align(child: innerCommandPallette, alignment: Alignment.bottomCenter),
            )));
  }
}
