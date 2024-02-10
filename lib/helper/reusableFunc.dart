
  import 'package:cloud_firestore/cloud_firestore.dart';

String getTime(Timestamp time) {
    DateTime timeData = time.toDate();
    int hour = timeData.hour;
    int second = timeData.second;
    int day = timeData.day;
    int month = timeData.month;
    int year = timeData.year;
    return '$hour:$second $day/$month/$year';
  }



  Future<String> getUserName(String uid) async {
    try {
      DocumentSnapshot users =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (users.exists) {
        return users['userName'].toString();
      }
    } catch (e) {
      print("from me:$e");
      return null!;
    }
    return null!;
  }