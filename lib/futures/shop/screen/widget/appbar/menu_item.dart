// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class MenuItem extends StatelessWidget {
  final String itemName;
  final IconData icon;
  final Function()? onTap;
  const MenuItem({
    super.key,
    required this.itemName,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
      splashColor: HColors.primary.withOpacity(0.4),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(HSizes.cardRadiusMd)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    left: HSizes.lg,
                    bottom: HSizes.md,
                    right: HSizes.md,
                    top: HSizes.md),
                child: Icon(
                  icon,
                  color: HColors.primary,
                  size: 22,
                )),
            Flexible(
              child: Text(
                itemName,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: HColors.primary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
