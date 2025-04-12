import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../../../app_coloer.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../controller/order/order_controller.dart';
import '../../../../model/order_model.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    final dark = HHelperFunctions.isDarkMode(context);
    final isDesktop =
        MediaQuery.of(context).size.width >= HSizes.desktopScreenSize;

    return Column(
      children: [
        // Search and Filter Bar
        _buildTopControls(controller, isDesktop),

        // Orders List/Grid
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredOrders.isEmpty) {
              return _buildEmptyState(
                  dark, isDesktop, controller.filterStatus.value);
            }

            return _buildMobileListView(controller, dark);
          }),
        ),
      ],
    );
  }

  Widget _buildTopControls(OrdersController controller, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40.w : 16.w,
        vertical: isDesktop ? 16.h : 12.h,
      ),
      child: Column(
        children: [
          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'ابحث عن الطلبات...',
              prefixIcon: const Icon(Iconsax.search_normal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onChanged: (value) => controller.setSearchQuery(value),
          ),
          SizedBox(height: isDesktop ? 16.h : 12.h),

          // Filter and Sort Row
          Row(
            children: [
              // Filter Dropdown
              Expanded(
                child: DropdownButtonFormField<OrderStatus>(
                  value: controller.filterStatus.value,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('كل الحالات',
                          style:
                              TextStyle(fontSize: isDesktop ? 16.sp : 14.sp)),
                    ),
                    ...OrderStatus.values.map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            _getOrderStatusText(status),
                            style:
                                TextStyle(fontSize: isDesktop ? 16.sp : 14.sp),
                          ),
                        )),
                  ],
                  onChanged: (value) => controller.setFilterStatus(value),
                  decoration: const InputDecoration(
                    labelText: 'تصفية حسب',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: isDesktop ? 16.w : 12.w),

              // Sort Dropdown
              Expanded(
                child: DropdownButtonFormField<OrderSortOption>(
                  value: controller.sortBy.value,
                  items: [
                    DropdownMenuItem(
                      value: OrderSortOption.newest,
                      child: Text('الأحدث أولاً',
                          style:
                              TextStyle(fontSize: isDesktop ? 16.sp : 14.sp)),
                    ),
                    DropdownMenuItem(
                      value: OrderSortOption.oldest,
                      child: Text('الأقدم أولاً',
                          style:
                              TextStyle(fontSize: isDesktop ? 16.sp : 14.sp)),
                    ),
                    DropdownMenuItem(
                      value: OrderSortOption.highestAmount,
                      child: Text('الأعلى سعراً',
                          style:
                              TextStyle(fontSize: isDesktop ? 16.sp : 14.sp)),
                    ),
                    DropdownMenuItem(
                      value: OrderSortOption.lowestAmount,
                      child: Text('الأقل سعراً',
                          style:
                              TextStyle(fontSize: isDesktop ? 16.sp : 14.sp)),
                    ),
                  ],
                  onChanged: (value) => controller.setSortOption(value!),
                  decoration: const InputDecoration(
                    labelText: 'ترتيب حسب',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      bool dark, bool isDesktop, OrderStatus? filterStatus) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.box,
            size: isDesktop ? 80.dm : 50.dm,
            color: dark ? HColors.darkerGrey : HColors.grey,
          ),
          SizedBox(height: isDesktop ? 24.h : HSizes.spaceBtwItems),
          Text(
            'لا توجد طلبات',
            style: TextStyle(
              fontSize: isDesktop ? 22.sp : 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isDesktop ? 16.h : HSizes.sm),
          Text(
            filterStatus == null
                ? 'سيظهر هنا أي طلبات تقوم بها'
                : 'لا توجد طلبات بهذه الحالة',
            style: TextStyle(
              fontSize: isDesktop ? 16.sp : 14.sp,
              color: dark ? HColors.darkerGrey : HColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileListView(OrdersController controller, bool dark) {
    return ListView.separated(
      controller: controller.scrollController, // attach the scroll controller
      padding: const EdgeInsets.symmetric(
        horizontal: HSizes.defaultSpace,
        vertical: HSizes.defaultSpace,
      ),
      itemCount: controller.filteredOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: HSizes.spaceBtwItems),
      itemBuilder: (_, index) {
        final order = controller.filteredOrders[index];
        final key =
            controller.orderItemKeys.putIfAbsent(order.id!, () => GlobalKey());

        return Container(
          key: key,
          child: Obx(() => _buildOrderCard(order, dark, false, controller)),
        );
      },
    );
  }

  Widget _buildOrderCard(OrderModel order, bool dark, bool isDesktop,
      OrdersController controller) {
    final isSelected = controller.selectedOrders.contains(order.id!);

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? HColors.primary.withOpacity(0.1)
            : (dark ? HColors.dark : HColors.light),
        borderRadius: BorderRadius.circular(HSizes.cardRadiusLg),
        border: Border.all(
          color: isSelected
              ? HColors.primary
              : (dark ? HColors.darkerGrey : HColors.grey),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isDesktop
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: controller.selectedOrderId.value == order.id,
          onExpansionChanged: (expanded) {
            if (expanded) {
              controller.selectedOrderId.value = order.id!;
            } else if (controller.selectedOrderId.value == order.id) {
              controller.selectedOrderId.value = '';
            }
          },
          tilePadding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 24.w : 16.w,
            vertical: isDesktop ? 12.h : 8.h,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طلب #${order.id!.substring(0, 8)}',
                style: TextStyle(
                  fontSize: isDesktop ? 18.sp : 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? HColors.primary : null,
                ),
              ),
              SizedBox(height: isDesktop ? 12.h : HSizes.sm),
              Row(
                children: [
                  Icon(
                    Iconsax.calendar_1,
                    color: HColors.primary,
                    size: isDesktop ? 20.dm : 18.dm,
                  ),
                  SizedBox(width: isDesktop ? 12.w : HSizes.sm),
                  Text(
                    DateFormat('dd/MM/yyyy').format(order.createdAt!),
                    style: TextStyle(
                      fontSize: isDesktop ? 16.sp : 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: isDesktop ? 12.h : 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.money,
                      color: HColors.success,
                      size: isDesktop ? 20.dm : 18.dm,
                    ),
                    SizedBox(width: isDesktop ? 12.w : HSizes.sm),
                    Text(
                      '${order.totalAmount.toStringAsFixed(2)} ر.س',
                      style: TextStyle(
                        fontSize: isDesktop ? 16.sp : 14.sp,
                        color: HColors.success,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    _getOrderStatusText(order.orderStatus),
                    style: TextStyle(
                      fontSize: isDesktop ? 14.sp : 12.sp,
                      fontWeight: FontWeight.bold,
                      color: HHelperFunctions.getOrderStatusColor(
                          order.orderStatus),
                    ),
                  ),
                  backgroundColor:
                      HHelperFunctions.getOrderStatusColor(order.orderStatus)
                          .withOpacity(0.3),
                  side: BorderSide.none,
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(isDesktop ? 24.w : HSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Items
                  Text(
                    ': المنتجات',
                    style: TextStyle(
                      fontSize: isDesktop ? 16.sp : 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 16.h : HSizes.sm),
                  ...order.item.map((item) => Padding(
                        padding: EdgeInsets.only(
                            bottom: isDesktop ? 16.h : HSizes.sm),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(HSizes.sm),
                              child: Image.network(
                                item.productImageUrl,
                                width: isDesktop ? 70.w : 50.w,
                                height: isDesktop ? 70.h : 50.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Iconsax.box,
                                  size: isDesktop ? 30.dm : 24.dm,
                                ),
                              ),
                            ),
                            SizedBox(width: isDesktop ? 16.w : HSizes.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: TextStyle(
                                      fontSize: isDesktop ? 16.sp : 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: isDesktop ? 8.h : 4.h),
                                  Text(
                                    '${item.price.toStringAsFixed(2)} ر.س × ${item.quantity}',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14.sp : 12.sp,
                                      color: HColors.darkerGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),

                  Divider(
                    color: dark ? HColors.darkerGrey : HColors.grey,
                    thickness: 1,
                    height: isDesktop ? 32.h : 24.h,
                  ),

                  // Shipping Info
                  Text(
                    ': معلومات الشحن',
                    style: TextStyle(
                      fontSize: isDesktop ? 16.sp : 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 16.h : HSizes.sm),
                  if (order.shippingAddress != null) ...[
                    Text(
                      "${order.shippingAddress!.country} - ${order.shippingAddress!.city} - ${order.shippingAddress!.street}",
                      style: TextStyle(
                        fontSize: isDesktop ? 15.sp : 13.sp,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 16.h : HSizes.sm),
                    Divider(
                      color: dark ? HColors.darkerGrey : HColors.grey,
                      thickness: 1,
                      height: isDesktop ? 32.h : 24.h,
                    ),
                    Text(
                      ': شركة الشحن',
                      style: TextStyle(
                        fontSize: isDesktop ? 16.sp : 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 8.h : 4.h),
                    Text(
                      order.shippingCompany,
                      style: TextStyle(
                        fontSize: isDesktop ? 15.sp : 13.sp,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'استلام من الفرع',
                      style: TextStyle(
                        fontSize: isDesktop ? 15.sp : 13.sp,
                      ),
                    ),
                  ],

                  Divider(
                    color: dark ? HColors.darkerGrey : HColors.grey,
                    thickness: 1,
                    height: isDesktop ? 32.h : 24.h,
                  ),

                  // Payment Info
                  Text(
                    'طريقة الدفع:',
                    style: TextStyle(
                      fontSize: isDesktop ? 16.sp : 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 8.h : 4.h),
                  Text(
                    order.paymentMethod,
                    style: TextStyle(
                      fontSize: isDesktop ? 15.sp : 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
