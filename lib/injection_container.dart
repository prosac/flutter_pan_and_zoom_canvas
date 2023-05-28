import 'package:flutter/cupertino.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/connect.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node_from_existing.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/delete_all_nodes_things.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/initiate_connecting.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => Graph());
  sl.registerLazySingleton(() => InteractionState());
  sl.registerLazySingleton(() => ViewerState(focusNode: FocusNode()));

  // Use cases
  sl.registerLazySingleton(() => CreateNode(sl()));
  sl.registerLazySingleton(() => Connect(sl(), sl()));
  sl.registerLazySingleton(() => CreateNodeFromExisting(sl()));
  sl.registerLazySingleton(() => DeleteAllNodes(sl()));
  sl.registerLazySingleton(() => InitiateConnecting(sl(), sl()));
}
