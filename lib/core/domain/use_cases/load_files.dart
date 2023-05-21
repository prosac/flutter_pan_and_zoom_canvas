import 'package:dartz/dartz.dart';
import 'package:file/file.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/files_repository.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/graph_components_repository.dart';

import '../../../../core/domain/use_cases/use_case.dart';

// void loadFiles(BuildContext context) async {
//   final model = context.read<Graph>();
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

class LoadFiles implements UseCase<List<PlainTextFile>, NoParams> {
  final GraphComponentsRepository graphComponentsRepository;
  final FilesRepository filesRepository;
  late final List<Node> fileNodes;

  LoadFiles(this.graphComponentsRepository, this.filesRepository);

  @override
  Future<Either<Failure, List<PlainTextFile>>> call(NoParams params) async {
    var files = await filesRepository.fsEntities();

    return files
        .where((entity) => (entity is File), () => MyFailure())
        .map((entity) async => await PlainTextFile.asyncFromFile((entity as File)));
    // return files.where((entity) {
    //   return (entity is File);
    // }).map((entity) async {
    //   PlainTextFile file = await PlainTextFile.asyncFromFile((entity as File));
    //   return file;
    // });

    // TODO: implement all the presentation stuff etc. somewhere. see above.
  }
}

class MyFailure extends Failure {}
