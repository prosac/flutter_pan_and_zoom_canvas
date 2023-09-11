import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/graph.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/node.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/repositories/files_repository.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/injection_container.dart';

class FileLoadingFailure extends Failure {}

class LoadFilesIntoGraph implements UseCase<Graph, NoParams> {
  final FilesRepository filesRepository;
  final Graph graph;

  LoadFilesIntoGraph(FilesRepository this.filesRepository, Graph this.graph);

  @override
  Future<Either<Failure, Graph>> call(NoParams params) async {
    late List files;
    Either maybeFiles = await _loadFiles(NoParams());

    maybeFiles.fold((l) => FileLoadingFailure(), (r) => files = r);

    for (final PlainTextFile file in files) {
      graph.addNode(Node(id: graph.nextId, data: PlainTextFile(file.contents)));
    }

    return Right(graph);
  }

  Future<Either<Failure, List<PlainTextFile>>> _loadFiles(NoParams param) async {
    return filesRepository.allFiles();
  }
}

loadFiles() async => sl<LoadFilesIntoGraph>().call(NoParams());

// void loadFiles(BuildContext context) async {
//   final model = context.read<GraphModel>();
//   var files = await LocalStorageDirectory().files();

//   files.forEach((entity) async {
//     if (entity is File) {
//       PlainTextFile file = await PlainTextFile.asyncFromFile((entity));

//       var offset = Offset(Random().nextInt(1000).toDouble(), Random().nextInt(1000).toDouble());
//       final newNode = Node(offset: offset, payload: TestData(text: 'Some file loaded from storage dir'));
//       newNode.presentation = PlainTextFilePresentation(
//           node: newNode, file: file, onAddPressed: () => addThingFromExisting(newNode, context));

//       model.add(newNode);
//     }

//     context.read<ViewerState>().exitSpaceCommandMode();
//   });
// }
