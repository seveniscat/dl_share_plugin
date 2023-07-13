enum ShareType {
  TEXT(value: 1, desc: "text"),
  IMG_LOCAL(value: 2, desc: "img_local"),
  IMG_URL(value: 3, desc: "img_url"),
  URL(value: 4, desc: "url");

  final int value;
  final String desc;

  const ShareType({required this.value, required this.desc});
}

enum SharePlatform {
  WECHAT(value: 2, desc: "wx"),
  DD(value: 3, desc: "dd");

  final int value;
  final String desc;

  const SharePlatform({required this.value, required this.desc});
}

enum ShareStatus {
  SUCCESS(value: 1, desc: "success"),
  FAIL(value: 2, desc: "fail"),
  CANCAL(value: 3, desc: "cancel");

  final int value;
  final String desc;

  const ShareStatus({required this.value, required this.desc});
}
