import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

///权限管理
class DlPermissionUtil {
  //相机权限永久拒绝提示
  static String get cameraPermanentlyDenied {
    if (Platform.isIOS) {
      return '前往"设置 > 数链科技"中打开相机权限';
    }
    return "在设置-应用-数链科技-权限中开启相机权限，以正常使用拍照功能";
  }

  //相册权限永久拒绝提示
  static String get photosPermanentlyDenied {
    if (Platform.isIOS) {
      return '你已关闭数链科技照片访问权限，建议允许访问「所有照片」';
    }
    return "在设置-应用-数链科技-权限中开启存储权限，以正常使用相册功能";
  }

  //相册权限
  static Permission get photos {
    return Platform.isIOS ? Permission.photos : Permission.storage;
  }

  ///检查权限
  static void checkPermission(List<Permission> permissionList,
      {String? toastMsg,
      VoidCallback? onSuccess,
      VoidCallback? onFailed}) async {
    bool hasPermission = true;

    for (var value in permissionList) {
      var status = await value.status;
      if (!status.isGranted) {
        hasPermission = false;
        break;
      }
    }
    if (hasPermission) {
      onSuccess?.call();
      return;
    }

    if (!hasPermission) {
      PermissionStatus permissionStatus =
          await requestPermissions(permissionList);
      OsPermission? osPermission =
          Platform.isIOS ? IOSPermission() : AndroidPermission();
      if (permissionStatus.isGranted) {
        onSuccess?.call();
      } else if (permissionStatus.isDenied) {
        //权限拒绝
        requestPermissions(permissionList);
      } else if (permissionStatus.isPermanentlyDenied) {
        //权限永久拒绝，且不在提示，需要进入设置界面
        osPermission.openSetting();
      } else if (permissionStatus.isRestricted) {
        osPermission.openSetting();
      } else if (permissionStatus.isLimited) {
        ///IOS单独处理
        osPermission.openSetting();
      }
    }
  }

  static Future<PermissionStatus> requestPermissions(
      List<Permission> permissionList) async {
    Map<Permission, PermissionStatus> statuses = await permissionList.request();
    PermissionStatus currentPermissionStatus = PermissionStatus.granted;
    statuses.forEach((key, value) {
      print('${key} - ${value}');
      if (!value.isGranted) {
        currentPermissionStatus = value;
        return;
      }
    });
    return currentPermissionStatus;
  }

  static Future<bool> check(
    Permission permission, {
    required String permanentlyDenied,
  }) async {
    return true;
  }
}

class OsPermission {
  void openSetting() {}
}

class AndroidPermission implements OsPermission {
  @override
  void openSetting() {
    // AppSettings.openAppSettings();
  }
}

class IOSPermission implements OsPermission {
  @override
  void openSetting() {
    // AppSettings.openAppSettings();
  }
}

typedef VoidCallback = Function();
