import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/data/data_sources/graph_components_local_data_source.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/graph_components_repository.dart';
import 'package:flutter_pan_and_zoom/core/domain/values/edge.dart';

// RepositoryImplementation notes
// Transition into a more well behaved funtional world
// Mmethods catch exceptions of data sources and return Either types
// TODO: catch errors of data source layer and return them as Left<T> instances
class GraphComponentsRepositoryImplementation implements GraphComponentsRepository {
  // TODO: implement remote data source
  final GraphComponentsLocalDataSource localDataSource;

  GraphComponentsRepositoryImplementation({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Node>>> nodes() async {
    return Right(await localDataSource.nodes());
  }

  @override
  Future<Either<Failure, Node>> addNode(Node node) async {
    return Right(await localDataSource.addNode(id: id, dx: dx, dy: dy));
  }

  @override
  Future<Either<Failure, List<Edge>>> edges() async {
    return Right(await localDataSource.edges());
  }

  @override
  Future<Either<Failure, Edge>> createEdge({required Node node, required Node otherNode}) async {
    return Right(await localDataSource.createEdge(node: node, otherNode: otherNode));
  }
}
