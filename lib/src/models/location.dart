import 'dart:convert';

import 'package:tractian/src/models/asset.dart';

class Location {
  final String id;
  final String name;
  final String? parentId;
  List<Location> subLocations;
  List<Asset> assets;

  Location({
    required this.id,
    required this.name,
    required this.parentId,
    List<Location>? subLocations,
    List<Asset>? assets,
  })  : subLocations = subLocations ?? [],
        assets = assets ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
      'subLocations': subLocations.map((loc) => loc.toMap()).toList(),
      'assets': assets.map((asset) => asset.toMap()).toList(),
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      parentId: map['parentId'] ?? '',
      subLocations: map['subLocations'] != null
          ? List<Location>.from(
              map['subLocations']?.map((loc) => Location.fromMap(loc)))
          : [],
      assets: map['assets'] != null
          ? List<Asset>.from(
              map['assets']?.map((asset) => Asset.fromMap(asset)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source));

  Location deepCopy() {
    return Location(
      id: id,
      name: name,
      parentId: parentId,
      subLocations: subLocations.map((loc) => loc.deepCopy()).toList(),
      assets: assets.map((asset) => asset.deepCopy()).toList(),
    );
  }

  @override
  String toString() {
    return 'Location(id: $id, name: $name, parentId: $parentId, subLocations: $subLocations, assets: $assets)';
  }
}
