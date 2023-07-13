import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
      dartOut: 'lib/share_api.pigeon.dart',
      // swiftOut: 'ios/Classes/AppShare.swift',
      objcHeaderOut: 'ios/Classes/AppShare.h',
      objcSourceOut: 'ios/Classes/AppShare.m',
      javaOut: 'android/src/main/kotlin/com/example/share/AppShare.java',
      javaOptions: JavaOptions(package: 'com.example.share')),
)
// flutter pub run pigeon --input pigeons/share_api.dart
class ShareBody {
  String? mTitle;

  /// 内容
  String? mContent;

  /// 缩略图链接
  String? mThumbUrl;

  /// 网页分享的连接地址
  String? mUrl;

  int? shareType;

  String? mLocalPath;

  ShareBody(
      {this.mTitle,
      this.mContent,
      this.mThumbUrl,
      this.mUrl,
      this.mLocalPath,
      this.shareType});
}

class ShareEnumContainer {
  int? shareType; // "text";"img_local,img_url,url
  int? shareStatus; //"success","fail;
  int? sharePlatform; //qq,wechat,d
}

/// flutter调用 原生端的方法集
@HostApi()
abstract class ShareHostApi {
  ///注册DD
  bool registerDD(String appId);

  ///判断DD是否安装
  bool isDingTalkInstalled();

  ///注册微信
  bool registerWx(String appId, String? universalLink);

  //开始分享
  bool startShare(ShareEnumContainer enumContainer, ShareBody shareBody);

  ///微信是否安装
  bool isWechatInstalled();

  ///指定安卓端包名
  void configAndroidPackage(String packageName);

  ///注册QQ
  @async

  ///判断是否支持钉钉分享
  bool isDingTalkSupportOpenAPI();
}

/// 原生端调用flutter的方法集
@FlutterApi()
abstract class ShareFlutterApi {
  ///注册回调
  void registerCallBack(ShareEnumContainer enumContainer);

  //是否安装对应回调
  void isAppInstallCallBack(bool isInstall);

  ///分享回调
  void shareCallBack(ShareEnumContainer enumContainer, String message);
}
