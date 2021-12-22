import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:clean_app/Core/Colors/colorManager.dart';
import 'package:clean_app/Core/Constants/constants.dart';
import 'package:clean_app/Core/Shared/gridViewList/gridList.dart';
import 'package:clean_app/Presentation/services_screen/widgets/gridView/gridViewItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';

class GridViewDisplay extends StatelessWidget {
  const GridViewDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: gridList.length,
              itemBuilder: (BuildContext context, int index) => new Container(
                  child: Column(
                children: [
                  Container(
                    child: Card(
                      shadowColor: ColorManager.primary.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        gridList[index].function!(),
                                  ));
                            },
                            child: Lottie.asset(
                                gridList[index].iconData.toString(),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  BorderedText(
                      strokeWidth: 1.0,
                      child: Text(gridList[index].title.toString(),
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              decorationColor: Colors.red,
                              fontSize: setResponsiveFontSize(17))))
                ],
              )),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 3 : 4),
              padding: EdgeInsets.all(5),
              crossAxisSpacing: 20.0,
            )));
  }
}
