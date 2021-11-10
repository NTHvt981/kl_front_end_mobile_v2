import 'package:do_an_ui/models/setting.dart';
import 'package:rxdart/rxdart.dart';

class SettingService {
  late BehaviorSubject<Setting?> itemBehavior;

  SettingService() {
    itemBehavior = BehaviorSubject.seeded(null);
  }

  Stream<Setting?> getStream() {
    return itemBehavior.stream;
  }

  Future<Setting> set(Setting val) async {
    itemBehavior.add(val);

    return val;
  }

  Future<void> clear() async {
    itemBehavior.add(null);
  }

  void dispose() {
    itemBehavior.close();
  }
}

final localSettingService = new SettingService();