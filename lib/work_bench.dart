import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/example_presentation.dart';
import 'package:flutter_pan_and_zoom/model/edge.dart';
import 'package:flutter_pan_and_zoom/simple_connection_painter.dart';
import 'package:provider/provider.dart';

import 'background.dart';
import 'draggable_item.dart';
import 'model/graph_model.dart';
import 'model/node.dart';
import 'neumorphic_background.dart';
import 'test_data.dart';

class WorkBench extends StatefulWidget {
  WorkBench({Key? key, required this.width, required this.height})
      : super(key: key);

  final double width;
  final double height;

  @override
  WorkBenchState createState() => WorkBenchState();
}

class WorkBenchState extends State<WorkBench> {
  final TransformationController transformationController =
      TransformationController();

  final GlobalKey dragTargetKey = GlobalKey();
  double scale = 1.0;

  late Background background;
  late Offset center;
  late MediaQueryData mediaQueryData;

  @override
  void initState() {
    super.initState();
    background =
        NeumorphicBackground(width: widget.width, height: widget.height);
    center = Offset(background.width / 2, background.height / 2);
    _resetViewport();
  }

  @override
  Widget build(BuildContext context) {
    GraphModel model = Provider.of<GraphModel>(context);
    model.scale = scale;
    model.offsetFromMatrix(transformationController.value);
    mediaQueryData = MediaQuery.of(context);

    return Stack(children: <Widget>[
      InteractiveViewer(
          maxScale: 10.0,
          minScale: 0.01,
          boundaryMargin: EdgeInsets.all(1000.0),
          transformationController: transformationController,
          onInteractionEnd: (details) =>
              setState(() => setScaleFromTransformationController()),
          constrained:
              false, // this does the trick to make the "canvas" bigger than the view port
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
                return Stack(children: [
                  background,
                  ...visualConnections,
                  ...draggableItems
                ]);
              },
            );
          })),
      Align(
          alignment: Alignment.topLeft,
          child: Consumer<GraphModel>(builder: (context, model, child) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: _resetViewport, child: Text('Reset')),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  ElevatedButton(
                      onPressed: deleteAllTheThings,
                      child: Text('Delete all the things')),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  ElevatedButton(
                      onPressed: () => addThing(model, center),
                      child: Text('Add thing'))
                ]);
          }))
    ]);
  }

  void _resetViewport() {
    var matrix = Matrix4.identity();
    matrix.translate(-center.dx, -center.dy);
    transformationController.value = matrix;
    setState(() => scale = 1.0);
    Provider.of<GraphModel>(context, listen: false).scale = 1.0;
  }

  // TODO: maybe this should be called something like GraphicalNodeRepresentation and thus graphicalNodeRepresentations
  List get draggableItems {
    GraphModel model = Provider.of<GraphModel>(context);

    return model.nodes.map((Node node) {
      Offset offset = node.offset;

      return DraggableItem(
          key: UniqueKey(),
          offset: offset,
          scale: scale,
          node: node,
          onDragStarted: () {
            model.drag(node); // should implicitly do what setState does
            model.startTicker(node); // should be implicit!
          },
          onDragCompleted: () {
            model.stopTicker();
          });
    }).toList();
  }

  RenderBox get dragTargetRenderBox =>
      dragTargetKey.currentContext!.findRenderObject() as RenderBox;

  List<CustomPaint> get visualConnections {
    GraphModel model = Provider.of<GraphModel>(context);

    return model.connections.map((Edge connection) {
      Size size1 = Size(connection.node1.presentation!.width,
          connection.node1.presentation!.height);
      Size size2 = Size(connection.node2.presentation!.width,
          connection.node1.presentation!.height);

      Offset nodeOffset1 = connection.node1.presentation!.offset;
      Offset nodeOffset2 = connection.node2.presentation!.offset;

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

  void setScaleFromTransformationController() {
    // doing this in a call to setState solves the problem that the feedback item does not know the current scale
    scale = transformationController.value.row0[0];
    GraphModel model = Provider.of<GraphModel>(context, listen: false);
    model.scale = scale;

    model.offsetFromMatrix(transformationController.value);
  }

  void deleteAllTheThings() {
    Provider.of<GraphModel>(context, listen: false).removeAll();
  }

  void addThing(model, offset) {
    final newNode =
        Node(offset: offset, payload: TestData(text: 'Some other Payload'));

    // TODO: hot to best implement a bidirectional 1-1 relationsship
    newNode.presentation = ExamplePresentation(
        node: newNode,
        onAddPressed: () => {addThingFromExisting(model, newNode)});

    model.add(newNode);
  }

  void addThingFromExisting(GraphModel model, Node node) {
    // final Offset offset = node.offset.translate(node.width, node.height);
    final Offset offset = node.offset;
    final adaptedOffset = computeAdaptedOffset(node, offset);

    final newNode = Node(
        offset: adaptedOffset, payload: TestData(text: 'Some other Payload'));

    // TODO: hot to best implement a bidirectional 1-1 relationsship
    newNode.presentation = ExamplePresentation(
        node: newNode,
        onAddPressed: () => {addThingFromExisting(model, newNode)});

    model.add(newNode);
    model.connections = Edge(node, newNode);
  }

  Offset computeAdaptedOffset(Node node, Offset offset) {
    var addition = Offset((node.width + 20) / background.width,
        (node.height + 20) / background.height);

    return offset + addition;
  }
}
