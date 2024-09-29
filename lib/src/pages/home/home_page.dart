import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian/src/pages/home/home_controller.dart';
import 'package:tractian/src/pages/home/widgets/company_tile.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/LOGO TRACTIAN.png'),
        centerTitle: true,
      ),
      body: Obx(() => Visibility(
            visible: !controller.isLoading.value,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.companies.length,
              itemBuilder: (context, index) {
                final company = controller.companies[index];
                return CompanyTile(company: company);
              },
            ),
          )),
    );
  }
}
