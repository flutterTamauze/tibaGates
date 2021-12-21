import 'package:animate_do/animate_do.dart';
import 'package:clean_app/Core/Shared/gridViewList/gridList.dart';
import 'package:clean_app/Presentation/services_screen/widgets/gridView/gridViewItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridViewDisplay extends StatelessWidget {
  const GridViewDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ZoomIn(
        child: Container(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 10.w,
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GridViewItemsWidg(
                  iconData: gridList[index].iconData,
                  title: gridList[index].title,
                  function: gridList[index].function,
                );
              },
              itemCount: gridList.length,
            ),
          ),
        ),
      ),
    ));
  }
}
