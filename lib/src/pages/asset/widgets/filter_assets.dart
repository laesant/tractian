import 'package:flutter/material.dart';

class FilterAssets extends StatelessWidget {
  final String name;
  final String icon;
  final bool selected;
  final void Function() onTap;
  const FilterAssets(
      {super.key,
      required this.name,
      required this.icon,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: selected ? const Color(0xff2188FF) : null,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xffD8DFE6))),
        child: Row(
          children: [
            Image.asset(
              icon,
              color: selected ? Colors.white : const Color(0xff77818C),
            ),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: selected ? Colors.white : const Color(0xff77818C)),
            )
          ],
        ),
      ),
    );
  }
}
