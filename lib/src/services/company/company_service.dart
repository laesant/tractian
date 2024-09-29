import 'package:tractian/src/models/asset.dart';
import 'package:tractian/src/models/company.dart';
import 'package:tractian/src/models/location.dart';

abstract interface class CompanyService {
  Future<List<Company>> getCompanies();
  Future<({List<Location> locations, List<Asset> unlinkedAssets})>
      getLocationsAndUnlinkedAssetsByCompany(String companyId);
}
