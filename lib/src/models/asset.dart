import 'dart:convert';

class Asset {
  final String id;
  final String name;
  final String? parentId;
  final String? locationId;
  final String? sensorId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;
  List<Asset> subAssets;

  Asset({
    required this.id,
    required this.name,
    required this.parentId,
    required this.locationId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
    List<Asset>? subAssets,
  }) : subAssets = subAssets ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
      'locationId': locationId,
      'sensorId': sensorId,
      'sensorType': sensorType,
      'status': status,
      'gatewayId': gatewayId,
      'subAssets': subAssets.map((x) => x.toMap()).toList(),
    };
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        parentId: map['parentId'] ?? '',
        locationId: map['locationId'] ?? '',
        sensorId: map['sensorId'] ?? '',
        sensorType: map['sensorType'] ?? '',
        status: map['status'] ?? '',
        gatewayId: map['gatewayId'] ?? '',
        subAssets: map['subAssets'] != null
            ? List<Asset>.from(map['subAssets']?.map((x) => Asset.fromMap(x)))
            : []);
  }

  String toJson() => json.encode(toMap());

  factory Asset.fromJson(String source) => Asset.fromMap(json.decode(source));

  Asset deepCopy() {
    return Asset(
      id: id,
      name: name,
      parentId: parentId,
      locationId: locationId,
      sensorId: sensorId,
      sensorType: sensorType,
      status: status,
      gatewayId: gatewayId,
      subAssets: subAssets.map((asset) => asset.deepCopy()).toList(),
    );
  }

  @override
  String toString() {
    return 'Asset(id: $id, name: $name, parentId: $parentId, locationId: $locationId, sensorId: $sensorId, sensorType: $sensorType, status: $status, gatewayId: $gatewayId, subAssets: $subAssets)';
  }
}
