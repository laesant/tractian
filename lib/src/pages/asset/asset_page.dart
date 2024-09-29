import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tractian/src/pages/asset/asset_controller.dart';
import 'package:tractian/src/pages/asset/widgets/filter_assets.dart';
import 'package:tractian/src/pages/asset/widgets/tree_asset_view.dart';

class AssetPage extends GetView<AssetController> {
  const AssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text(
          'Assets',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() => SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          controller.debouncer.run(
                            () {
                              controller.updateSearchQuery(value);
                            },
                          );
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xffEAEFF3),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xff8E98A3),
                          ),
                          hintText: 'Buscar Ativo ou Local',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff8E98A3),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Obx(() => FilterAssets(
                                name: 'Sensor de Energia',
                                icon: 'assets/icons/bolt_outlined.png',
                                selected: controller.filterEnergySensor.value,
                                onTap: controller.changeFilterEnergySensor,
                              )),
                          const SizedBox(width: 8),
                          Obx(() => FilterAssets(
                                name: 'Crítico',
                                icon: 'assets/icons/critical.png',
                                selected: controller.filterCritical.value,
                                onTap: controller.changeFilterCritical,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Visibility(
                    visible: !controller.isLoading.value,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: Visibility(
                      // visible: controller.locationsObs.isNotEmpty ||
                      //     controller.unlinkedAssetsObs.isNotEmpty,
                      visible: controller.treeAssetNodes.isNotEmpty,
                      replacement: const Center(
                        child: Text(
                          'Nenhum resultado encontrado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      child: TreeAssetView(
                        nodes: controller.treeAssetNodes.toList(),
                      ),
                      // child: SizedBox(
                      //   width: double.infinity,
                      //   child: TreeWidget(
                      //     locations: controller.locationsObs.toList(),
                      //     unlinkedAssets: controller.unlinkedAssetsObs.toList(),
                      //   ),
                      // ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
