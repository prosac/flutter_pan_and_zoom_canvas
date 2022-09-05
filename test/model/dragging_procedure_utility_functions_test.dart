import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pan_and_zoom/model/dragging_procedure_utility_functions.dart';

void main() {
  group('.offsetAdaptedToViewParameters()', () {
    test('returns Offset(1,1) for O(1,1), 1.0, O(0)', () {
      expect(
          DraggingProcedureUtilityFunctions.offsetAdaptedToViewParameters(
              Offset(1, 1), 1.0, Offset.zero),
          Offset(1, 1));
    });
  });
}
