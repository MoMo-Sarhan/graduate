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
  final String password;
  final String profileIcon;
  final int? level;
  final List<String>? Courses;

  UserModel({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phone,
    required this.userType,
    required this.profileIcon,
    required this.password,
    this.level,
    this.gpa,
    this.Courses,
    this.department,
  });

  factory UserModel.fromDocs(data) {
    return UserModel(
      uid: data['id'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      gender: data['gender'],
      email: data['email'],
      phone: data['email'],
      userType: data['userType'],
      profileIcon: data['profileIcon'],
      password: data['password'],
      gpa: data['gpa'],
      department: data['department'],
      level: data['level'],
      Courses: data['courses'],
    );
  }
  bool isStudent() => userType == 'Student' ? true : false;
  bool isDoctor() => userType == 'Doctor' ? true : false;
  bool isGeneral() => userType == 'General' ? true : false;
  String getFullName() => '$firstName $lastName';
}
