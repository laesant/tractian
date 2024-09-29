import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tractian/src/models/company.dart';
import 'package:tractian/src/routes/route_names.dart';

class CompanyTile extends StatelessWidget {
  final Company company;
  const CompanyTile({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: InkWell(
        onTap: () {
          Get.toNamed(RouteNames.asset, arguments: company.id);
        },
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: const Color(0xff2188FF),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/Vector.png',
              ),
              const SizedBox(width: 16),
              Text(
                company.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
