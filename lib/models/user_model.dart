class UserModel {
  final String id;
  final String firstName;
  final String LastName;
  final String gender;
  final String phone;
  final String email;
  final String userType;
  final String? department;
  final String? gpa;
  final String password;
  final String profileIcon;
  final int? level;
  final List<String>? Courses;

  UserModel({
    required this.id,
    required this.firstName,
    required this.LastName,
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
      id: data['id'],
      firstName: data['firstName'],
      LastName: data['lastName'],
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
  String getFullName() => '$firstName $LastName';
}