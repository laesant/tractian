import 'package:flutter/material.dart';

import 'package:tractian/src/pages/asset/widgets/tree_asset_node.dart';

class TreeAssetView extends StatelessWidget {
  final List<TreeAssetNode> nodes;
  const TreeAssetView({
    super.key,
    required this.nodes,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return nodes[index];
      },
    );
  }
}
