import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian/src/models/asset.dart';
import 'package:tractian/src/models/location.dart';
import 'package:tractian/src/pages/asset/tree_state.dart';

class TreeAssetNode extends StatefulWidget {
  final Location? location;
  final Asset? asset;
  const TreeAssetNode({super.key, this.location, this.asset})
      : assert(
          location != null || asset != null,
          'You must provide either a location or an asset',
        );

  @override
  State<TreeAssetNode> createState() => _TreeAssetNodeState();
}

class _TreeAssetNodeState extends State<TreeAssetNode> {
  final TreeState state = Get.find<TreeState>();
  bool get isExpanded =>
      state.isNodeExpanded(widget.location?.id ?? widget.asset!.id);

  bool get _isLeaf {
    if (widget.location != null) {
      return widget.location!.subLocations.isEmpty &&
          widget.location!.assets.isEmpty;
    }

    return widget.asset!.subAssets.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var icon = _isLeaf
        ? null
        : isExpanded
            ? Icons.expand_more
            : Icons.chevron_right;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: _isLeaf
                ? null
                : () => setState(() => state.toggleNodeExpanded(
                    widget.location?.id ?? widget.asset!.id)),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                height: 40,
                child: Row(children: [
                  if (icon != null) Icon(icon),
                  const SizedBox(width: 4),
                  Row(
                    children: [
                      widget.location != null
                          ? Image.asset('assets/icons/location.png')
                          : Image.asset(widget.asset!.sensorId != ""
                              ? 'assets/icons/component.png'
                              : 'assets/icons/asset.png'),
                      const SizedBox(width: 8),
                      Text(widget.location?.name ?? widget.asset!.name),
                      if (widget.asset != null &&
                          widget.asset!.sensorType != "")
                        Row(
                          children: [
                            const SizedBox(width: 4),
                            Icon(
                              widget.asset!.sensorType == "energy"
                                  ? Icons.bolt
                                  : widget.asset!.sensorType == "vibration"
                                      ? Icons.vibration
                                      : null,
                              color: Colors.green,
                              size: 20,
                            ),
                            if (widget.asset!.status == "alert")
                              const Row(
                                children: [
                                  SizedBox(width: 4),
                                  Icon(Icons.circle,
                                      color: Colors.red, size: 12),
                                ],
                              )
                          ],
                        )
                    ],
                  )
                ]),
              ),
            ),
          ),
        ),
        Visibility(
            visible: isExpanded && !_isLeaf,
            child: Padding(
              padding: EdgeInsets.only(left: widget.location != null ? 30 : 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.asset != null
                    ? widget.asset!.subAssets
                        .map((subAsset) => TreeAssetNode(asset: subAsset))
                        .toList()
                    : [
                        ...widget.location!.subLocations.map((subLocation) =>
                            TreeAssetNode(location: subLocation)),
                        ...widget.location!.assets
                            .map((asset) => TreeAssetNode(asset: asset)),
                      ],
              ),
            ))
      ],
    );
  }
}
