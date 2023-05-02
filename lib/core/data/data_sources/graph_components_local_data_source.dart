import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/data/models/edge_model.dart';
import 'package:flutter_pan_and_zoom/core/data/models/node_model.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';

abstract class GraphComponentsLocalDataSource {
  Future<Either<Failure, List<NodeModel>>> nodes();

  Future<Either<Failure, NodeModel>> createNode(
      {required int id, required double dx, required double dy});

  Future<Either<Failure, List<EdgeModel>>> edges();

  Future<Either<Failure, EdgeModel>> createEdge(
      {required NodeModel node, required NodeModel otherNode});

  Future<Either<Failure, GraphComponentsLocalDataSource>> deleteAll();

  Future<Either<Failure, GraphComponentsLocalDataSource>> delete(
      NodeModel node);
}

class GraphComponentsLocalDataSourceImplementation
    implements GraphComponentsLocalDataSource {
  List<NodeModel> _nodes = [];
  List<EdgeModel> _edges = [];

  @override
  Future<Either<Failure, List<NodeModel>>> nodes() async {
    return Future.value(Right(_nodes));
  }

  @override
  Future<Either<Failure, NodeModel>> createNode(
      {required int id, required double dx, required double dy}) {
    var node = NodeModel(id: _nextId(), dx: dx, dy: dy);
    _nodes.add(node);
    return Future.value(Right(node));
  }

  @override
  Future<Either<Failure, List<EdgeModel>>> edges() async {
    return Future.value(Right(_edges));
  }

  @override
  Future<Either<Failure, EdgeModel>> createEdge(
      {required NodeModel node, required NodeModel otherNode}) {
    var edge = EdgeModel(node: node, otherNode: otherNode);
    _edges.add(edge);
    return Future.value(Right(edge));
  }

  Future<Either<Failure, GraphComponentsLocalDataSource>> delete(node) {
    _nodes.remove(node);
    _edges.removeWhere((edge) => edge.isConnectedTo(node));
    return Future.value(Right(this));
  }

  Future<Either<Failure, GraphComponentsLocalDataSource>> deleteAll() {
    _edges.clear();
    _nodes.clear();
    return Future.value(Right(this));
  }

  //---

  int _nextId() {
    return _nodes.map((node) => node.id).reduce(max) + 1;
  }
}
