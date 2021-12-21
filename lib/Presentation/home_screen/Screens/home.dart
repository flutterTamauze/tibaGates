import 'package:card_swiper/card_swiper.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Routes/routesStrings.dart';
import 'package:clean_app/Core/Shared/bottomNavBar.dart';
import 'package:clean_app/Core/Shared/drawer/drawer.dart';
import 'package:clean_app/Data/Models/user.dart';
import 'package:clean_app/Presentation/home_screen/Widgets/news.dart';
import 'package:clean_app/Presentation/services_screen/Screens/services_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  final User user;
  HomePage(this.user);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.user.userName);
      },
      child: Scaffold(
        endDrawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          elevation: 5,
          leading: InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutesPath.profile,
                  arguments: widget.user);
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
              child: Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Icon(
                    Icons.menu,
                    color: ColorManager.backGroundColor,
                    size: 30,
                  ),
                );
              }),
            )
          ],
        ),
        bottomNavigationBar: AnimatedBottomNavBar(
          getCurrentIndex: (newIndex) {
            setState(() {
              currentIndex = newIndex;
            });
          },
        ),
        body: Column(
          children: [
            currentIndex == 1
                ? ServiceScreen()
                : currentIndex == 2
                    ? NewsDisplay()
                    : Expanded(
                        child: ListView(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                height: 200,
                                width: 200,
                                child: new Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return offersList[index];
                                  },
                                  itemCount: offersList.length,
                                  itemWidth: 320,
                                  autoplay: true,
                                  layout: SwiperLayout.STACK,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        return offersList[index];
                                      },
                                      itemCount: offersList.length,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

List<OffersCard> offersList = [
  OffersCard(
    address: [
      "التجمع الخامس ",
      " 6 أكتوبر التعليمي (الحي الأول امام جهاز المدينة)"
    ],
    phone: ["01112601115", "01011212211"],
    description:
        "كشف على الأسنان وتلميع وتنظيف الجير بخصم 73% في Dr. Ahmed Abu Zeid Dental Clinic! فقط بـ 149 جنيه بدلا من 550 جنيه",
    newsTitle: "عياده دكتور حمزة الجندي للأسنان",
    image:
        "https://s3-eu-west-1.amazonaws.com/forasna/uploads/logos/thumb_clogo_2020-07-28-12-04-48_NulrRVaXSdnLNtzPZQKAoAXX.jpg",
  ),
  OffersCard(
    address: ["مدينة نصر الحي السابع امام ابو رامي "],
    newsTitle: "الجلاء و السرايا سكان",
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkyhM7dwFwoPQBbBRWrw4HhuZ2E6YyvHkIlw&usqp=CAU",
    phone: ["01112601115"],
    description:
        "كشف على الأسنان وتلميع وتنظيف الجير بخصم 73% في Dr. Ahmed Abu Zeid Dental Clinic! فقط بـ 149 جنيه بدلا من 550 جنيه",
  ),
  OffersCard(
    phone: ["24595744", "01112405552", "24595711"],
    address: ["شبرا روض الفرج شارع فخر الدين"],
    newsTitle: "صيدليات العزبي",
    description:
        "خليك في البيت و صيدلية سيف هتجيلك لحد البيت لكل طلبات أسرتك من الدواء و مسحضرات التجميل. احصل على خصم 10% على أول طلباتك من صيدليات سيف اون لاين، اكتب برومو كود - First10. الدفع عند الاستلام. أقوى العروض و الخصومات.",
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTqdrB8yiwL36E-v91p_PEcl6KUyHKnMVprw&usqp=CAU",
  ),
];

class OffersCard extends StatelessWidget {
  final String newsTitle;
  final String image;
  final String description;
  final List<String> phone;
  final List<String> address;
  OffersCard({
    required this.phone,
    required this.address,
    required this.newsTitle,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5, top: 5, right: 5, left: 5),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: ColorManager.lightGrey,
        ),
        borderRadius: BorderRadius.circular(9),
        color: Colors.white,
      ),
      height: 100,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Text(
                      newsTitle,
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(17),
                          fontWeight: FontWeight.w800),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Text(
                    "22-3-2021",
                    style: TextStyle(
                        fontSize: setResponsiveFontSize(17),
                        color: Colors.grey,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(9), bottomRight: Radius.circular(9)),
            child: Image(
              image: NetworkImage(
                image,
              ),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
