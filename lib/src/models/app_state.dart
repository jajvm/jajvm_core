import 'package:riverpod/riverpod.dart';

import 'app_state_model.dart';

final appStateProvider = StateProvider((ref) {
  return AppState(AppStateModel());
});

class AppState extends StateNotifier {
  AppState(super.state);

  // final _javaDirectoryValidator = JavaDirectoryValidator();

  Future<void> addSystemJavaRelease({
    required String path,
    required String version,
    required String vender,
    required String nickname,
  }) async {
    // Verify path is a valid java release directory

    // Copy folder to `.jajvm/versions` directory

    // Add new directory path to list of Java releases

    // Update java releases database with new list

    // Update state with new list

    // state = state.copyWith(
    //   javaDirectories: [
    //     ...state.javaDirectories,
    //     JavaRelease(
    //       directory: Directory(path),
    //       version: '',
    //       vender: '',
    //       nickname: '',
    //     ),
    //   ],
    // );
  }
}
