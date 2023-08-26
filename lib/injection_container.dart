import 'package:flutter/cupertino.dart';
import 'package:flutter_pan_and_zoom/core/data/data_sources/local_filesystem_data_source.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/connect.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node_from_existing.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/delete_all_nodes_things.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/initiate_connecting.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // state
  getIt.registerSingleton<InteractionState>(InteractionState());
  getIt.registerSingleton<Graph>(Graph());
  getIt.registerSingleton<ViewerState>(ViewerState(focusNode: FocusNode()));
  // Maybe see the dragging procedure of a kind of state?
  // getIt.registerSingleton<DraggingProcedure>(DraggingProcedure(notifier: notifier));

  // Use cases
  getIt.registerSingleton<CreateNode>(CreateNode(getIt(), getIt()));
  getIt.registerSingleton<Connect>(Connect(getIt(), getIt()));
  getIt.registerSingleton<CreateNodeFromExisting>(CreateNodeFromExisting(getIt()));
  getIt.registerSingleton<DeleteAllNodes>(DeleteAllNodes(getIt()));
  getIt.registerSingleton<InitiateConnecting>(InitiateConnecting(getIt(), getIt()));

  getIt.registerLazySingleton<LocalFilesystemDataSource>(() => LocalFilesystemDataSourceImplementation());
}
