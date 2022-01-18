import 'package:cloud_firestore/cloud_firestore.dart';

const ID = 'Ma';
const CREATOR_ID = 'MaNguoiTao';
const CREATOR_NAME = 'TenNguoiTao';
const TITLE = 'TieuDe';
const CREATED_BY_ADMIN = 'DoQuanTriTao';
const CREATED_TIME = 'ThoiGianTao';
const IS_OVER = 'KetThuc';

class Chat {
  late String id;
  String creatorId;
  String creatorName;
  String title;
  bool createdByAdmin = false;
  Timestamp createdTime = Timestamp.now();
  bool isOver = false;

  Chat({
    required this.creatorId,
    required this.creatorName,
    required this.title,
}) {
    String timeSec = createdTime.toDate().millisecondsSinceEpoch.toString();
    id = 'TIN-NHAN' + '-' +
        timeSec.substring(0, 3) + '-' +
        timeSec.substring(3, 6) + '-' +
        timeSec.substring(6, 9) + '-' +
        timeSec.substring(9);
  }

  Map<String, dynamic> toMap() => {
    ID: id,
    CREATOR_ID: creatorId,
    TITLE: title,
    CREATED_BY_ADMIN: createdByAdmin,
    CREATOR_NAME: creatorName,
    CREATED_TIME: createdTime,
    IS_OVER: isOver,
  };

  Chat.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],
        creatorId = map[CREATOR_ID],
        title = map[TITLE],
        createdByAdmin = map[CREATED_BY_ADMIN],
        creatorName = map[CREATOR_NAME],
        createdTime = map[CREATED_TIME],
        isOver = map[IS_OVER];
}