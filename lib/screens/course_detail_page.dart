import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  final String name;
  final String imageUrl;

  const CourseDetailPage({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> courseContent = List.generate(30, (index) {
      return {
        'title': 'Course Module ${index + 1}',
        'duration': '${(index + 1) * 5}min',
        'locked': index % 2 == 0 ? 'false' : 'true',
      };
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(name),
              titlePadding: const EdgeInsets.only(left: 40, bottom: 16),
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),
                        Text(
                          'Course Content',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('30 lecture',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        SizedBox(height: 16),
                        Divider(),
                      ],
                    ),
                  );
                }
                final content = courseContent[index - 1];
                return ListTile(
                  leading: Icon(
                    content['locked'] == 'true'
                        ? Icons.lock
                        : Icons.play_circle_fill,
                    color: content['locked'] == 'true'
                        ? Colors.grey
                        : Colors.purple,
                  ),
                  title: Text(content['title']!),
                  subtitle: Text(content['duration']!),
                );
              },
              childCount: courseContent.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
