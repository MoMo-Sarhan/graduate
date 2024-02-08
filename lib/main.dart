import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/HomePage.dart';
import 'package:graduate/Pages/LoginPage.dart';
import 'package:graduate/Pages/RegisterPage.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
import 'package:graduate/cubits/Navigation_cubits/navigation_cubit.dart';
import 'package:graduate/firebase_options.dart';
import 'package:graduate/helper/AuthGate.dart';
import 'package:graduate/services/auth/auth_services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
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
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          routes: {
            RegisterPage.ID: (context) => RegisterPage(),
            LoginPage.ID: (context) => LoginPage(),
          },
          debugShowCheckedModeBanner: false,
          home: AuthGate(),
        );
      }),
    );
  }
}
