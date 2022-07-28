import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../Utilities/responsive.dart';
import '../../main.dart';
import '../manager/m_add_invitation.dart';
import '../../Utilities/connectivityStatus.dart';
import 'package:lottie/lottie.dart';
import '../../Data/Models/manager/invitation_model.dart';
import '../../Utilities/Shared/dialogs/loading_dialog.dart';
import '../../Utilities/Shared/invitation_item.dart';
import '../../ViewModel/manager/managerProv.dart';
import 'package:flutter/services.dart';
import '../../Utilities/Constants/constants.dart';
import '../../ViewModel/guard/authProv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AInvitationScreen extends StatefulWidget {
  const AInvitationScreen({Key key}) : super(key: key);

  @override
  _AInvitationScreenState createState() => _AInvitationScreenState();
}

class _AInvitationScreenState extends State<AInvitationScreen> {
  int invitationTypeId;
  var selectedInvitationType;
  var invitationsListener;
  final startDateController = TextEditingController();
  String token;
  String date;
  String role;
  List<Invitation> invitationList = [];

  // List<Invitation> tmpList = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      setState(() {
        if (date != null) {
          Provider.of<ManagerProv>(context, listen: false).getInvitations(
              Provider.of<AuthProv>(context, listen: false).userId, date);
        } else {
          invitationsListener = Provider.of<ManagerProv>(context, listen: false)
              .getInvitations(
                  Provider.of<AuthProv>(context, listen: false).userId);
        }
      });
    });
    _refreshController.refreshCompleted();
  }



  @override
  void initState() {
    super.initState();
    invitationsListener = Provider.of<ManagerProv>(context, listen: false)
        .getInvitations(Provider.of<AuthProv>(context, listen: false).userId);
  }

  @override
  Widget build(BuildContext context) {
    var managerProv = Provider.of<ManagerProv>(context, listen: false);
    var authProv = Provider.of<AuthProv>(context, listen: false);
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);

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
            floatingActionButton: managerProv.invitationObjects.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 22, bottom: 16),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ZoomIn(
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MAddInvitation(
                                          userRole: prefs.getString('role'),
                                          invitationType:
                                              selectedInvitationType ??
                                                  managerProv
                                                      .invitationObjects[0]
                                                      .invitationType,
                                          invitationTypeId: invitationTypeId ??
                                              managerProv
                                                  .invitationObjects[0].id,
                                        )));
                          },
                          backgroundColor: Colors.green,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            body: connectionStatus == ConnectivityStatus.Offline
                ? Center(
                    child: SizedBox(
                    height: 400.h,
                    width: 400.w,
                    child: Lottie.asset('assets/lotties/noInternet.json'),
                  ))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.always,
                                controller: startDateController,
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate:
                                              DateTime.parse('2010-01-01'),
                                          lastDate:
                                              DateTime.parse('2030-12-31'))
                                      .then((value) {
                                    if (value == null) {
                                      startDateController.text = '';
                                    } else {
                                      showLoaderDialog(context, 'Loading...');
                                      startDateController.text =
                                          DateUtil.formatDate(value).toString();

                                      print(
                                          'Date Time Value : ${value.toString().substring(0, 10)}\n');
                                      date = value.toString().substring(0, 10);
                                      managerProv
                                          .getInvitations(authProv.userId, date)
                                          .then((value) {
                                        if (value == 'Success') {
                                          Navigator.pop(context);
                                        }
                                      });
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                ),
                              ),
                              width: isTab(context) ? 80.w : 100.w,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 60.h,
                                width: isTab(context) ? 210.w : 215.w,
                                child: TextField(
                                  onChanged: (value) {
                                    /*        setState(() {
                                //    searchText = value;
                              });
                              print('filter');
                              //    filterServices(value);
                              print('value is $value');*/
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
                                      hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Almarai',
                                          fontSize: isTab(context)
                                              ? setResponsiveFontSize(24)
                                              : setResponsiveFontSize(22))),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 60.h,
                                width: isTab(context) ? 210.w : 215.w,
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
                                      hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Almarai',
                                          fontSize: isTab(context)
                                              ? setResponsiveFontSize(24)
                                              : setResponsiveFontSize(22))),
                                ),
                              ),
                            ),
                            Provider.of<ManagerProv>(context, listen: true)
                                    .invitationTypes
                                    .isNotEmpty
                                ? Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.green, width: 1.w)),
                                      width: isTab(context) ? 180.w : 250.w,
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
                                              // filterInvitations(value);
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
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: invitationsListener,
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


                              if(managerProv.invitationObjects.isNotEmpty){


                                invitationTypeId ??=
                                    managerProv.invitationObjects[0].id;

                                selectedInvitationType ??= managerProv
                                    .invitationObjects[0].invitationType;
                                invitationList = Provider.of<ManagerProv>(context,
                                    listen: true)
                                    .invitationsList;
                                print('type id $invitationTypeId');

                                return managerProv.invitationsList.isNotEmpty
                                    ? Expanded(
                                  child: SmartRefresher(
                                    onRefresh: _onRefresh,
                                    controller: _refreshController,
                                    enablePullDown: true,
                                    header: const WaterDropMaterialHeader(
                                      color: Colors.white,
                                      backgroundColor: Colors.green,
                                    ),
                                    child: ListView.builder(
                                      itemCount:
                                      //tmpList.isEmpty ?
                                      invitationList.length
                                      //  : tmpList.length
                                      ,
                                      scrollDirection: Axis.vertical,
                                      //  shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return InvitationItem(
                                          invitation:
                                          //  tmpList.isEmpty ?
                                          invitationList[index]
                                          // : tmpList[index]
                                          ,
                                          callback: () {
                                            showLoaderDialog(
                                                context, 'جارى الحذف');
                                            Provider.of<ManagerProv>(
                                                context,
                                                listen: false)
                                                .deleteInvitation(
                                                invitationList[index]
                                                    .id,
                                                Provider.of<AuthProv>(
                                                    context,
                                                    listen: false)
                                                    .userId)
                                                .then((value) {
                                              if (value == 'success') {
                                                Navigator.pop(context);
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                )
                                    : ZoomIn(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 400.h,
                                      ),
                                      Center(
                                          child: AutoSizeText(
                                            'لا توجد دعوات',
                                            style: TextStyle(
                                                fontSize:
                                                setResponsiveFontSize(46)),
                                          )),
                                    ],
                                  ),
                                );
                              }




                            }
                            return Container();
                          }),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
