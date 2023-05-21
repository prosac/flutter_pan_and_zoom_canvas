import 'package:flutter/cupertino.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/viewer_state.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => Graph());
  sl.registerLazySingleton(() => ViewerState(focusNode: FocusNode()));
}
