
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_state.dart';

class ModeStateCubit extends Cubit<ModeState> {
  ModeStateCubit() : super(LightModeState());
  bool _mode = false;
  bool get mode => _mode;
  set mode(bool value) {
    _mode = value;
    emit(_mode ? DarkModeState() : LightModeState());
  }
}
