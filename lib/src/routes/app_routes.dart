import 'package:get/get.dart';
import 'package:tractian/src/pages/asset/asset_binding.dart';
import 'package:tractian/src/pages/asset/asset_page.dart';
import 'package:tractian/src/pages/home/home_binding.dart';
import 'package:tractian/src/pages/home/home_page.dart';
import 'package:tractian/src/routes/route_names.dart';

class AppRoutes {
  AppRoutes._();

  static final routes = <GetPage>[
    GetPage(
      name: RouteNames.home,
      binding: HomeBinding(),
      page: () => const HomePage(),
    ),
    GetPage(
      name: RouteNames.asset,
      binding: AssetBinding(),
      page: () => const AssetPage(),
    ),
  ];
}
