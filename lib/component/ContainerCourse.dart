import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:graduate/helper/reusableFunc.dart';

class ContainerCourse extends StatelessWidget {
  const ContainerCourse({super.key, required this.ref, required this.onTap});
  final Reference ref;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isImage(text: ref.fullPath)
          ? _loadImage()
          : Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                color: isFile(text: ref.fullPath.split('/').last)
                    ? Color.fromARGB(255, 175, 219, 177)
                    : const Color.fromARGB(255, 134, 132, 132),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  ref.fullPath.split('/').last,
                  style: const TextStyle(
                      color: Colors.white, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
    );
  }

  Widget _loadImage() {
    return FutureBuilder(
      future: ref.getDownloadURL(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }
        return Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.height / 4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(snapshot.data!), fit: BoxFit.fill)),
        );
      }),
    );
  }
}
