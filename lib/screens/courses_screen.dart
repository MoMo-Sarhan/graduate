import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graduate/component/customFloationbutton.dart';
import 'package:graduate/helper/reusableFunc.dart';
import 'package:graduate/screens/course_detail_page.dart';
import 'package:graduate/services/course_services.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with TickerProviderStateMixin {
  String link = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  log(link);
                  var parts = link.split('/');
                  parts.removeLast();
                  link = parts.join('/');
                  log(link);
                });
              },
              icon: const Icon(Icons.arrow_upward))
        ],
        automaticallyImplyLeading: false,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.blue, Colors.purpleAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            link.isEmpty ? 'Your Courses' : link.split('/').last,
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshPage(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildCourseList(),
        ),
      ),
      floatingActionButton: CustomFloationButton(
        link: link,
      ),
    );
  }

  Future<void> _refreshPage() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  Widget _buildCourseList() {
    return FutureBuilder(
      future: CourseService().getLevelDirs(context: context, link: link),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }

        List<String> text = [];
        for (var element in snapshot.data!) {
          text.add(element.fullPath);
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.75,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
              },
              child: CourseCard(
                onTap: () {
                  setState(() {
                    link = snapshot.data![index].fullPath;
                  });
                  if (isFile(text: link)) {
                    CourseService().downloadFile(ref: snapshot.data![index]);
                  }
                  log(link);
                },
                ref: snapshot.data![index],
              ),
            );
          },
        );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final Reference ref;
  final Function() onTap;

  const CourseCard({
    super.key,
    required this.ref,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String name = 'Flutter Development';
    String imageUrl = 'https://via.placeholder.com/150';
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: GestureDetector(
        onTap: onTap,
        child: isImage(text: ref.fullPath)
            ? _loadImage()
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: isFile(text: ref.fullPath)
                          ? ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.blue, Colors.purpleAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Image.asset(
                                'assets/pdf-document-2615.png',
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width / 2,
                                color: Colors.white,
                              ),
                            )
                          : Center(
                              child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.blue, Colors.purpleAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Icon(
                                Icons.folder,
                                size: MediaQuery.of(context).size.width / 3,
                                color: Colors.white,
                              ),
                            )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          ref.fullPath.split('/').last,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
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
