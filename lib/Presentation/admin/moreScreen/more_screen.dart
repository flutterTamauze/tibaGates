import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Presentation/admin/moreScreen/pricesScreen.dart';
import 'package:clean_app/Presentation/admin/moreScreen/weeklyHolidays.dart';
import 'package:clean_app/Utilities/Constants/constants.dart';
import 'package:clean_app/Utilities/Shared/exitDialog.dart';
import 'package:clean_app/Utilities/connectivityStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'publicHolidaysScreen.dart';


class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool isConfirmed;
  var userType;

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => ZoomIn(
        child: const exitDialog(),
      ),
    )) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: connectionStatus == ConnectivityStatus.Offline
              ? Center(
              child: SizedBox(
                height: 400.h,
                width: 400.w,
                child: Lottie.asset('assets/lotties/noInternet.json'),
              ))
              : Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    navigateTo(context, const PricesScreen());
                  },
                  child: const rowTile(
                    icon: Icons.monetization_on,
                    label: 'الأسعار',
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: Divider(
                    thickness: 1,
                    height: 2.h,
                    color: Colors.green,
                  ),
                ),


                InkWell(
                  onTap: () {
navigateTo(context,const WeeklyHolidaysScreen());
                  },
                  child: const rowTile(
                    icon: Icons.calendar_today,
                    label: 'العطلات الأسبوعية',
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: Divider(
                    thickness: 1,
                    height: 2.h,
                    color: Colors.green,
                  ),
                ),
                InkWell(
                  onTap: () {
                    navigateTo(context,const PublicHolidaysScreen());
                  },
                  child: const rowTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'العطلات الرسمية',
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: Divider(
                    thickness: 1,
                    height: 2.h,
                    color: Colors.green,
                  ),
                ),
                InkWell(
                  onTap: () async {

                    await showDialog(
                        context: context,
                        builder: (context) => ZoomIn(
                          child: const exitDialog(),
                        ));
                  },
                  child: const rowTile(
                    icon: Icons.logout,
                    label: 'تسجيل الخروج',
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: Divider(
                    thickness: 1,
                    height: 2.h,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class rowTile extends StatelessWidget {
  final String label;
  final IconData icon;

  const rowTile({Key key, @required this.label, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 16,bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,textAlign: TextAlign.end,
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: setResponsiveFontSize(30)),
          ),
          SizedBox(
            width: 80.w,
          ),
          Icon(
            icon,
            size: 33,
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
