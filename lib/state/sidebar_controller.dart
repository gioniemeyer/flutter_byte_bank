import 'package:flutter/foundation.dart';

class SidebarController extends ChangeNotifier {
  String? _selectedItem;

  String? get selectedItem => _selectedItem;

  void setSelectedItem(String value) {
    _selectedItem = value;
    notifyListeners();
  }
}
