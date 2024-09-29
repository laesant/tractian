import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:tractian/src/models/asset.dart';
import 'package:tractian/src/models/location.dart';
import 'package:tractian/src/pages/asset/tree_state.dart';
import 'package:tractian/src/services/company/company_service.dart';

import '../../core/helpers/debouncer.dart';
import 'widgets/tree_asset_node.dart';

class AssetController extends GetxController {
  late final String companyId;
  late final CompanyService _companyService;
  List<Location> allLocations = [];
  List<Asset> allUnlinkedAssets = [];

  final treeAssetNodes = <TreeAssetNode>[].obs;
  final filterEnergySensor = false.obs;
  final filterCritical = false.obs;
  String searchQuery = '';
  final isLoading = true.obs;
  // final loadingFilter = false.obs;
  final TreeState treeState = Get.find<TreeState>();
  final debouncer = Debouncer(milliseconds: 300);
  @override
  void onInit() {
    super.onInit();
    companyId = Get.arguments as String;
    _companyService = Get.find();
  }

  @override
  void onReady() {
    super.onReady();
    getLocationsAndUnlinkedAssets();
  }

  Future<void> getLocationsAndUnlinkedAssets() async {
    try {
      final data = await _companyService
          .getLocationsAndUnlinkedAssetsByCompany(companyId);
      allLocations = data.locations;
      allUnlinkedAssets = data.unlinkedAssets;
      treeAssetNodes.assignAll(allLocations
          .map((location) => TreeAssetNode(location: location))
          .toList());
      treeAssetNodes.addAll(allUnlinkedAssets
          .map((asset) => TreeAssetNode(asset: asset))
          .toList());
    } catch (e, s) {
      log(
        'Error trying to get locations and unlinked assets',
        error: e,
        stackTrace: s,
      );
      Get.snackbar(
        'Erro',
        'Não foi possível carregar os dados. Tente novamente mais tarde.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilterEnergySensor() {
    filterEnergySensor.value = !filterEnergySensor.value;
    filterTree();
  }

  void changeFilterCritical() {
    filterCritical.value = !filterCritical.value;
    filterTree();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    filterTree();
  }

  Future<void> filterTree() async {
    if (allLocations.length > 100 || allUnlinkedAssets.length > 100) {
      try {
        isLoading.value = true;
        //  loadingFilter.value = true;
        final data = serializeForIsolate(allLocations, allUnlinkedAssets);
        data['searchQuery'] = searchQuery;
        data['filterEnergySensor'] = filterEnergySensor.value;
        data['filterCritical'] = filterCritical.value;

        final result = await compute(filterTreeInIsolate, data);

        if (filterCritical.value ||
            filterEnergySensor.value ||
            searchQuery.isNotEmpty) {
          treeState.expandAll();
        } else {
          treeState.collapseAll();
        }
        isLoading.value = false;
        // loadingFilter.value = false;
        // treeAssetNodes.clear();
        // for (var node in result['allLocations']) {
        //   await Future.delayed(
        //     const Duration(milliseconds: 100),
        //   );
        //   treeAssetNodes.add(TreeAssetNode(location: node));
        // }
        treeAssetNodes.assignAll(result['allLocations']
            .map<TreeAssetNode>((location) => TreeAssetNode(location: location))
            .toList());
        treeAssetNodes.addAll(result['allUnlinkedAssets']
            .map<TreeAssetNode>((asset) => TreeAssetNode(asset: asset))
            .toList());
      } catch (e, s) {
        log('Error while filtering in isolate', error: e, stackTrace: s);
        Get.snackbar(
          'Erro',
          'Não foi possível aplicar os filtros.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      List<Location> filteredLocations =
          allLocations.map((loc) => loc.deepCopy()).toList();
      List<Asset> filteredUnlinkedAssets =
          allUnlinkedAssets.map((asset) => asset.deepCopy()).toList();

      if (filterEnergySensor.value) {
        filteredLocations = filterByEnergySensor(filteredLocations);
        filteredUnlinkedAssets = filteredUnlinkedAssets
            .where((asset) => containsEnergySensor(asset))
            .toList();
      }
      if (filterCritical.value) {
        filteredLocations = filterByCriticalStatus(filteredLocations);
        filteredUnlinkedAssets = filteredUnlinkedAssets
            .where((asset) => containsCriticalStatus(asset))
            .toList();
      }

      if (searchQuery.isNotEmpty) {
        filteredLocations = filterBySearchQuery(filteredLocations, searchQuery);
        filteredUnlinkedAssets =
            filterBySearchQueryAssets(filteredUnlinkedAssets, searchQuery);
      }
      if (filterCritical.value ||
          filterEnergySensor.value ||
          searchQuery.isNotEmpty) {
        treeState.expandAll();
      } else {
        treeState.collapseAll();
      }

      treeAssetNodes.assignAll(filteredLocations
          .map((location) => TreeAssetNode(location: location))
          .toList());
      treeAssetNodes.addAll(filteredUnlinkedAssets
          .map((asset) => TreeAssetNode(asset: asset))
          .toList());
    }
  }

  static Map<String, dynamic> serializeForIsolate(
      List<Location> locations, List<Asset> unlinkedAssets) {
    return {
      'allLocations': locations.map((loc) => loc.toJson()).toList(),
      'allUnlinkedAssets':
          unlinkedAssets.map((asset) => asset.toJson()).toList(),
    };
  }

  static List<Location> filterBySearchQuery(
      List<Location> locations, String query) {
    List<Location> matchedLocations = [];
    for (var location in locations) {
      bool locationMatches =
          location.name.toLowerCase().contains(query.toLowerCase());
      var matchedSubLocations =
          filterBySearchQuery(location.subLocations, query);

      var matchedAssets = filterBySearchQueryAssets(location.assets, query);
      if (locationMatches ||
          matchedSubLocations.isNotEmpty ||
          matchedAssets.isNotEmpty) {
        if (locationMatches) {
          location.subLocations = location.subLocations;
          location.assets = location.assets;
        } else {
          location.subLocations = matchedSubLocations;
          location.assets = matchedAssets;
        }
        matchedLocations.add(location);
      }
    }
    return matchedLocations;
  }

  static List<Asset> filterBySearchQueryAssets(
      List<Asset> assets, String query) {
    List<Asset> matchedAssets = [];
    for (var asset in assets) {
      bool assetMatches =
          asset.name.toLowerCase().contains(query.toLowerCase());
      var matchedSubAssets = filterBySearchQueryAssets(asset.subAssets, query);
      if (assetMatches || matchedSubAssets.isNotEmpty) {
        if (assetMatches) {
          asset.subAssets = asset.subAssets;
        } else {
          asset.subAssets = matchedSubAssets;
        }
        matchedAssets.add(asset);
      }
    }
    return matchedAssets;
  }

  static bool containsEnergySensor(Asset asset) {
    if (asset.sensorType == 'energy') return true;
    for (var subAsset in asset.subAssets) {
      if (containsEnergySensor(subAsset)) return true;
    }
    return false;
  }

  static bool containsCriticalStatus(Asset asset) {
    if (asset.status == 'alert') return true;
    for (var subAsset in asset.subAssets) {
      if (containsCriticalStatus(subAsset)) return true;
    }
    return false;
  }

  static List<Location> filterByEnergySensor(List<Location> locations) {
    return locations.where((location) {
      location.assets = location.assets
          .where((asset) => containsEnergySensor(asset))
          .toList();
      location.subLocations = filterByEnergySensor(location.subLocations);
      return location.assets.isNotEmpty || location.subLocations.isNotEmpty;
    }).toList();
  }

  static List<Location> filterByCriticalStatus(List<Location> locations) {
    return locations.where((location) {
      location.assets = location.assets
          .where((asset) => containsCriticalStatus(asset))
          .toList();
      location.subLocations = filterByCriticalStatus(location.subLocations);
      return location.assets.isNotEmpty || location.subLocations.isNotEmpty;
    }).toList();
  }
}

Map<String, dynamic> filterTreeInIsolate(Map<String, dynamic> data) {
  List<Location> allLocations = (data['allLocations'] as List)
      .map((loc) => Location.fromJson(loc))
      .toList();
  List<Asset> allUnlinkedAssets = (data['allUnlinkedAssets'] as List)
      .map((asset) => Asset.fromJson(asset))
      .toList();
  String searchQuery = data['searchQuery'];
  bool filterEnergySensor = data['filterEnergySensor'];
  bool filterCritical = data['filterCritical'];

  List<Location> filteredLocations =
      allLocations.map((loc) => loc.deepCopy()).toList();
  List<Asset> filteredUnlinkedAssets =
      allUnlinkedAssets.map((asset) => asset.deepCopy()).toList();

  if (filterEnergySensor) {
    filteredLocations = AssetController.filterByEnergySensor(filteredLocations);
    filteredUnlinkedAssets = filteredUnlinkedAssets
        .where((asset) => AssetController.containsEnergySensor(asset))
        .toList();
  }
  if (filterCritical) {
    filteredLocations =
        AssetController.filterByCriticalStatus(filteredLocations);
    filteredUnlinkedAssets = filteredUnlinkedAssets
        .where((asset) => AssetController.containsCriticalStatus(asset))
        .toList();
  }

  if (searchQuery.isNotEmpty) {
    filteredLocations =
        AssetController.filterBySearchQuery(filteredLocations, searchQuery);
    filteredUnlinkedAssets = AssetController.filterBySearchQueryAssets(
        filteredUnlinkedAssets, searchQuery);
  }

  return {
    'allLocations': filteredLocations,
    'allUnlinkedAssets': filteredUnlinkedAssets,
  };
}
