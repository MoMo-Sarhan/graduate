import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graduate/Pages/AddPostPage.dart';
import 'package:graduate/Pages/HomePage.dart';
import 'package:graduate/Pages/LoginPage.dart';
import 'package:graduate/Pages/MainPage.dart';
import 'package:graduate/Pages/RegisterPage.dart';
import 'package:graduate/Pages/Search_post_page.dart';
import 'package:graduate/Pages/addGroupPage.dart';
import 'package:graduate/Pages/chat_page.dart';
import 'package:graduate/Pages/splash_page.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_cubits.dart';
import 'package:graduate/cubits/DarkMode_cubits/dark_mode_state.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/cubits/Navigation_cubits/navigation_cubit.dart';
import 'package:graduate/firebase_options.dart';
import 'package:graduate/Pages/AuthGate.dart';
import 'package:graduate/models/login_bloc_observer.dart';
import 'package:graduate/screens/Bots_pages/bots_screen.dart';
import 'package:graduate/screens/sign_up.dart';

void main() async {
  Bloc.observer = LoginBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initNotifications();
  runApp(const MyApp());
}

Future<void> initNotifications() async {
  // Create an instance of FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize settings for Android and iOS
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize the plugin with the initialized settings
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginStateCubit>(
            create: (context) => LoginStateCubit()..checAuth()),
        BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),
        BlocProvider<ModeStateCubit>(create: (context) => ModeStateCubit())
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<ModeStateCubit, ModeState>(
          builder: (context, state) {
            return MaterialApp(
              theme: ThemeData(
                brightness:
                    state is DarkModeState ? Brightness.dark : Brightness.light,
              ),
              routes: {
                RegisterPage.ID: (context) => RegisterPage(),
                LoginPage.ID: (context) => LoginPage(),
                AddPostPage.ID: (context) => const AddPostPage(),
                ChatPage.ID: (context) => const ChatPage(),
                SignUpScreen.id: (context) => const SignUpScreen(),
                SearchPostPage.ID: (context) => const SearchPostPage(),
                AddGroupPage.id: (context) => const AddGroupPage(),
                BotsScreen.id: (context) => BotsScreen(),
                AuthGate.id: (context) => const AuthGate(),
                SplashScreen.id: (context) => const SplashScreen(),
                MainPage.id:(context)=>const MainPage(),
                HomePage.id: (context) => const HomePage(),
              },
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
            );
          },
        );
      }),
    );
  }
}
