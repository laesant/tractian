import 'package:tractian/src/models/asset.dart';
import 'package:tractian/src/models/company.dart';
import 'package:tractian/src/models/location.dart';

abstract interface class CompanyRepository {
  Future<List<Company>> getCompanies();
  Future<List<Location>> getAllLocationsByCompany(String id);
  Future<List<Asset>> getAllAssetsByCompany(String id);
}
