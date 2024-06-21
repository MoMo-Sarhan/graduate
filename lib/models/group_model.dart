class GroupModel {
  final String group_name;
  final List<dynamic> member_ids;
  final List<dynamic> admins;
  final int level;
  final String departement;
  final bool permissions;
  final String imagePath;
  GroupModel({
    required this.imagePath,
    required this.group_name,
    required this.member_ids,
    required this.admins,
    required this.permissions,
    required this.level,
    required this.departement,
  });
  String getFullName() {
    return this.group_name;
  }

  factory GroupModel.fromDocs(data) {
    return GroupModel(
      imagePath: data['imagePath'],
      group_name: data['group_name'],
      member_ids: data['member_ids'],
      admins: data['admins'],
      permissions: data['permissions'],
      level: data['level'],
      departement: data['departement'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group_name': group_name,
      'imagePath':imagePath,
      'member_ids': member_ids,
      'admins': admins,
      'permissions': permissions,
      'level': level,
      'departement': departement,
    };
  }
}
