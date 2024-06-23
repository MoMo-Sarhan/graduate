import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduate/component/animationHomePage.dart';
import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const id = 'Home Page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: ChooseIconService()
                    .getImageByUid(uid: FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Errror'),
                    );
                  } else {
                    return SafeArea(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(snapshot.data!),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                width: 7,
              ),
              if (BlocProvider.of<LoginStateCubit>(context).userModel != null)
                Text(BlocProvider.of<LoginStateCubit>(context)
                    .userModel!
                    .getFullName())
            ],
          )),
      body: Column(children: [
        AnimationHomePage(
          user: BlocProvider.of<LoginStateCubit>(context).userModel,
          second: 5,
          direction: Axis.horizontal,
        ),
        AnimationHomePage(
          user: BlocProvider.of<LoginStateCubit>(context).userModel,
          second: 7,
          direction: Axis.vertical,
        ),
      ]),
    );
  }
}
