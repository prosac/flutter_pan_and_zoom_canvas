import 'dart:math';
import 'dart:ui';

import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pan_and_zoom/contact_presentation.dart';
import 'package:flutter_pan_and_zoom/example_presentation.dart';
import 'package:flutter_pan_and_zoom/model/edge.dart';
import 'package:flutter_pan_and_zoom/model/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:flutter_pan_and_zoom/plain_text_file_presentation.dart';
import 'package:flutter_pan_and_zoom/simple_connection_painter.dart';
import 'package:flutter_pan_and_zoom/utils/random.dart';
import 'package:provider/provider.dart';

import 'draggable_item.dart';
import 'model/graph_model.dart';
import 'model/node.dart';
import 'model/simple_action.dart';
import 'model/storage_directory.dart';
import 'test_data.dart';

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

  RenderBox get dragTargetRenderBox => dragTargetKey.currentContext!.findRenderObject() as RenderBox;

  List<CustomPaint> get visualConnections {
    var model = context.read<GraphModel>();

    return model.edges.map((Edge edge) {
      Size size1 = Size(edge.node1.presentation.width, edge.node1.presentation.height);
      Size size2 = Size(edge.node2.presentation.width, edge.node1.presentation.height);

      Offset nodeOffset1 = edge.node1.presentation.offset;
      Offset nodeOffset2 = edge.node2.presentation.offset;

      Offset offset1AdaptedToBackground = nodeOffset1;
      Offset offset2AdaptedToBackground = nodeOffset2;

      Offset offset1 =
          Offset(offset1AdaptedToBackground.dx + size1.width / 2, offset1AdaptedToBackground.dy + size1.height / 2);
      Offset offset2 =
          Offset(offset2AdaptedToBackground.dx + size2.width / 2, offset2AdaptedToBackground.dy + size2.height / 2);

      return CustomPaint(painter: SimpleConnectionPainter(start: offset1, end: offset2));
    }).toList();
  }

  // TODO: maybe this should be called something like GraphicalNodeRepresentation and thus graphicalNodeRepresentations
  void addThing(offset) {
    final node = Node(offset: offset, payload: TestData(text: 'Some other Payload'));
    final model = context.read<GraphModel>();

    node.actions = [
      SimpleAction(icon: Icons.add, callback: () => addThingFromExisting(node)),
      SimpleAction(icon: Icons.local_drink, callback: () => initiateConnecting(fromNode: node)),
      SimpleAction(icon: Icons.link, callback: () => connect(otherNode: node)),
      SimpleAction(icon: Icons.delete, callback: () => model.remove(node))
    ];

    // TODO: hot to best implement a bidirectional 1-1 relationsship
    node.presentation = ExamplePresentation(node: node);

    model.add(node);
    context.read<ViewerState>().exitSpaceCommandMode();
  }

  void addPlainTextFile(model, offset) async {
    final newNode = Node(offset: offset, payload: TestData(text: 'Some other Payload'));

    PlainTextFile file = await PlainTextFile.asyncNew(randomString(10));

    newNode.presentation =
        PlainTextFilePresentation(node: newNode, file: file, onAddPressed: () => addThingFromExisting(newNode));

    model.add(newNode);
    context.read<ViewerState>().exitSpaceCommandMode();
  }

  // TODO: why pass in model???
  void addContact(model, offset) {
    final newNode = Node(offset: offset, payload: TestData(text: 'Some human'));

    newNode.presentation = ConatactPresentation(node: newNode, onAddPressed: () => addThingFromExisting(newNode));

    model.add(newNode);
    context.read<ViewerState>().exitSpaceCommandMode();
  }

  void loadFiles(model, offset) async {
    var files = await StorageDirectory().files();

    files.forEach((entity) async {
      if (entity is File) {
        PlainTextFile file = await PlainTextFile.asyncFromFile((entity as File));

        var offset = Offset(Random().nextInt(1000).toDouble(), Random().nextInt(1000).toDouble());
        final newNode = Node(offset: offset, payload: TestData(text: 'Some file loaded from storage dir'));
        newNode.presentation =
            PlainTextFilePresentation(node: newNode, file: file, onAddPressed: () => addThingFromExisting(newNode));

        model.add(newNode);
      }

      context.read<ViewerState>().exitSpaceCommandMode();
    });
  }

  void addThingFromExisting(Node node) {
    final Offset offset = node.offset;
    final adaptedOffset = computeAdaptedOffset(node, offset);
    final model = context.read<GraphModel>();

    final newNode = Node(offset: adaptedOffset, payload: TestData(text: 'Some other Payload'));

    newNode.actions = [
      SimpleAction(icon: Icons.add, callback: () => addThingFromExisting(newNode)),
      SimpleAction(icon: Icons.local_drink, callback: () => initiateConnecting(fromNode: node)),
      SimpleAction(icon: Icons.link, callback: () => connect(otherNode: node)),
      SimpleAction(icon: Icons.delete, callback: () => model.remove(newNode))
    ];

    // TODO: how to best implement a bidirectional 1-1 relationsship
    newNode.presentation = ExamplePresentation(node: newNode);

    model.add(newNode);
    model.addEdge(node, newNode);
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
        child: Stack(children: [
          Stack(
            children: <Widget>[interactiveViewer()],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                  onPressed: () => viewerState.enterSpaceCommandMode(), label: Text('Things')),
            ),
          ),
          spaceCommands()
        ]),
      ),
    );
  }

  void handleKeyboardOnKey(BuildContext context, KeyEvent event, ViewerState viewerState) {
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
        addThing(center);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyT) {
        addPlainTextFile(model, center);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyX) {
        deleteAllTheThings();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        deleteAllTheThings();
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyH) {
        addContact(model, center);
        return;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyR) {
        resetViewport();
        return;
      }
    }
  }

  Offset computeAdaptedOffset(Node node, Offset offset) {
    var addition = Offset((node.width + 20) / widget.width, (node.height + 20) / widget.height);

    return offset + addition;
  }

  void deleteAllTheThings() {
    context.read<ViewerState>().exitSpaceCommandMode();
    context.read<GraphModel>().removeAll();
  }

  @override
  void initState() {
    super.initState();
    centerView();
  }

  void centerView() {
    var matrix = Matrix4.identity();
    matrix.translate(-center.dx, -center.dy);
    transformationController.value = matrix;
  }

  void resetViewport() {
    centerView();
    context.read<ViewerState>().resetView();
  }

  InteractiveViewer interactiveViewer() {
    return InteractiveViewer(
        maxScale: 10.0,
        minScale: 0.01,
        boundaryMargin: EdgeInsets.all(1000.0),
        transformationController: transformationController,
        onInteractionEnd: (details) {
          // TODO: why the hell this is ok for flutter when called in setState(),
          // but not without plus an internal notifyListeners() (which calls setState())?
          setState(() {
            context.read<ViewerState>().parametersFromMatrix(transformationController.value);
          });
        },
        constrained: false, // this does the trick to make the "canvas" bigger than the view port
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1)),
          child: Consumer<GraphModel>(builder: (context, model, child) {
            return DragTarget(
              key: dragTargetKey,
              onAcceptWithDetails: (DragTargetDetails details) {
                Offset offset = dragTargetRenderBox.globalToLocal(details.offset);
                model.leaveDraggingItemAtNewOffset(offset);
              },
              builder: (BuildContext context, List<TestData?> candidateData, List rejectedData) {
                return Stack(children: [...visualConnections, ...draggableItems]);
              },
            );
          }),
        ));
  }

  Visibility spaceCommands() {
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
            child: ElevatedButton(onPressed: deleteAllTheThings, child: Text('d → Delete all the things')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () => addPlainTextFile(model, center), child: Text('n → Add plain text file')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () => addThing(center), child: Text('n → Add thing')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () => addContact(model, center), child: Text('h → Add Human')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () => loadFiles(model, center), child: Text('l → Load all the files')),
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

  void initiateConnecting({required Node fromNode}) {
    final model = context.read<GraphModel>();
    model.nodeToConnect = fromNode;
  }

  void connect({required Node otherNode}) {
    final model = context.read<GraphModel>();
    model.addEdgeTo(otherNode);
  }
}
