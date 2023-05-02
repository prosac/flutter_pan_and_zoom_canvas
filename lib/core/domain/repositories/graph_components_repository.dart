import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

abstract class GraphComponentsRepository {
  Future<Either<Failure, List<Node>>> nodes();
  Future<Either<Failure, Node>> createNode();
  Future<Either<Failure, List<Edge>>> edges();
  Future<Either<Failure, Edge>> createEdge();
}
