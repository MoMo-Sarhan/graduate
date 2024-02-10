import 'package:flutter_bloc/flutter_bloc.dart';

enum AppPage { login, home }

class NavigationCubit extends Cubit<AppPage> {
  NavigationCubit() : super(AppPage.login);
  void navigationToLogin() => emit(AppPage.login); 
  void navigationToHome()=>emit(AppPage.home);
}
