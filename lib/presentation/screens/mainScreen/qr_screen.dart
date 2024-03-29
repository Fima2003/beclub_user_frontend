import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import '../../../constants/palette.dart';
import '../../../logic/user/user_bloc.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {

  GlobalKey globalKey = GlobalKey();

  ScreenshotController screenshotController = ScreenshotController();

  _shareQrCode() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        try {
          String fileName = DateTime.now().microsecondsSinceEpoch.toString();
          final imagePath = await File('$directory/$fileName.png').create();
          if (imagePath != null) {
            await imagePath.writeAsBytes(image);
            Share.shareFiles(
                [imagePath.path],
                text: "Hey! You can use this code to help me get closer to getting free coffee, and maybe this coffee will be yours)");
          }
        } catch (error) {}
      }
    }).catchError((onError) {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return Screenshot(
                controller: screenshotController,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: QrImage(
                    padding: const EdgeInsets.all(20),
                    gapless: true,
                    data: '{nick: ${state.nick}}',
                    backgroundColor: const Color(0xffefefef),
                    embeddedImage: const AssetImage('assets/CluvsLogoInverse.jpg'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size.square(size.width/5),
                    ),
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: k1
                    ),
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.circle,
                      color: k1
                    ),
                    version: QrVersions.auto,
                  ),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "Share this bar-code to get points. It’s okay, if it is your first time at this place. Just scan, everything will be handled by us",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kGrey,
                fontSize: 15
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(size.width, 50),
                  side: const BorderSide(color: kBlack, width: 2),
                  backgroundColor: Colors.transparent
                ),
                onPressed: () async {
                  await _shareQrCode();
                },
                child: const Text(
                  "Share",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: kBlack
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
