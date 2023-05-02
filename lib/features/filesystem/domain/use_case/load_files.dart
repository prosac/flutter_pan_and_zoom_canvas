import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:file/file.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pan_and_zoom/core/data/test_data.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/local_storage_directory.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/nodes_repository.dart';
import 'package:flutter_pan_and_zoom/features/plain_text_files/presentation/plain_text_file_presentation.dart';

import '../../../../core/domain/use_cases/use_case.dart';

// void loadFiles(BuildContext context) async {
//   final model = context.read<GraphModel>();
//   var files = await LocalStorageDirectory().files();

//   files.forEach((entity) async {
//     if (entity is File) {
//       PlainTextFile file = await PlainTextFile.asyncFromFile((entity));

//       var offset = Offset(
//           Random().nextInt(1000).toDouble(), Random().nextInt(1000).toDouble());
//       final newNode = Node(
//           offset: offset,
//           payload: TestData(text: 'Some file loaded from storage dir'));
//       newNode.presentation = PlainTextFilePresentation(
//           node: newNode,
//           file: file,
//           onAddPressed: () => addThingFromExisting(newNode, context));

//       model.add(newNode);
//     }

//     context.read<ViewerState>().exitSpaceCommandMode();
//   });
// }

class LoadFiles implements UseCase<Node, NoParams> {
  final NodesRepository nodesRepository;
  final FilesRepository filesRepository;
  late final List<Node> fileNodes;

  LoadFiles(this.nodesRepository, this.filesRepository);

  @override
  Future<Either<Failure, List<Node>> call(NoParams params) async {
    var files = await filesRepository().allFiles();

    files.forEach((entity) async {

    if (entity is File) {
      PlainTextFile file = await PlainTextFile.asyncFromFile((entity));
    }
    }

//       var offset = Offset(
//           Random().nextInt(1000).toDouble(), Random().nextInt(1000).toDouble());
//       final newNode = Node(
//           offset: offset,
//           payload: TestData(text: 'Some file loaded from storage dir'));
//       newNode.presentation = PlainTextFilePresentation(
//           node: newNode,
//           file: file,
//           onAddPressed: () => addThingFromExisting(newNode, context));

//       model.add(newNode);
//     }

//     context.read<ViewerState>().exitSpaceCommandMode();
//   });

  }
}
