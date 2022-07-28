import 'package:auto_size_text/auto_size_text.dart';
import '../Colors/colorManager.dart';
import '../Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class DataTableHeader extends StatefulWidget {
  @override
  State<DataTableHeader> createState() => _DataTableHeaderState();
}

class _DataTableHeaderState extends State<DataTableHeader> {
  @override
  Widget bodyData() => DataTable(
      onSelectAll: (b) {},
      sortColumnIndex: 1,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(
          label: const Text('First Name'),
          numeric: false,
          onSort: (i, b) {
            print('$i $b');
            setState(() {
              names.sort((a, b) => a.firstName.compareTo(b.firstName));
            });
          },
          tooltip: 'To display first name of the Name',
        ),
        DataColumn(
          label: const Text('Last Name'),
          numeric: false,
          onSort: (i, b) {
            print('$i $b');
            setState(() {
              names.sort((a, b) => a.lastName.compareTo(b.lastName));
            });
          },
          tooltip: 'To display last name of the Name',
        ),
      ],
      rows: names
          .map(
            (name) => DataRow(
              cells: [
                DataCell(
                  Text(name.firstName),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(name.lastName),
                  showEditIcon: false,
                  placeholder: false,
                )
              ],
            ),
          )
          .toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episode 5 - Data Table'),
      ),
      body: Container(
        child: bodyData(),
      ),
    );
  }
}

class Name {
  String firstName;
  String lastName;

  Name({this.firstName, this.lastName});
}

var names = <Name>[
  Name(firstName: 'Pawan', lastName: 'Kumar'),
  Name(firstName: 'Aakash', lastName: 'Tewari'),
  Name(firstName: 'Rohan', lastName: 'Singh'),
];
/*
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              SizedBox(
                  width: 160.w,
                  child: Center(
                      child: SizedBox(
                        height: 20,
                        child: Text(
                       'الأسم',
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                              setResponsiveFontSize(16),
                              color: ColorManager.primary),
                        ),
                      ))),
              Expanded(
                child: Row(
                  children: [
                    DataTableHeaderTitles(
                        'التأخير', ColorManager.primary),
                    DataTableHeaderTitles(
                        'حضور', ColorManager.primary),
                    DataTableHeaderTitles(
                       'انصراف', ColorManager.primary),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 50.h,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class AttendProovTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                        width: 160.w,
                        child: Center(
                            child: Container(
                              height: 20,
                              child: Text(
                               'الأسم',
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: setResponsiveFontSize(16),
                                    color: ColorManager.primary),
                              ),
                            ))),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50.h,
                      ),
                    ),
                    DataTableHeaderTitles('حالة الإثبات',
                        ColorManager.primary),
                    SizedBox(
                      width: 10,
                    ),
                    DataTableHeaderTitles(
                       'التوقيت', ColorManager.primary),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class DataTableHeaderTitles extends StatelessWidget {
  final String title;
  final Color color;
  DataTableHeaderTitles(this.title, this.color);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
          child: Center(
              child: Container(
                child: Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: setResponsiveFontSize(16),
                      color: color),
                ),
              ))),
    );
  }
}
*/
