import 'package:get/get.dart';

import '../../profile/controllers/profile_controller.dart';
import '../controllers/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
  }
}
