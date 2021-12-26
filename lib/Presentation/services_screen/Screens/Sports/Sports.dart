import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Routes/routesStrings.dart';
import 'package:clean_app/Data/Models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'SportsDetails.dart';

class SportsScreen extends StatefulWidget {
  @override
  _SportsScreenState createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: ListView.builder(
                    itemCount: sportsList.length,
                    itemBuilder: (context, index) {
                      return SportsActivitiesCard(
                        index: index,
                        image: sportsList[index].image,
                        title: sportsList[index].title,
                      );
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

List<SportsActivitiesCard> sportsList = [
  SportsActivitiesCard(
    image:
        "https://activenation.org.uk/wp-content/uploads/2015/11/Football-Activity-Slider-2-730x421.jpg",
    title: "كرة القدم",
    index: 0,
  ),
  SportsActivitiesCard(
    image:
        "https://26qwi858rq21jpf4913ehms1-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/Bball.jpg",
    title: "كرة السلة",
    index: 1,
  ),
  SportsActivitiesCard(
    image:
        "https://i.pinimg.com/originals/9d/d1/f7/9dd1f7d5da0f53f000bbb4375927925a.jpg",
    title: "كرة الطايرة",
    index: 2,
  ),
  SportsActivitiesCard(
    title: "تايكوندو",
    image:
        "https://www.martialtribes.com/wp-content/uploads/2016/05/150123328-1-1-960x480.png",
    index: 3,
  )
];

class SportsActivitiesCard extends StatelessWidget {
  final String image, title;
  final int index;
  SportsActivitiesCard({
    required this.index,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ActivitiesDetails(sportsList[index].image, index, 0),
                  ));
            },
            child: Container(
              decoration: BoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Hero(
                  tag: index,
                  child: Container(
                    child: Image(
                      width: double.infinity,
                      height: 160.h,
                      fit: BoxFit.cover,
                      image: NetworkImage(image),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(15)),
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.black)),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivitiesDetails(
                              sportsList[index].image, index, 2),
                        )),
                    child: Column(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.calendarAlt,
                          color: Colors.black,
                        ),
                        Text(
                          "الحجز",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 40,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivitiesDetails(
                              sportsList[index].image, index, 0),
                        )),
                    child: Column(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.info,
                          color: Colors.black,
                        ),
                        Text(
                          "الأكاديمية",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
