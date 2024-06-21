import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/setting_pages/Rating_Page.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/screens/edit_profile_page.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _getNotifications = true;

  void _toggleTheme(bool value) {
    setState(() {});
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _getNotifications = value;
    });
    // Handle notifications setting change here
  }

  // Update the theme

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.blue, Colors.purpleAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Column(
              children: [
                FutureBuilder(
                  future: ChooseIconService().getImageByUid(
                      uid: FirebaseAuth.instance.currentUser?.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Errror'),
                      );
                    } else if (snapshot.data == null) {
                      return const Center(
                        child: Text('Null data'),
                      );
                    } else {
                      return SafeArea(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(snapshot.data!),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 16.0),
                if (BlocProvider.of<LoginStateCubit>(context).userModel != null)
                  Text(
                    BlocProvider.of<LoginStateCubit>(context)
                        .userModel!
                        .getFullName(), // Replace with the actual account name
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
              height:
                  32.0), // Add some spacing between the profile section and the settings list
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              // Navigate to edit profile photo page
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const EditProfilePage();
              }));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: BlocProvider.of<ModeStateCubit>(context).mode,
              onChanged: (value) {
                BlocProvider.of<ModeStateCubit>(context).mode =
                    !BlocProvider.of<ModeStateCubit>(context).mode;
                _toggleTheme(value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text('Rate Us'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RatingPage()));

              // Handle rate us
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Get Notifications'),
            trailing: Switch(
              value: _getNotifications,
              onChanged: (value) {
                _toggleNotifications(value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                  context: context,
                  builder: ((context) => AlertDialog(
                        title: const Center(child: Text('LogOut')),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')),
                          const SizedBox(
                            width: 100,
                          ),
                          TextButton(
                              onPressed: () async {
                                BlocProvider.of<ModeStateCubit>(context).mode =
                                    false;
                                await BlocProvider.of<LoginStateCubit>(context)
                                    .SignOut();
                                Navigator.of(context).pop();
                              },
                              child: const Text('log out')),
                        ],
                      )));
            }
            // Handle log out
            ,
          ),
        ],
      ),
    );
  }
}
