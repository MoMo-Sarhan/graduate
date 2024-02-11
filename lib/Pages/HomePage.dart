import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduate/component/animationHomePage.dart';
import 'package:graduate/services/chooseIcons_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
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
                  radius: 100,
                  backgroundImage: NetworkImage(snapshot.data!),
                ),
              );
            }
          },
        ),
        AnimationHomePage(
          second: 5,
          direction: Axis.horizontal,
        ),
        AnimationHomePage(
          second: 7,
          direction: Axis.vertical,
        ),
      ]),
    );
  }
}
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graduate/cubits/Login_cubits/login_cubits.dart';
// import 'package:graduate/services/chooseIcons_services.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: FutureBuilder(
//         future: ChooseIconService()
//             .getImageByUid(uid: FirebaseAuth.instance.currentUser!.uid),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return const Center(
//               child: Text('Errror'),
              
//             );
//           } else {
//             return Image.network(snapshot.data!);
//           }
//         },
//       )),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await BlocProvider.of<LoginStateCubit>(context).SignOut();
//         },
//       ),
//     );
//   }
// }
