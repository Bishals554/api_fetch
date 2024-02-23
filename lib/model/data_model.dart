class DataModel {
  String? status;
  List<UserData?>? data;
  String? message;

  DataModel({
    this.status,
    this.data,
    this.message,
  });

  DataModel.fromJson(Map<String, dynamic> json) {
    status = json['success'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((element) {
        data?.add(UserData.fromJson(element));
      });
    }
  }
}

class UserData {
  int? id;
  String? employeeName;
  int? employeeSalary;
  int? employeeAge;
  String? profileImage;

  UserData({
    this.id,
    this.employeeName,
    this.employeeSalary,
    this.employeeAge,
    this.profileImage,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      employeeName: json['employee_name'],
      employeeSalary: json['employee_salary'],
      employeeAge: json['employee_age'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_name'] = employeeName;
    data['employee_salary'] = employeeSalary;
    data['employee_age'] = employeeAge;
    data['profile_image'] = profileImage;
    return data;
  }
}
