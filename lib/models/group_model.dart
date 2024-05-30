class Group {
  final String group_name;
  final List<String> member_ids;
  final List<String> admins;
  final bool permissions;
  Group(
      {required this.group_name,
      required this.member_ids,
      required this.admins,
      required this.permissions});

  factory Group.fromJosn(data) {
    return Group(
        group_name: data['group_name'],
        member_ids: data['member_ids'],
        admins: data['admins'],
        permissions: data['permissions']);
  }

  Map<String, dynamic> toMap() {
    return {
      'group_name': group_name,
      'member_ids': member_ids,
      'admins': admins,
      'permissions': permissions,
    };
  }
}
