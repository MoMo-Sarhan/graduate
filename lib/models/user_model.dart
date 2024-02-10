class UserModel {
  final String? uid;
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String email;
  final String userType;
  final String? department;
  final double? gpa;
  final String? password;
  final String profileIcon;
  final int? level;
  final List<String>? courses;

  UserModel(
      {this.uid,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.email,
      required this.phone,
      required this.userType,
      required this.profileIcon,
      this.level,
      this.gpa,
      this.courses,
      this.department,
      this.password});

  factory UserModel.fromDocs(data) {
    return UserModel(
      uid: data['uid'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      gender: data['gender'],
      email: data['email'],
      phone: data['phone'],
      userType: data['userType'],
      profileIcon: data['profileIcon'],
      gpa: data['gpa'],
      department: data['department'],
      level: data['level'],
      // courses: data['courses'],
    );
  }
  bool isStudent() => userType == 'Student' ? true : false;
  bool isDoctor() => userType == 'Doctor' ? true : false;
  bool isGeneral() => userType == 'General' ? true : false;
  String getFullName() => '$firstName $lastName';
}
