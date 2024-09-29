import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tractian/src/core/bindings/initial_binding.dart';
import 'package:tractian/src/core/ui/ui_config.dart';
import 'package:tractian/src/routes/app_routes.dart';

class TractianApp extends StatelessWidget {
  const TractianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: UiConfig.title,
      debugShowCheckedModeBanner: false,
      theme: UiConfig.theme,
      initialBinding: InitialBinding(),
      getPages: AppRoutes.routes,
    );
  }
}
