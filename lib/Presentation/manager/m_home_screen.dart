import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Utilities/Shared/exitDialog.dart';
import 'package:clean_app/ViewModel/guard/authProv.dart';
import 'package:clean_app/ViewModel/manager/managerProv.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';
import '../entry_screen/entryScreen.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'm_add_invitation.dart';

class MHomeScreen extends StatefulWidget {
  const MHomeScreen({Key key}) : super(key: key);

  @override
  _MHomeScreenState createState() => _MHomeScreenState();
}

class _MHomeScreenState extends State<MHomeScreen> {
  int invitationTypeId;
  var selectedInvitationType;
  var typesListener;
  final startDateController = TextEditingController();
  String token;
  String role;

  @override
  void initState() {
    super.initState();
    typesListener =
        Provider.of<ManagerProv>(context, listen: false).getInvitationTypes();
    token = prefs.getString('token');
    role = prefs.getString('role');
    print(token);
    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      cachingData();
    });
  }

  void cachingData() async {
    Provider.of<AuthProv>(context, listen: false).token =
        prefs.getString('token');
    Provider.of<AuthProv>(context, listen: false).userRole =
        prefs.getString('role');

    Provider.of<AuthProv>(context, listen: false).userId =
        prefs.getString('guardId');
  }

  @override
  Widget build(BuildContext context) {

    var managerProv = Provider.of<ManagerProv>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        throw '';
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (context) => ZoomIn(
                            child: const exitDialog(),
                          ));


                        },
                        child: const RotatedBox(
                          quarterTurns: 2,
                          child: Icon(
                            Icons.exit_to_app,
                            size: 30,
                          ),
                        )),
                    const Text('Manager',style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            floatingActionButton:managerProv.invitationObjects!=null? ZoomIn(
              child: FloatingActionButton(
                onPressed: () {


                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MAddInvitation(
                              invitationType: selectedInvitationType??managerProv.invitationObjects[0].invitationType,invitationTypeId: invitationTypeId??managerProv.invitationObjects[0].id,
                            )));




                },
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ):Container(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: TextFormField(
                            controller: startDateController,
                            keyboardType: TextInputType.datetime,
                            autovalidate: true,
                            readOnly: true,
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.parse('2010-01-01'),
                                      lastDate: DateTime.parse('2030-12-31'))
                                  .then((value) {
                                if (value == null) {
                                  startDateController.text = '';
                                } else {
                                  startDateController.text =
                                      DateUtil.formatDate(value).toString();
                                  print(
                                      'Date Time Value : ${value.toString()}\n');
                                }
                              });
                            },

                            decoration: InputDecoration(
                              suffixIcon: const Center(
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.green,
                                ),
                              ),
                              hintText: '',
                              hintStyle: TextStyle(
                                  //    color: darkBlueColor,
                                  fontFamily: 'Open Sans',
                                  fontSize: setResponsiveFontSize(16),
                                  fontWeight: FontWeight.w600),
                              alignLabelWithHint: true,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                            ),
                          ),
                          width: 80.w,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            height: 60.h,
                            width: 210.w,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  //    searchText = value;
                                });
                                print('filter');
                                //    filterServices(value);
                                print('value is $value');
                              },
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.green,
                              style: const TextStyle(color: Colors.green),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                  hintText: 'اسم الضيف',
                                  focusColor: Colors.green,
                                  hoverColor: Colors.green,
                                  fillColor: Colors.green,
                                  icon: Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.green,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Almarai')),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            height: 60.h,
                            width: 210.w,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  //    searchText = value;
                                });
                                print('filter');
                                //    filterServices(value);
                                print('value is $value');
                              },
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.green,
                              style: const TextStyle(color: Colors.green),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                  hintText: 'رقم الدعوة',
                                  focusColor: Colors.green,
                                  hoverColor: Colors.green,
                                  fillColor: Colors.green,
                                  icon: Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.green,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Almarai')),
                            ),
                          ),
                        ),
                        FutureBuilder(
                            future: typesListener,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Platform.isIOS
                                      ? const CupertinoActivityIndicator()
                                      : const Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.green,
                                          ),
                                        ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                invitationTypeId ??=
                                    managerProv.invitationObjects[0].id;

                                selectedInvitationType ??=
                                    managerProv.invitationObjects[0].invitationType;

                                print('type id $invitationTypeId');
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.green, width: 1.w)),
                                  width: 180.w,
                                  height: 70.h,
                                  child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton(
                                      elevation: 2,
                                      isExpanded: true,
                                      items: managerProv.invitationTypes
                                          .map((String x) {
                                        return DropdownMenuItem<String>(
                                            value: x,
                                            child: Center(
                                              child: Text(
                                                x,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            20),
                                                    color: Colors.green,
                                                    fontFamily: 'Almarai'),
                                              ),
                                            ));
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          invitationTypeId = managerProv
                                              .invitationObjects[managerProv
                                                  .invitationTypes
                                                  .indexOf(value)]
                                              .id;
                                          selectedInvitationType = value;

                                          print(
                                              'selected invitation type is $selectedInvitationType');
                                          print(
                                              'selected invitation type id is $invitationTypeId');
                                        });
                                      },
                                      value: selectedInvitationType ??
                                          managerProv.invitationTypes[0],
                                    ),
                                  )),
                                );
                              }
                              return Container();
                            })
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: SizedBox(
                          // height: 200.h,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '3-2-2022  02:00 am',
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(22),
                                            fontWeight: FontManager.bold),
                                      ),
                                      Text(
                                        'G-14',
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(26),
                                            fontWeight: FontManager.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                          'assets/images/historicalbrief.png'),
                                      Text(
                                        'Ahmed Radwan',
                                        style: TextStyle(
                                            fontSize: setResponsiveFontSize(26),
                                            fontWeight: FontManager.bold),
                                      ),
                                    ],
                                  ),
                                  ExpandablePanel(
                                    expanded: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'دعوة لأسرة مكونة من خمسة أشخاص',
                                                style: TextStyle(
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            22),
                                                    fontWeight:
                                                        FontManager.bold),
                                              ),
                                              const Text(
                                                'الوصف',
                                                softWrap: true,
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 6.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '3-2-2022  02:00 am',
                                                style: TextStyle(
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            22),
                                                    fontWeight:
                                                        FontManager.bold),
                                              ),
                                              const Text('تاريخ الدخول',
                                                  softWrap: true,
                                                  textAlign: TextAlign.end),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 6.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '3-2-2022  06:00 am',
                                                style: TextStyle(
                                                    fontSize:
                                                        setResponsiveFontSize(
                                                            22),
                                                    fontWeight:
                                                        FontManager.bold),
                                              ),
                                              const Text(
                                                'تاريخ الخروج',
                                                softWrap: true,
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    collapsed: null,
                                    header: SizedBox(
                                      height: 1.h,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
