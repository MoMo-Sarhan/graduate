import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';

enum AppPage { login, home,onbarding }

class NavigationCubit extends Cubit<AppPage> {
  NavigationCubit() : super(AppPage.login);
  void navigationToLogin() => emit(AppPage.login); 
  void navigationToHome()=>emit(AppPage.home);
  void navigationToOnBard()=>emit(AppPage.onbarding);
}
