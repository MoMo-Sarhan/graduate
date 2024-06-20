import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/screens/edit_profile_page.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isDarkMode = false;
  bool _getNotifications = true;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });

    if (_isDarkMode) {
      // Enable dark mode
      _setDarkMode(context);
    } else {
      // Enable light mode
      _setLightMode(context);
    }
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _getNotifications = value;
    });
    // Handle notifications setting change here
  }

  void _setDarkMode(BuildContext context) {
    ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.blue,
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.purpleAccent),
    );

    // Update the theme
  }

  void _setLightMode(BuildContext context) {
    ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.purpleAccent),
    );

    // Update the theme
  }

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
          const Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Replace with the actual image URL
                ),
                SizedBox(height: 16.0),
                Text(
                  'Mohamed Adel', // Replace with the actual account name
                  style: TextStyle(
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
