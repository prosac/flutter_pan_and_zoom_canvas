import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_pan_and_zoom/contact_presentation.dart';
import 'package:flutter_pan_and_zoom/example_presentation.dart';
import 'package:flutter_pan_and_zoom/model/edge.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:flutter_pan_and_zoom/simple_connection_painter.dart';
import 'package:provider/provider.dart';

import 'draggable_item.dart';
import 'model/graph_model.dart';
import 'model/node.dart';
import 'test_data.dart';

class WorkBench extends StatefulWidget {
  final double width;
  final double height;

  WorkBench({super.key, required this.width, required this.height});

  @override
  WorkBenchState createState() => WorkBenchState();
}

class WorkBenchState extends State<WorkBench> {
  final TransformationController transformationController =
      TransformationController();

  final GlobalKey dragTargetKey = GlobalKey();
  late MediaQueryData mediaQueryData;

  Offset get center => Offset(widget.width / 2, widget.height / 2);

  List get draggableItems {
    GraphModel model = Provider.of<GraphModel>(context);
    ViewerState viewerState = Provider.of<ViewerState>(context);

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
    GraphModel model = Provider.of<GraphModel>(context);

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

  // TODO: maybe this should be called something like GraphicalNodeRepresentation and thus graphicalNodeRepresentations
  void addThing(model, offset) {
    final newNode =
        Node(offset: offset, payload: TestData(text: 'Some other Payload'));

    // TODO: hot to best implement a bidirectional 1-1 relationsship
    newNode.presentation = ExamplePresentation(
        node: newNode,
        onAddPressed: () => addThingFromExisting(model, newNode));

    model.add(newNode);
    Provider.of<ViewerState>(context, listen: false).spaceCommandModeActive =
        false;
  }

  void addContact(model, offset) {
    final newNode = Node(offset: offset, payload: TestData(text: 'Some human'));

    newNode.presentation = ConatactPresentation(
        node: newNode,
        onAddPressed: () => addThingFromExisting(model, newNode));

    model.add(newNode);
    Provider.of<ViewerState>(context, listen: false).spaceCommandModeActive =
        false;
  }

  void addThingFromExisting(GraphModel model, Node node) {
    final Offset offset = node.offset;
    final adaptedOffset = computeAdaptedOffset(node, offset);

    final newNode = Node(
        offset: adaptedOffset, payload: TestData(text: 'Some other Payload'));

    // TODO: how to best implement a bidirectional 1-1 relationsship
    newNode.presentation = ExamplePresentation(
        node: newNode,
        onAddPressed: () => addThingFromExisting(model, newNode));

    model.add(newNode);
    model.addEdge(node, newNode);
  }

  @override
  Widget build(BuildContext context) {
    ViewerState viewerState = Provider.of<ViewerState>(context);
    viewerState.parametersFromMatrix(transformationController.value);
    mediaQueryData = MediaQuery.of(context);

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) => handleKeyboardOnKey(context, event, viewerState),
      child: NeumorphicBackground(
        child: Stack(children: [
          Stack(
            children: <Widget>[interactiveViewer()],
          ),
          spaceCommands()
        ]),
      ),
    );
  }

  void handleKeyboardOnKey(
      BuildContext context, RawKeyEvent event, ViewerState viewerState) {
    GraphModel model = Provider.of<GraphModel>(context, listen: false);

    if (event.isKeyPressed(LogicalKeyboardKey.space))
      viewerState.enterSpaceCommandMode();
    if (event.isKeyPressed(LogicalKeyboardKey.escape))
      viewerState.exitSpaceCommandMode();
    if (viewerState.spaceCommandModeActive) {
      if (event.isKeyPressed(LogicalKeyboardKey.keyN)) addThing(model, center);
      if (event.isKeyPressed(LogicalKeyboardKey.keyX)) deleteAllTheThings();
      if (event.isKeyPressed(LogicalKeyboardKey.keyD)) deleteAllTheThings();
      if (event.isKeyPressed(LogicalKeyboardKey.keyH))
        addContact(model, center);
      if (event.isKeyPressed(LogicalKeyboardKey.keyR)) resetViewport();
    }
  }

  Offset computeAdaptedOffset(Node node, Offset offset) {
    var addition = Offset(
        (node.width + 20) / widget.width, (node.height + 20) / widget.height);

    return offset + addition;
  }

  void deleteAllTheThings() {
    Provider.of<GraphModel>(context, listen: false).removeAll();
    Provider.of<ViewerState>(context, listen: false).spaceCommandModeActive =
        false;
  }

  @override
  void initState() {
    super.initState();
    resetViewport();
  }

  void resetViewport() {
    var matrix = Matrix4.identity();
    ViewerState viewerState = Provider.of<ViewerState>(context, listen: false);
    matrix.translate(-center.dx, -center.dy);
    transformationController.value = matrix;
    setState(() => viewerState.scale = 1.0);
    Provider.of<ViewerState>(context, listen: false).scale = 1.0;
    Provider.of<ViewerState>(context, listen: false).spaceCommandModeActive =
        false;
  }

  void setScaleFromTransformationController() {
    // doing this in a call to setState solves the problem that the feedback item does not know the current scale
    ViewerState viewerState = Provider.of<ViewerState>(context, listen: false);
    viewerState.parametersFromMatrix(transformationController.value);
  }

  InteractiveViewer interactiveViewer() {
    return InteractiveViewer(
        maxScale: 10.0,
        minScale: 0.01,
        boundaryMargin: EdgeInsets.all(1000.0),
        transformationController: transformationController,
        onInteractionEnd: (details) =>
            setState(() => setScaleFromTransformationController()),
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

  Visibility spaceCommands() {
    ViewerState viewerState = Provider.of<ViewerState>(context, listen: false);
    GraphModel model = Provider.of<GraphModel>(context, listen: false);

    var commands = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NeumorphicButton(
              onPressed: resetViewport,
              child: Text('r → Reset'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NeumorphicButton(
                onPressed: deleteAllTheThings,
                child: Text('d → Delete all the things')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NeumorphicButton(
                onPressed: () => addThing(model, center),
                child: Text('n → Add thing')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NeumorphicButton(
                onPressed: () => addContact(model, center),
                child: Text('h → Add Human')),
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
