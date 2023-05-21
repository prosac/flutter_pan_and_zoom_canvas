import 'package:dartz/dartz.dart';
import 'package:flutter_pan_and_zoom/core/domain/entities/plain_text_file.dart';
import 'package:flutter_pan_and_zoom/core/domain/errors/failure.dart';
import 'package:flutter_pan_and_zoom/core/domain/use_cases/use_case.dart';
import 'package:flutter_pan_and_zoom/core/util/random.dart';

// void addPlainTextFile(offset, BuildContext context) async {
//   final newNode = Node(offset: offset, payload: TestData(text: 'Some other Payload'));
//   final model = context.read<Graph>();

//   PlainTextFile file = await PlainTextFile.asyncNew(randomString(10));

//   newNode.presentation =
//       PlainTextFilePresentation(node: newNode, file: file, onAddPressed: () => addThingFromExisting(newNode, context));

//   model.add(newNode);
//   context.read<ViewerState>().exitSpaceCommandMode();
// }

class AddPlaintextFile implements UseCase<PlainTextFile, NoParams> {
  final FilesRepository filesRepository;

  AddPlaintextFile(this.filesRepository);

  @override
  Future<Either<Failure, PlainTextFile>> call(NoParams params) async {
    PlainTextFile file = await PlainTextFile.asyncNew(randomString(10));
    // TODO: also add node that represents file?

    return Right(file);
  }
}

class MyFailure extends Failure {}
