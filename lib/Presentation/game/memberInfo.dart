import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Presentation/game/game_home.dart';
import 'package:clean_app/Utilities/Shared/choice_chip_data.dart';
import 'package:clean_app/Utilities/Shared/choice_chips.dart';
import 'package:clean_app/Utilities/Shared/sharedWidgets.dart';
import 'package:clean_app/ViewModel/game/gameProv.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Fonts/fontsManager.dart';
import '../../Utilities/responsive.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MemberInformation extends StatefulWidget {
  const MemberInformation({Key key}) : super(key: key);

  @override
  _MemberState createState() => _MemberState();
}

class _MemberState extends State<MemberInformation> {
  int gameId;
  int id;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var defVisitorProv = Provider.of<VisitorProv>(context, listen: false);

    return WillPopScope(
      onWillPop: (){
        navigateTo(context, GameHome());
      },
      child: Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Consumer<VisitorProv>(builder: (context, message, child) {
                  return ZoomIn(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: (height * 0.15),
                          width: (width * 0.32),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: ColorManager.primary, width: 2.w),
                              image: DecorationImage(
                                  image:
                                      message.memberShipModel.memberProfilePath ==
                                              'empty'
                                          ? const AssetImage(
                                              'assets/images/avatar.png')
                                          : NetworkImage(
                                              message.memberShipModel
                                                      .memberProfilePath +
                                                  "?v=${Random().nextInt(1000)}",
                                            )),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          child: InkWell(
                            // onTap: getImage,
                            child: const CircleAvatar(
                              radius: 17,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          bottom: 25.h,
                          left: 180.w,
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(
                  height: 12.h,
                ),
                RichText(
                  text: TextSpan(
                    text: defVisitorProv.memberShipModel.memberName??'مشترك ',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: setResponsiveFontSize(30),
                        fontWeight: FontManager.bold),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' : اسم المشترك ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: setResponsiveFontSize(32),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: width,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Column(
                        children: [
                          defVisitorProv.memberShipModel.memberShipSports != null
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: Text(
                                          'قائمة الإشتراكات',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: setResponsiveFontSize(28),
                                              fontWeight: FontManager.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: SizedBox(
                                          height: defVisitorProv.memberShipModel
                                                      .memberShipSports.length >
                                                  3
                                              ? 350.h
                                              : 185.h,
                                          child: Directionality(
                                            textDirection: ui.TextDirection.rtl,
                                            child:
                                                buildChoiceChips()
                                            ,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  'لا توجد إشتراكات حالية لهذا العضو ولا يمكنه الدخول',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: setResponsiveFontSize(26),
                                      fontWeight: FontManager.bold),
                                ),
                          SizedBox(
                            height: 30.h,
                          ),
                          defVisitorProv.memberShipModel.memberShipSports != null?   Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RoundedButton(
                                  width: 220,
                                  height: 60,
                                  ontap: () async {
                                    navigateTo(context, GameHome());
                                  },
                                  title: 'عودة',
                                  buttonColor: Colors.red,
                                  titleColor: ColorManager.backGroundColor,
                                ),
                                RoundedButton(
                                  width: 220,
                                  height: 60,
                                  ontap: () async {
                                    if(gameId!=null){
                                      Provider.of<GameProv>(context, listen: false)
                                          .submitGame(id,gameId).then((value) {
                                            if(value=='Success'){
                                              showToast('تم التأكيد');
                                              navigateTo(context, GameHome());
                                            }
                                      });
                                    }
                                    else{
                                      showToast('برجاء إختيار النشاط أولاً');
                                    }

                                  },
                                  title: 'تأكيد',
                                  buttonColor: ColorManager.primary,
                                  titleColor: ColorManager.backGroundColor,
                                ),
                              ],
                            ),
                          ):  RoundedButton(
                            width: 220,
                            height: 60,
                            ontap: () async {
                              navigateTo(context, const GameHome());
                            },
                            title: 'عودة',
                            buttonColor: Colors.red,
                            titleColor: ColorManager.backGroundColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ))),
      ),
    );
  }

  Widget buildChoiceChips() => Wrap(
        runSpacing: spacing,
        spacing: spacing,
        children: Provider.of<VisitorProv>(context, listen: true)
            .memberShipModel
            .memberShipSports
            .map((choiceChip) => ChoiceChip(
                  label: Text(choiceChip.sportName),
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  onSelected: (isSelected) {
                    Provider.of<VisitorProv>(context, listen: false)
                        .resetAllChips();

                    setState(() {
                      choiceChip.isSelected = !choiceChip.isSelected;
                    });
                    gameId = choiceChip.gameId;
                    id=choiceChip.id;

                  },
                  selected: choiceChip.isSelected,
                  selectedColor: choiceChip.isSelected == true
                      ? Colors.green
                      : Colors.grey,
                  backgroundColor: Colors.grey,
                ))
            .toList(),
      );
  final double spacing = 8;
  List<ChoiceChipData> choiceChips;
}
