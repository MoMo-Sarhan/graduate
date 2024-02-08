import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/Pages/HomePage.dart';
import 'package:graduate/Pages/LoginPage.dart';
import 'package:graduate/Pages/RegisterPage.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits_state.dart';
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
    return BlocProvider(
      create: (context) => LoginStateCubit(),
      child: Builder(builder: (context) {
        return MaterialApp(
            routes: {
              RegisterPage.ID: (context) => RegisterPage(),
              LoginPage.ID: (context) => LoginPage(),
            },
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: BlocBuilder<LoginStateCubit, SignUpState>(
              builder: (context, state) {
                if (state is NotLoginYet) {
                  return HomePage();
                } else
                  return RegisterPage();
              },
            ));
      }),
    );
  }
}
