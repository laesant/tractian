import 'package:tractian/src/models/asset.dart';
import 'package:tractian/src/models/company.dart';
import 'package:tractian/src/models/location.dart';
import 'package:tractian/src/repositories/company/company_repository.dart';

import './company_service.dart';

class CompanyServiceImpl implements CompanyService {
  final CompanyRepository _companyRepository;

  CompanyServiceImpl({required CompanyRepository companyRepository})
      : _companyRepository = companyRepository;
  @override
  Future<List<Company>> getCompanies() => _companyRepository.getCompanies();

  @override
  Future<({List<Location> locations, List<Asset> unlinkedAssets})>
      getLocationsAndUnlinkedAssetsByCompany(String companyId) async {
    final List<Location> locations =
        await _companyRepository.getAllLocationsByCompany(companyId);
    final List<Asset> assets =
        await _companyRepository.getAllAssetsByCompany(companyId);

    List<Asset> unlinkedAssets = assets
        .where((asset) => asset.locationId == "" && asset.parentId == "")
        .toList();

    _buildTree(locations, assets);

    return (locations: locations, unlinkedAssets: unlinkedAssets);
  }

  void _buildTree(List<Location> locations, List<Asset> assets) {
    Map<String, Location> locationMap = {
      for (var location in locations) location.id: location,
    };

    for (var location in locations) {
      if (location.parentId != "") {
        locationMap[location.parentId!]!.subLocations.add(location);
      }
    }

    locations.removeWhere((loc) => loc.parentId != "");

    Map<String, Asset> assetMap = {
      for (var asset in assets) asset.id: asset,
    };

    for (var asset in assets) {
      if (asset.locationId != "") {
        locationMap[asset.locationId!]!.assets.add(asset);
      } else if (asset.parentId != "") {
        assetMap[asset.parentId!]!.subAssets.add(asset);
      }
    }
  }
}
