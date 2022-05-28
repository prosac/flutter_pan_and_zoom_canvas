import 'package:flutter/widgets.dart';

// extension GlobalKeyExtension on GlobalKey {
//   Rect? get globalPaintBounds {
//     final renderObject = currentContext?.findRenderObject();
//     final translation = renderObject?.getTransformTo(null).getTranslation();
//     if (translation != null && renderObject?.paintBounds != null) {
//       final offset = Offset(translation.x, translation.y);
//       return renderObject!.paintBounds.shift(offset);
//     } else {
//       return null;
//     }
//   }
// }
extension GlobalKeyEx on GlobalKey {
  // Rect? get globalPaintBounds {
  //   final renderObject = currentContext?.findRenderObject();
  //   var translation = renderObject?.getTransformTo(null).getTranslation();
  //   if (translation != null) {
  //     return renderObject!.paintBounds
  //         .shift(Offset(translation.x, translation.y));
  //   } else {
  //     return null;
  //   }
  // }
  Offset globalOffset() {
    final renderObject = currentContext!.findRenderObject() as RenderBox;
    var translation = renderObject.getTransformTo(null).getTranslation();
    return Offset(translation.x, translation.y);
  }

  Offset globalOffset2() {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return Offset(translation.x, translation.y);
      // return renderObject!.paintBounds.shift(offset);
    } else {
      return Offset.zero;
    }
  }
}
