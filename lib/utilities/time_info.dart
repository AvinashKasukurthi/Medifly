import 'package:flutter/widgets.dart';

class SlotData extends ChangeNotifier {
  String slot;
  bool clicked = false;

  void selectSlot(value) {
    clicked = true;
    slot  = value;
    notifyListeners();
  }

  void userOut() {
    clicked = false;
    notifyListeners();
  }
}