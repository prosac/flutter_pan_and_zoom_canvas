import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/data/data_sources/graph_components_local_data_source.dart';
import 'package:flutter_pan_and_zoom/core/data/models/node_model.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/graph_components_repository.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

class GraphComponentsRepositoryImplementation
    implements GraphComponentsRepository {
  // TODO: implement remote data source
  final GraphComponentsLocalDataSource localDataSource;

  GraphComponentsRepositoryImplementation({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Node>>> nodes() async {
    return await localDataSource.nodes();
  }

  @override
  Future<Either<Failure, NodeModel>> createNode(
      {required id, required dx, required dy}) async {
    return await localDataSource.createNode(id: id, dx: dx, dy: dy);
  }

  @override
  Future<Either<Failure, List<Edge>>> edges() async {
    return await localDataSource.edges();
  }

  @override
  Future<Either<Failure, Edge>> createEdge() async {
    return await localDataSource.createEdge();
  }
}
