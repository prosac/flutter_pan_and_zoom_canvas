import 'dart:math';

import 'package:flutter_pan_and_zoom/core/data/models/edge_model.dart';
import 'package:flutter_pan_and_zoom/core/data/models/node_model.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';

// DataSource notes
// deals with all details of storing, retrieving, caching
// It does NOT use Either
// It DOES return model instances
// Models extend entities
abstract class GraphComponentsLocalDataSource {
  Future<List<NodeModel>> nodes();

  Future<NodeModel> addNode({required int id, required double dx, required double dy});

  Future<List<EdgeModel>> edges();

  Future<EdgeModel> createEdge({required Node node, required Node otherNode});

  Future<GraphComponentsLocalDataSource> deleteAll();

  Future<GraphComponentsLocalDataSource> delete(NodeModel node);
}

class GraphComponentsLocalDataSourceImplementation implements GraphComponentsLocalDataSource {
  List<NodeModel> _nodes = [];
  List<EdgeModel> _edges = [];

  @override
  Future<List<NodeModel>> nodes() async {
    return Future.value(_nodes);
  }

  @override
  Future<NodeModel> addNode({required int id, required double dx, required double dy}) {
    var node = NodeModel(id: nextId(), dx: dx, dy: dy);
    _nodes.add(node);
    return Future.value(node);
  }

  @override
  Future<List<EdgeModel>> edges() async {
    return Future.value(_edges);
  }

  @override
  Future<EdgeModel> createEdge({required Node node, required Node otherNode}) {
    var edge = EdgeModel(node: node, otherNode: otherNode);
    _edges.add(edge);
    return Future.value(edge);
  }

  Future<GraphComponentsLocalDataSource> delete(node) {
    _nodes.remove(node);
    _edges.removeWhere((edge) => edge.isConnectedTo(node));
    return Future.value(this);
  }

  Future<GraphComponentsLocalDataSource> deleteAll() {
    _edges.clear();
    _nodes.clear();
    return Future.value(this);
  }

  int nextId() {
    return _nodes.map((node) => node.id).reduce(max) + 1;
  }
}
