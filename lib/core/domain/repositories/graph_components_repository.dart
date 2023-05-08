import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

abstract class GraphComponentsRepository {
  Future<Either<Failure, List<Node>>> nodes();
  Future<Either<Failure, Node>> addNode(Node node);
  Future<Either<Failure, List<Edge>>> edges();
  // TODO: Edge must be created outside and only added to the repo
  Future<Either<Failure, Edge>> createEdge({required Node node, required Node otherNode});
  Future<Either<Failure, GraphComponentsRepository>> removeAll();
}
