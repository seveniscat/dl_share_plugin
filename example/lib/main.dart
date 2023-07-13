import 'dart:async';

import 'package:dl_share_plugin/enums.dart';
import 'package:dl_share_plugin/share_api.pigeon.dart';
import 'package:dl_share_plugin/share_api.pigeon.dart' as pigoneShare;
import 'package:dl_share_plugin/share_flutter_api_impl.dart';
import 'package:dl_share_plugin/unify_share.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_example/permission_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ShareFlutterApiImpl {
  String _platformVersion = 'Unknown';

  pigoneShare.ShareHostApi? hostApi;

  @override
  void shareCallBack(ShareEnumContainer enumContainer, String message) {
    if (enumContainer.shareStatus == ShareStatus.SUCCESS.value) {
      print(">>>>>>在平台:  ${enumContainer.sharePlatform} 上分享成功");
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1000), () {
      initPlatformState();
      UnifyShare.init(wxAppId: "", androidPackageName: "");
/*      pigoneShare.ShareFlutterApi.setup(this);
      hostApi = pigoneShare.ShareHostApi();*/
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  void clickNetImage() async {
/*    var picker = ImagePicker();
    var future = await picker.pickImage(source: ImageSource.camera);*/
    String tempDir = await PathProviderAndroid().getExternalStoragePath() ?? '';
    ShareBody shareBody = ShareBody(
      shareType: ShareType.IMG_LOCAL.value,
      mLocalPath: "$tempDir/2222.png",
    );
    UnifyShare.instance
        ?.platform(SharePlatform.DD)
        ?.shareType(ShareType.IMG_URL)
        ?.content(shareBody)
        ?.startShare(shareCallback: (platfrom, shareStatus) {});
  }

  // void clickSaveImg() async {
  //   Completer<Uint8List> completer = Completer();
  //   RenderRepaintBoundary render = _globalWaterKey.currentContext!
  //       .findRenderObject() as RenderRepaintBoundary;
  //   ui.Image image = await render.toImage(pixelRatio: 1.0);
  //   ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  //   completer.complete(byteData?.buffer.asUint8List());
  //   String tempDir;
  //   tempDir = await PathProviderAndroid().getExternalStoragePath() ?? '';
  //   var file = File('$tempDir/image_${DateTime.now().microsecond}.png');
  //   Uint8List imgbytes = await completer.future;
  //   file.writeAsBytes(imgbytes);
  //   print("得到的图片地址是： " + file.path);
  // }

  void clickShareImage() async {
/*    var picker = ImagePicker();
    var future = await picker.pickImage(source: ImageSource.camera);*/
    String tempDir = await PathProviderAndroid().getExternalStoragePath() ?? '';
    print("tempDir:   ${tempDir}");
    ShareBody shareBody = ShareBody(
      shareType: ShareType.IMG_LOCAL.value,
      mLocalPath: "$tempDir/image_597.png",
    );
    UnifyShare.instance
        ?.platform(SharePlatform.DD)
        ?.shareType(ShareType.IMG_LOCAL)
        ?.content(shareBody)
        ?.startShare(shareCallback: (platfrom, shareStatus) {
      print("分享拿到回调了 ");
    });
  }

  ///微信注册
  void register() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            InkWell(
              onTap: () {
                DlPermissionUtil.checkPermission([Permission.storage],
                    onSuccess: () {}, onFailed: () {});
              },
              child: Container(
                color: Colors.green,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("授权"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.green,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("注册"),
              ),
            ),
            InkWell(
              onTap: () {
                UnifyShare.instance
                    ?.platform(SharePlatform.WECHAT)
                    ?.checkPlatformInstall();
                // hostApi?.isDingTalkInstalled();
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.green,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("检查安装"),
              ),
            ),
            InkWell(
              onTap: () {
                // clickSaveImg();
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.green,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("保存图片"),
              ),
            ),
            /*          InkWell(
              onTap: () {
                clickNetImage();
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.green,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("钉钉分享网络图片"),
              ),
            ),*/
            InkWell(
              onTap: () {
                clickShareImage();
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.green,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("钉钉分享本地图片"),
              ),
            ),
            InkWell(
              onTap: () {
                wxShareImage();
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.green,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("微信分享图片"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.green,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("QQ分享图片"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.green,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("测试链接"),
              ),
            ),
            // images()
          ],
        ),
      ),
    );
  }

  void wxShareImage() async {
    // String tempDir = await PathProviderAndroid().getExternalStoragePath() ?? '';
    // print("tempDir:   ${tempDir}");
    ShareBody shareBody = ShareBody(
      shareType: ShareType.IMG_LOCAL.value,
      mLocalPath: "tempDir/image_597.png",
    );

    UnifyShare.instance
        ?.platform(SharePlatform.WECHAT)
        ?.shareType(ShareType.IMG_LOCAL)
        ?.content(shareBody)
        ?.startShare(shareCallback: (platfrom, shareStatus) {
      print("分享拿到回调了 ");
    });
  }

  @override
  void isAppInstallCallBack(bool isInstall) {
    if (isInstall) {
      print("!!!得到的回调是:  ${isInstall}");
    }
  }
}
