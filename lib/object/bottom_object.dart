import 'package:rive/rive.dart';

class BottomObject {
  final String name;
  final String stateMachineName;
  final String? label;
  SMIInput<bool>? input;
  Artboard? artboard;

  BottomObject({
    required this.name,
    required this.stateMachineName,
    this.label,
  });

  set setInput(SMIInput<bool>? _input) => input = _input;
  set setArtboard(Artboard? _artboard) => artboard = _artboard;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BottomObject &&
        other.name == name &&
        other.stateMachineName == stateMachineName &&
        other.label == label &&
        other.input == input &&
        other.artboard == artboard;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        stateMachineName.hashCode ^
        label.hashCode ^
        input.hashCode ^
        artboard.hashCode;
  }

  @override
  String toString() {
    return 'BottomObject(name: $name, stateMachineName: $stateMachineName, label: $label, input: $input, artboard: $artboard)';
  }
}
