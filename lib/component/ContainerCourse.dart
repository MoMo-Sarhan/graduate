import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:graduate/helper/reusableFunc.dart';
import 'package:graduate/services/course_services.dart';

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
          : Stack(
              children: [
                Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                            // padding: const EdgeInsets.all(8),
                            // margin: const EdgeInsets.all(8),
                            // width: MediaQuery.of(context).size.width / 2.5,
                            // height: MediaQuery.of(context).size.height / 4,
                            decoration: BoxDecoration(
                              // color: isFile(text: ref.fullPath.split('/').last)
                              //     ? Color.fromARGB(255, 175, 219, 177)
                              //     : const Color.fromARGB(255, 134, 132, 132),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: isFile(text: ref.fullPath.split('/').last)
                                ? Icon(
                                    Icons.edit_document,
                                    size: MediaQuery.of(context).size.width / 4,
                                  )
                                : Icon(
                                    Icons.folder_rounded,
                                    size: MediaQuery.of(context).size.width / 4,
                                    color: Color.fromARGB(255, 83, 46, 36),
                                  )),
                      ),
                      Text(
                        ref.fullPath.split('/').last,
                        style: const TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 3,
                  child: PopupMenuButton<String>(onSelected: (value) {
                    if (value == 'Delete') {
                      CourseService()
                          .delete(link: ref.fullPath, context: context);
                    }
                  }, itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        value: 'Delete',
                        height: 20,
                        child: Text('Delete'),
                      ),
                      PopupMenuItem(
                        value: 'Rename',
                        height: 20,
                        child: Text('Rename'),
                      )
                    ];
                  }),
                )
              ],
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
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.height / 4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: NetworkImage(snapshot.data!), fit: BoxFit.fill)),
        );
      }),
    );
  }
}
