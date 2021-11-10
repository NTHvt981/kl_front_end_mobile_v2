import 'package:cloud_firestore/cloud_firestore.dart';

const ID = 'Ma';
const TITLE = 'TieuDe';
const SUB_TITLE = 'NoiDung';
const IMAGE_URL = 'HinhAnh';
const URL = 'DuongDan';
const CREATED_TIME = 'ThoiGianTao';

class News {
  late String id;
  late String title;
  late String subTitle;
  late String imageUrl;
  late String url;
  late Timestamp createdTime;

  News();

  Map<String, dynamic> toMap() => {
    ID: id,
    TITLE: title,
    SUB_TITLE: subTitle,
    IMAGE_URL: imageUrl,
    URL: url,
    CREATED_TIME: createdTime
  };

  News.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],
        title = map[TITLE],
        subTitle = map[SUB_TITLE],
        imageUrl = map[IMAGE_URL],
        url = map[URL],
        createdTime = map[CREATED_TIME];
}