import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class MenuItem extends StatelessWidget {
  final String itemName;
  final IconData icon;
  final Function()? onTap;
  final bool isActive;

  const MenuItem({
    super.key,
    required this.itemName,
    required this.icon,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
        splashColor: HColors.primary.withOpacity(0.4),
        hoverColor: HColors.primary.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            color: isActive
                ? HColors.primary.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(HSizes.cardRadiusMd),
            border: isActive && isDesktop
                ? const Border(
                    left: BorderSide(
                      width: 4,
                      color: HColors.primary,
                    ),
                  )
                : null,
          ),
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? HSizes.lg : HSizes.md,
            horizontal: isDesktop ? HSizes.xl : HSizes.lg,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? HColors.primary : HColors.darkerGrey,
                size: isDesktop ? 24.dm : 22.dm,
              ),
              SizedBox(width: isDesktop ? HSizes.lg : HSizes.md),
              Flexible(
                child: Text(
                  itemName,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: isActive ? HColors.primary : HColors.darkerGrey,
                        fontSizeFactor: isDesktop ? 1.1 : 1.0,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isDesktop) const Spacer(),
              if (isDesktop && isActive)
                Icon(
                  Icons.chevron_right,
                  color: HColors.primary,
                  size: 20.dm,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
