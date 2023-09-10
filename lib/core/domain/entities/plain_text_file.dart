import 'package:equatable/equatable.dart';

class PlainTextFile with EquatableMixin {
  String contents;

  PlainTextFile(String this.contents);

  @override
  List<Object?> get props => [contents];
}
