import 'dart:async';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Routes/routesStrings.dart';
import 'package:clean_app/Data/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivitiesDetails extends StatefulWidget {
  final String image;
  final pageIndex;
  final int index;
  ActivitiesDetails(this.image, this.index, this.pageIndex);
  @override
  _ActivitiesDetailsState createState() => _ActivitiesDetailsState();
}

List<String> dropList = ["مدينة نصر", "التجمع الخامس", "6 اكتوبر"];

List<String> ageRange = ["2000 - 2007", "2001 - 2005", "2003 - 2008"];
List<String> months = ["يناير", "فبراير"];
List<String> catsList = [
  "عن الأكادمية",
  "الفروع",
  "حجز اشتراك",
  "معرض الصور",
];
var selectedDrop = dropList.first;
var selectedMonth = months.first;
var selectedAge = ageRange.first;

class _ActivitiesDetailsState extends State<ActivitiesDetails> {
  var selectedCat = 0;

  toggleCat(int newind) {
    setState(() {
      selectedCat = newind;
    });
    _pageController.animateToPage(newind,
        duration: Duration(milliseconds: 400), curve: Curves.easeInExpo);
  }

  PageController _pageController = PageController();
  @override
  void initState() {
    selectedCat = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);
    super.initState();
  }

  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: AutoSizeText(
          "  أكاديمية النادى الأهلى لكرة القدم هى مدرسة لتعليم اسس كرة القدم وفق الانظمة الحديثة المتبعة فى العالم فى كرة القدم",
          textAlign: TextAlign.right,
          style: boldStyle,
        ),
      ),
      ListView(
        children: placeLocation,
      ),
      Container(
          child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    "اختر الفرع المناسب لك",
                    style: boldStyle.copyWith(color: ColorManager.primary),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: DropdownButton(
                      value: selectedDrop,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedDrop = value.toString();
                        });
                      },
                      items: dropList.map((String x) {
                        return DropdownMenuItem<String>(
                            value: x,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(3),
                                child: AutoSizeText(x,
                                    textAlign: TextAlign.right,
                                    style: boldStyle),
                              ),
                            ));
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AutoSizeText(
                    "اختر الشهر الناسب لك",
                    style: boldStyle.copyWith(color: ColorManager.primary),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: DropdownButton(
                      value: selectedMonth,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value.toString();
                        });
                      },
                      items: months.map((String x) {
                        return DropdownMenuItem<String>(
                            value: x,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(3),
                                child: AutoSizeText(x,
                                    textAlign: TextAlign.right,
                                    style: boldStyle),
                              ),
                            ));
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AutoSizeText(
                    "اختر الفئه العمرية ",
                    style: boldStyle.copyWith(color: ColorManager.primary),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: DropdownButton(
                      isExpanded: true,
                      value: selectedAge,
                      onChanged: (value) {
                        setState(() {
                          selectedAge = value.toString();
                        });
                      },
                      items: ageRange.map((String x) {
                        return DropdownMenuItem<String>(
                            value: x,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(3),
                                child: AutoSizeText(x,
                                    textAlign: TextAlign.right,
                                    style: boldStyle),
                              ),
                            ));
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: PaymentButton(),
                  ),
                ],
              ))),
      Container(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return Image(
            image: NetworkImage(imagesGallery[index]),
          );
        },
        itemCount: imagesGallery.length,
      )),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        elevation: 5,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutesPath.profile, arguments: user1);
          },
          child: Icon(
            Icons.person,
            color: ColorManager.backGroundColor,
            size: 30,
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.chevron_left,
                  size: 30,
                ),
              )),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(blurRadius: 8.0, offset: Offset(0.0, 0.15))
                    ],
                  ),
                  child: Hero(
                    tag: widget.index,
                    child: Image(
                      image: NetworkImage(widget.image),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  width: double.infinity,
                  height: 50.h,
                  child: ListView.builder(
                    controller: _controller,
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 30.w),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    toggleCat(index);
                                  },
                                  child: AutoSizeText(
                                    catsList[index],
                                    style: boldStyle,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 2,
                                  width: 100.w,
                                  color: selectedCat == index
                                      ? ColorManager.primary
                                      : Colors.grey,
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: catsList.length,
                  ),
                ),
                Expanded(
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    reverse: true,
                    children: pages,
                    controller: _pageController,
                    onPageChanged: (value) {
                      if (value == 1) {
                        Timer(
                          Duration(milliseconds: 100),
                          () => _controller
                              .jumpTo(_controller.position.minScrollExtent),
                        );
                      } else if (value == 0) {
                        Timer(
                          Duration(milliseconds: 100),
                          () => _controller
                              .jumpTo(_controller.position.minScrollExtent),
                        );
                      } else {
                        Timer(
                          Duration(milliseconds: 100),
                          () => _controller
                              .jumpTo(_controller.position.maxScrollExtent),
                        );
                      }
                      setState(() {
                        selectedCat = value;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 45.h,
      child: GFButton(
        onPressed: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => PaymentScreen(
          //         paymentButton: "اتمام الحجز",
          //       ),
          //     ));
        },
        text: "اتمام الحجز",
        size: GFSize.LARGE,
        shape: GFButtonShape.square,
        blockButton: true,
        color: ColorManager.primary,
        fullWidthButton: true,
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }
}

class PlaceLocation extends StatelessWidget {
  final String title;
  final Function function;
  const PlaceLocation({
    required this.function,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function()!;
      },
      child: Card(
        elevation: 5,
        child: Container(
          height: 50.h,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red[700],
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ],
              ),
              AutoSizeText(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: setResponsiveFontSize(16),
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<PlaceLocation> placeLocation = [
  PlaceLocation(
    title: "مدينة نصر",
    function: () {
      launch(
          'https://www.google.com/maps/place/An+Nadi+Al+Ahli,+Nasr+City,+Cairo+Governorate/data=!4m2!3m1!1s0x14583def118d7edf:0xa67726dc75420b62?sa=X&ved=2ahUKEwi6n6-0p4XvAhVxpHEKHcT4DWMQ8gEwAHoECAQQAQ');
    },
  ),
  PlaceLocation(
    title: "الشيخ زايد",
    function: () {
      launch(
          "https://www.google.com/search?tbs=lf:1,lf_ui:2&tbm=lcl&sxsrf=ALeKk01QinxhMVKGRltrRBeViyUQ4ymDrQ:1614265882201&q=%D9%86%D8%A7%D8%AF%D9%8A+%D8%A7%D9%84%D8%A3%D9%87%D9%84%D9%8A+%D8%A7%D9%84%D8%B4%D9%8A%D8%AE+%D8%B2%D8%A7%D9%8A%D8%AF&rflfq=1&num=10&ved=2ahUKEwiF4OyDqYXvAhXZShUIHWbXC9wQtgN6BAgEEAc#rlfi=hd:;si:;mv:[[30.085824,30.976490300000002],[30.047087700000002,30.972465000000003]];tbs:lrf:!1m4!1u3!2m2!3m1!1e1!1m4!1u2!2m2!2m1!1e1!2m1!1e2!2m1!1e3,lf:1,lf_ui:2");
    },
  )
];
List<String> imagesGallery = [
  "https://www.getafeinternational.com/images/the-academy-training.jpg",
  "https://static.wixstatic.com/media/ec0b94_8bbfad41dac24649b5b5a4b5334507a7~mv2.jpg/v1/fill/w_560,h_386,al_c,q_80,usm_0.66_1.00_0.01/IMG_9882_edited.webp",
  "https://soccerinteraction.com/wp-content/uploads/2018/02/ClinicWilliam3_SoccerAcademy.jpg"
];
