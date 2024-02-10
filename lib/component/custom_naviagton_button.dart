import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graduate/models/customNavigationbutton.dart';

GButton bottomNavigationBarItem(
    {required MyBottomBarModel bar, required int selected}) {
  return GButton(
    onPressed: bar.onpressed,
    icon: bar.icon!,
    active: bar.index == selected ? true : false,
  );
}
