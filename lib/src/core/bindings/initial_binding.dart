import 'package:get/get.dart';
import 'package:tractian/src/repositories/company/company_repository.dart';
import 'package:tractian/src/repositories/company/company_repository_impl.dart';
import 'package:tractian/src/services/company/company_service.dart';
import 'package:tractian/src/services/company/company_service_impl.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CompanyRepository>(CompanyRepositoryImpl());
    Get.lazyPut<CompanyService>(
        () => CompanyServiceImpl(companyRepository: Get.find()));
  }
}
