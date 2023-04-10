import 'package:flutter/material.dart';
import 'package:flutter_pan_and_zoom/model/graph_model.dart';
import 'package:flutter_pan_and_zoom/model/viewer_state.dart';
import 'package:provider/provider.dart';

void deleteAllTheThings(BuildContext context) {
  context.read<ViewerState>().exitSpaceCommandMode();
  context.read<GraphModel>().removeAll();
}
