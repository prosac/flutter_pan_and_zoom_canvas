import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:equatable/equatable.dart';

class Edge extends Equatable {
  Edge({required this.source, required this.destination});

  final Node source;
  final Node destination;

  bool isConnectedTo(node) {
    return (node == source || node == destination);
  }

  @override
  List<Object> get props => [source, destination];
}
