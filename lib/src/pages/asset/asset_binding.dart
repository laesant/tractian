import 'package:get/get.dart';
import 'package:tractian/src/pages/asset/asset_controller.dart';
import 'package:tractian/src/pages/asset/tree_state.dart';

class AssetBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetController>(() => AssetController());
    Get.put(TreeState());
  }
}
