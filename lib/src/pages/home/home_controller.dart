import 'dart:developer';

import 'package:get/get.dart';
import 'package:tractian/src/models/company.dart';
import 'package:tractian/src/services/company/company_service.dart';

class HomeController extends GetxController {
  final CompanyService _companyService;
  HomeController({required CompanyService companyService})
      : _companyService = companyService;
  final companies = <Company>[].obs;
  final isLoading = true.obs;
  @override
  void onReady() {
    super.onReady();
    getCompanies();
  }

  Future<void> getCompanies() async {
    try {
      companies.value = await _companyService.getCompanies();
    } catch (e, s) {
      Get.snackbar(
        'Erro',
        'Não foi possível carregar os dados. Tente novamente mais tarde.',
        snackPosition: SnackPosition.BOTTOM,
      );
      log('Error trying to get companies', error: e, stackTrace: s);
    } finally {
      isLoading.value = false;
    }
  }
}
