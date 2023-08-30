import 'package:flutter/cupertino.dart';
import 'package:flutter_pan_and_zoom/core/data/data_sources/local_filesystem_data_source.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/connect.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/create_node_from_existing.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/delete_all_nodes_things.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/initiate_connecting.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/reset_viewport.dart';
import 'package:flutter_pan_and_zoom/core/interaction_state.dart';
import 'package:flutter_pan_and_zoom/core/presentation/dragging_procedure.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:flutter_pan_and_zoom/keyboard_events.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // state
  sl.registerSingleton<InteractionState>(InteractionState());
  sl.registerSingleton<Graph>(Graph());
  sl.registerSingleton<ViewerState>(ViewerState(focusNode: FocusNode()));
  sl.registerSingleton<DraggingProcedure>(DraggingProcedure(graph: sl(), viewerState: sl()));
  sl.registerSingleton<KeyboardEvents>(KeyboardEvents());

  // Use cases
  sl.registerSingleton<CreateNode>(CreateNode(sl(), sl()));
  sl.registerSingleton<Connect>(Connect(sl(), sl()));
  sl.registerSingleton<CreateNodeFromExisting>(CreateNodeFromExisting(sl()));
  sl.registerSingleton<DeleteAllNodes>(DeleteAllNodes());
  sl.registerSingleton<ResetViewport>(ResetViewport());
  sl.registerSingleton<InitiateConnecting>(InitiateConnecting(sl(), sl()));

  sl.registerLazySingleton<LocalFilesystemDataSource>(() => LocalFilesystemDataSourceImplementation());
}
