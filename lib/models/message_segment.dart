import 'package:cloud_firestore/cloud_firestore.dart';

const ID = 'Ma';
const MESSAGE_ID = 'MaTinNhan';
const CREATOR_ID = 'MaNguoiTao';
const CREATOR_NAME = 'TenNguoiTao';
const CONTENT = 'NoiDung';
const IMAGE_URL = 'HinhAnh';
const CREATED_BY_ADMIN = 'DoQuanTriTao';
const CREATED_TIME = 'ThoiGianTao';

class MessageSegment {
  late String id;
  late String messageId;
  late String creatorId;
  late String creatorName;
  late String content;
  late String imageUrl;
  late bool createdByAdmin;
  late Timestamp createdTime;

  MessageSegment() {
    createdTime = Timestamp.now();
    createdByAdmin = false;

    String timeSec = createdTime.toDate().millisecondsSinceEpoch.toString();
    id = 'CTTN' + '-' +
        timeSec.substring(0, 3) + '-' +
        timeSec.substring(3, 6) + '-' +
        timeSec.substring(6, 9) + '-' +
        timeSec.substring(9);
  }

  Map<String, dynamic> toMap() => {
    ID: id,
    MESSAGE_ID: messageId,
    CREATOR_ID: creatorId,
    CREATOR_NAME: creatorName,
    CONTENT: content,
    IMAGE_URL: imageUrl,
    CREATED_BY_ADMIN: createdByAdmin,
    CREATED_TIME: createdTime,
  };

  MessageSegment.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],
        messageId = map[MESSAGE_ID],
        creatorId = map[CREATOR_ID],
        creatorName = map[CREATOR_NAME],
        content = map[CONTENT],
        imageUrl = map[IMAGE_URL],
        createdByAdmin = map[CREATED_BY_ADMIN],
        createdTime = map[CREATED_TIME];
}