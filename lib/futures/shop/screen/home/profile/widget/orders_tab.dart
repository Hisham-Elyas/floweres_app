import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../../../app_coloer.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../controller/order/order_controller.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    final dark = HHelperFunctions.isDarkMode(context);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.orders.isEmpty) {
        return Center(
          child: Text(
            'لا توجد طلبات',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(HSizes.defaultSpace),
        itemCount: controller.orders.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: HSizes.spaceBtwItems),
        itemBuilder: (_, index) {
          final order = controller.orders[index];
          return Container(
            decoration: BoxDecoration(
              color: dark ? HColors.dark : HColors.light,
              borderRadius: BorderRadius.circular(HSizes.cardRadiusLg),
              border:
                  Border.all(color: dark ? HColors.darkerGrey : HColors.grey),
            ),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب #${order.id!.substring(0, 8)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: HSizes.sm),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.calendar_1,
                          color: HColors.primary,
                        ),
                        const SizedBox(width: HSizes.sm),
                        Text(
                          DateFormat('dd/MM/yyyy').format(order.createdAt!),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Iconsax.money,
                          color: HColors.success,
                        ),
                        const SizedBox(width: HSizes.sm),
                        Text(
                          '${order.totalAmount.toStringAsFixed(2)} ر.س',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: HColors.success),
                        ),
                      ],
                    ),
                    Chip(
                      label: Text(
                        _getOrderStatusText(order.orderStatus),
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: HHelperFunctions.getOrderStatusColor(
                                      order.orderStatus),
                                ),
                      ),
                      backgroundColor: HHelperFunctions.getOrderStatusColor(
                              order.orderStatus)
                          .withOpacity(0.1),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(HSizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Items
                        const Text(': المنتجات',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: HSizes.sm),
                        ...order.item.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: HSizes.sm),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(HSizes.sm),
                                    child: Image.network(
                                      item.productImageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Iconsax.box),
                                    ),
                                  ),
                                  const SizedBox(width: HSizes.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.productName),
                                        Text(
                                            '${item.price.toStringAsFixed(2)} ر.س × ${item.quantity}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),

                        const Divider(),

                        // Shipping Info
                        const Text(': معلومات الشحن',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: HSizes.sm),
                        if (order.shippingAddress != null) ...[
                          Text(
                            "${order.shippingAddress!.country} - ${order.shippingAddress!.city} - ${order.shippingAddress!.street}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                          const Divider(),
                          const Text(': شركة الشحن:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(order.shippingCompany),
                        ] else ...[
                          const Text('استلام من الفرع'),
                        ],

                        const Divider(),

                        // Payment Info
                        const Text('طريقة الدفع:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: HSizes.sm),
                        Text(order.paymentMethod),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  String _getOrderStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'قيد الانتظار';
      case OrderStatus.processing:
        return 'قيد التجهيز';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغي';
      case OrderStatus.readyForPickup:
        return 'جاهز للاستلام';
    }
  }
}
