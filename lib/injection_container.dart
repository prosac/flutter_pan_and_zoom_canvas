import 'package:flutter/cupertino.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:get_it/get_it.dart';

import 'core/domain/entities/graph_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => GraphModel());
  sl.registerLazySingleton(() => ViewerState(focusNode: FocusNode()));
}
