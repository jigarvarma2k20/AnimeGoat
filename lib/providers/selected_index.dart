import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedIndex extends StateNotifier<int> {
  SelectedIndex() : super(0);

  set selectedIndex(int index) => state = index;
}

final selectedIndexProvider = StateNotifierProvider<SelectedIndex, int>((ref) {
  return SelectedIndex();
});
