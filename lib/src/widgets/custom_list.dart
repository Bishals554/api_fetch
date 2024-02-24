import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  final int id;
  final String employeeName;
  final int employeeSalary;
  final int employeeAge;
  final String? profileImage;
  const CustomList({
    super.key,
    required this.id,
    required this.employeeName,
    required this.employeeSalary,
    this.profileImage,
    required this.employeeAge,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      profileImage != null && profileImage!.isNotEmpty
                          ? NetworkImage(profileImage!)
                          : null,
                  maxRadius: 30,
                  child: profileImage == null || profileImage!.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name: $employeeName',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'ID: $id',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Salary: Rs $employeeSalary',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              'Age: $employeeAge Years',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
