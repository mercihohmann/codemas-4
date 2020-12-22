import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(SantaMaker());
}

class SantaMaker extends StatefulWidget {
  @override
  _SantaMakerState createState() => _SantaMakerState();
}

class _SantaMakerState extends State<SantaMaker> {
  var bodies = [
    Image.asset('assets/body_beach_left.png'),
    Image.asset('assets/body_beach_right.png'),
    Image.asset('assets/body_gift_left.png'),
    Image.asset('assets/body_gift_right.png'),
    Image.asset('assets/body_normal_left.png'),
    Image.asset('assets/body_normal_right.png'),
    Image.asset('assets/body_normal_up.png'),
  ];
  var heads = [
    Image.asset('assets/head_normal.png'),
    Image.asset('assets/head_starryeyes.png'),
    Image.asset('assets/head_sunglasses.png'),
  ];

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Screenshot(
        controller: screenshotController,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                CarouselSlider(
                    items: bodies,
                    options: CarouselOptions(
                      height: 400,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.2,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 270.0),
                  child: CarouselSlider(
                      items: heads,
                      options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.2,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      )),
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: FloatingActionButton(
                    onPressed: () async {
                      Directory tempDir = await getTemporaryDirectory();
                      String tempPath = tempDir.path;

                      String fileName = DateTime.now().toIso8601String();
                      var path = '/sdcard/DCIM/$fileName.png';

                      screenshotController
                          .capture(path: path)
                          .then((File image) async {
                        final result = await ImageGallerySaver.saveImage(image
                            .readAsBytesSync()); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
                        print("File Saved to Gallery");
                      }).catchError((onError) {
                        print(onError.toString());
                      });
                    },
                    backgroundColor: Color.fromRGBO(225, 50, 40, 1),
                    child: Icon(Icons.camera_alt),
                  ),
                ), // This trailing comma makes auto-formatting nicer for build methods.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
