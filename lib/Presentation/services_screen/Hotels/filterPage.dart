import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/sharedWidgets.dart';
import 'package:clean_app/Data/Models/user.dart';
import 'package:clean_app/Presentation/home_screen/Screens/home.dart';
import 'package:clean_app/Presentation/services_screen/Hotels/hotel_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double _value = 20;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorManager.primary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelScreen(),
                        ));
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: setResponsiveFontSize(25),
                    color: Colors.white,
                  )),
              AutoSizeText(
                "التصفية",
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  AutoSizeText("السعر فى الليلة"),
                  Slider(
                    min: 0.0,
                    max: 2000.0,
                    value: _value,
                    inactiveColor: Colors.grey,
                    activeColor: ColorManager.primary,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                  AutoSizeText("${_value.toStringAsFixed(0)} جنية")
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      child: Wrap(
                    spacing: 3.0,
                    runSpacing: 3.0,
                    children: <Widget>[
                      filterChipWidget(chipName: 'السماح بالحيوانات الأليفة'),
                      filterChipWidget(chipName: "السماح بالتدخين"),
                      filterChipWidget(chipName: 'فطار'),
                      filterChipWidget(chipName: 'غداء'),
                      filterChipWidget(chipName: 'عشاء'),
                      filterChipWidget(chipName: 'واي فاي'),
                    ],
                  )),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              RoundedButton(
                buttonColor: ColorManager.primary,
                ontap: () {
                  Fluttertoast.showToast(
                      msg: "تم الحفظ بنجاح",
                      backgroundColor: Colors.green,
                      gravity: ToastGravity.CENTER);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelScreen(),
                      ));
                },
                title: "حفظ",
                titleColor: ColorManager.backGroundColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _titleContainer(String myTitle) {
  return AutoSizeText(
    myTitle,
    style: TextStyle(
        color: Colors.black,
        fontSize: setResponsiveFontSize(20),
        fontWeight: FontWeight.bold),
  );
}

class filterChipWidget extends StatefulWidget {
  final String chipName;

  filterChipWidget({required this.chipName});

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: AutoSizeText(widget.chipName),
      labelStyle: TextStyle(
          color: ColorManager.primary,
          fontSize: setResponsiveFontSize(16),
          fontWeight: FontWeight.bold),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: Colors.grey[300],
    );
  }
}

class FilterShipView extends StatelessWidget {
  const FilterShipView({Key? key, required this.chipName}) : super(key: key);
  final String chipName;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: AutoSizeText(chipName),
      labelStyle: TextStyle(
          color: ColorManager.primary,
          fontSize: setResponsiveFontSize(14),
          fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      selectedColor: Colors.grey[300],
      onSelected: (bool value) {
        print(value);
      },
    );
  }
}
