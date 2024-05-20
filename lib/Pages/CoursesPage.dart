import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduate/component/ContainerCourse.dart';
import 'package:graduate/component/customFloationbutton.dart';
import 'package:graduate/helper/reusableFunc.dart';
import 'package:graduate/services/course_services.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String link = '';
  bool showOption = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            link.isEmpty ? const Text('Courses') : Text(link.split('/').last),
        centerTitle: true,
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
      ),
      body: RefreshIndicator(
          onRefresh: () => _refreshPage(), child: _buildCourseList()),
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
        return CustomScrollView(
          slivers: [
            SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisExtent: 150,
                crossAxisSpacing: 1,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => ContainerCourse(
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
            ),
          ],
        );
      },
    );
  }
}
