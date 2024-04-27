import 'package:flutter/material.dart';
import 'package:graduate/services/course_services.dart';
import 'package:graduate/utils/animations.dart';

class CustomFloationButton extends StatefulWidget {
  const CustomFloationButton({super.key, required this.link});
  final String link;

  @override
  State<CustomFloationButton> createState() => _CustomFloationButtonState();
}

class _CustomFloationButtonState extends State<CustomFloationButton> {
  bool showOption = false;
  double iconSize = 40;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.of(context).size.height / 3.5,
      width: 50,
      child: Column(
        children: [
          Expanded(
              child: showOption
                  ? ShowUpAnimation(
                      delay: 100,
                      child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: [
                            IconButton(
                                onPressed: () {
                                  CourseService().pickFile(
                                      context: context, link: widget.link);
                                },
                                icon: Icon(
                                  Icons.upload_file,
                                  size: iconSize,
                                )),
                            IconButton(
                                onPressed: () {
                                  CourseService().creatCourse(
                                    context: context,
                                    link: widget.link,
                                  );
                                },
                                icon: Icon(
                                  Icons.create_new_folder_rounded,
                                  size: iconSize,
                                )),
                          ]),
                    )
                  : const SizedBox()),
          const SizedBox(
            width: 20,
          ),
          showOption
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      showOption = false;
                    });
                  },
                  child: const Icon(
                    Icons.close,
                    size: 40,
                  ))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      showOption = true;
                    });
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 40,
                  ))
        ],
      ),
    );
  }
}
