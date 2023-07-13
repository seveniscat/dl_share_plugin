import 'package:dl_share_plugin/share_api.pigeon.dart' as pigoneShare;

import 'enums.dart';
import 'share_api.pigeon.dart';
import 'share_flutter_api_impl.dart';

class UnifyShare with ShareFlutterApiImpl {
  SharePlatform? _mPlatform;
  ShareType? _shareType;
  ShareBody? _shareBody;

  pigoneShare.ShareHostApi? _hostApi;
  InstallCallBack? _mInstalledCallBack;
  UnifyShareCallback? _shareCallback;

  static UnifyShare? get instance => _getInstance();
  static UnifyShare? _instance;

  static UnifyShare? _getInstance() {
    _instance ??= UnifyShare._();
    return _instance;
  }

  UnifyShare._();

  void _initApi() {
    pigoneShare.ShareFlutterApi.setup(this);
    _hostApi = pigoneShare.ShareHostApi();
  }

  /**
   *初始化 到一个界面必须调用
   */
  static void init(
      {String? wxAppId,
      String? androidPackageName,
      String? universalLink,
      String? dtAppId}) {
    _instance = UnifyShare._();
    UnifyShare.instance?._initApi();

    if (wxAppId != null) {
      UnifyShare.instance?.registerWx(wxAppId, universalLink: universalLink);
    }
    if (androidPackageName != null) {
      UnifyShare.instance?.configAndroidPackAge(androidPackageName);
    }
    UnifyShare.instance?.registerDD(dtAppId);
  }

  void configAndroidPackAge(String? name) {
    if (name!.isNotEmpty) {
      _hostApi?.configAndroidPackage(name);
    }
  }

  void registerWx(String? wxAppId, {String? universalLink}) {
    if (wxAppId!.isNotEmpty) {
      _hostApi?.registerWx(wxAppId, universalLink);
    }
  }

  void registerDD(String? dtAppId) {
    if (dtAppId != null && dtAppId.isNotEmpty) {
      _hostApi?.registerDD(dtAppId);
    }
  }

  ///分享的平台
  UnifyShare? platform(SharePlatform sharePlatform) {
    _mPlatform = sharePlatform;
    return this;
  }

  @override
  void shareCallBack(ShareEnumContainer enumContainer, String message) {
    super.shareCallBack(enumContainer, message);

    _shareCallback?.call(_mPlatform, getStatus(enumContainer.shareStatus));
  }

  ///分享的类型
  UnifyShare? shareType(ShareType type) {
    _shareType = type;
    return this;
  }

  ///分享的内容
  UnifyShare? content(ShareBody body) {
    _shareBody = body;
    return this;
  }

  Future<bool?> checkPlatformInstall() async {
    if (_mPlatform == null) {
      return null;
    }
    switch (_mPlatform) {
      case SharePlatform.DD:
        return await _hostApi?.isDingTalkInstalled();
      case SharePlatform.WECHAT:
        return await _hostApi?.isWechatInstalled();
      default:
        return null;
    }
  }

  void startShare({UnifyShareCallback? shareCallback}) {
    if (_mPlatform == null) {
      return;
    }
    if (_shareType == null) {
      return;
    }
    if (_shareBody == null) {
      return;
    }
    _shareCallback = shareCallback;
    pigoneShare.ShareEnumContainer container = pigoneShare.ShareEnumContainer(
      shareType: _shareType?.value,
      sharePlatform: _mPlatform?.value,
    );
    _hostApi?.startShare(container, _shareBody!);
  }

  @override
  void isAppInstallCallBack(bool isInstall) {
    if (_mPlatform == null) return;
    _mInstalledCallBack?.call(_mPlatform, isInstall);
  }

  static ShareStatus? getStatus(int? status) {
    switch (status) {
      case 1:
        return ShareStatus.SUCCESS;
      case 2:
        return ShareStatus.FAIL;
      case 3:
        return ShareStatus.CANCAL;
    }
    return null;
  }
}

typedef InstallCallBack = Function(
    SharePlatform? sharePlatform, bool isInstalled);

typedef UnifyShareCallback = Function(
    SharePlatform? sharePlatform, ShareStatus? shareStatus);
