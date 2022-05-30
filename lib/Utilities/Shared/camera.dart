import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Presentation/guard/home_screen/g_home_screen.dart';
import '../../ViewModel/guard/visitorProv.dart';
import 'dialogs/bill_dialog.dart';

class CameraPicker extends StatefulWidget {
  final CameraDescription camera;
  final String dropdownValue;
  final String instruction;
  final String type;
  final int membershipId;

  const CameraPicker({
    Key key,
    this.camera,
    this.dropdownValue,
    this.instruction, this.type, this.membershipId,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<CameraPicker>
    with WidgetsBindingObserver {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  List<File> images = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  Future<File> testCompressAndGetFile({File file, String targetPath}) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 30,
    );

    return result;
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
        throw '';
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return Center(
                    child:

                        CameraPreview(
                  _controller,
                ));
              } else {
                // Otherwise, display a loading indicator.
                return Center(
                    child: Platform.isIOS
                        ? const CupertinoActivityIndicator()
                        : const CircularProgressIndicator());
              }
            },
          ),
          Positioned(
              bottom: 16.h,
              right: 0.w,
              left: 0.w,
              child: Container(
                height: 80.h,
                width: 80.w,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green),
                child: InkWell(onTap: ()async{
                  // Take the Picture in a try / catch block. If anything goes wrong,
                  // catch the error.
                  try {
                    // Ensure that the camera is initialized.
                    await _initializeControllerFuture;

                    // Construct the path where the image should be saved using the
                    // pattern package.

                    final path = join(
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now().toString().split(":")[2]}.jpg',
                    );

                    await _controller
                        .takePicture()
                        .then((value) => value.saveTo(path));

                    // If the picture was taken, display it on a new screen.
                    File img = File(path);

                    print(img.lengthSync());

                    String newPath = join(
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now().toString().split(":")[2]}.jpg',
                    );

                    File compressedFile = await testCompressAndGetFile(
                        file: img, targetPath: newPath);

                    // here we will crop

                    print('=====Compressed==========');
                    print(newPath);

                    if(widget.type=='membership'){
                      imageCache.clear();
                      if(widget.instruction=='carId'){

                      await  Provider.of<VisitorProv>(context, listen: false)
                            .updateMemberShipImages(
                            widget.membershipId,
                            compressedFile,null,null,'carId')
                            .then((value) {
                          if (value == 'Success') {

                            print('success ya man');
                            Navigator.pop(context);

                          }
                        });
                      }else  if(widget.instruction=='personId'){
                        await  Provider.of<VisitorProv>(context, listen: false)
                            .updateMemberShipImages(
                            widget.membershipId,null,
                            compressedFile,null,'personId')
                            .then((value) {
                          if (value == 'Success') {

                            Navigator.pop(context);

                          }
                        });
                      }
                    }else{
                      widget.instruction == 'carId'
                          ? Provider.of<VisitorProv>(context, listen: false)
                          .addRokhsa(compressedFile)
                          : Provider.of<VisitorProv>(context, listen: false)
                          .addIdCard(compressedFile);
                      Navigator.pop(context);
                    }



                    _controller.dispose();
                  } catch (e) {
                    print(e);
                  }
                }
                  ,child: const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              )),
          Positioned(
            left: 4.0.w,
            top: 4.0.h,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: 50,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
              left: 70.w,
              top: 430.h,
              bottom: 430.h,
              right: 70.w,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.green, width: 10.w)),
                ),
              ))
        ]),
      ),
    );
  }


}

