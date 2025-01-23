import 'package:rider/responses/order_response.dart';
import 'package:rider/ui/buttons/custom_elevated_button.dart';
import 'package:rider/ui/common/app_colors.dart';
import 'package:rider/ui/common/ui_helpers.dart';
import 'package:rider/ui/dialogs/progress_indicator/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider/ui/views/my_orders/my_orders_view.dart';
import 'package:rider/ui/views/specific_order/widgets/submodifier_list.dart';
import 'package:stacked/stacked.dart';
import 'specific_order_viewmodel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SpecificOrderView extends StackedView<SpecificOrderViewModel> {
  // ignore: use_super_parameters
  const SpecificOrderView(
      {Key? key, required this.order, this.isRouteFromRide = false})
      : super(key: key);

  final OrderModel order;
  final bool isRouteFromRide;

  @override
  Widget builder(
      BuildContext context, SpecificOrderViewModel viewModel, Widget? child) {
    viewModel.log.wtf(order.deliveryAddressObj?.toJson());
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: kcWhiteColor,
          title: Text(
            "My Orders",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        backgroundColor: kcLightGreyColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
            child: Column(
              children: [
                _restaurantDetails(context, viewModel),
                12.verticalSpace,
                // _transactionDetail(context, viewModel),
                // 12.verticalSpace,
                _deliveryAddress(context, viewModel),
                12.verticalSpace,
                _orderSummary(context, viewModel),
                12.verticalSpace,
                _orderNote(context, viewModel),
                12.verticalSpace,
                _reviewSection(context, viewModel),
                12.verticalSpace,
                25.verticalSpace,
                _priceRowWidget(
                  context,
                  "Coupon Discount",
                  order.couponDiscountAmount ?? "",
                ),
                8.verticalSpace,
                _priceRowWidget(
                  context,
                  "Vat",
                  (order.vAT ?? "").toString(),
                ),
                8.verticalSpace,
                _priceRowWidget(
                  context,
                  "Service charges",
                  (order.serviceCharges ?? "").toString(),
                ),
                8.verticalSpace,
                _priceRowWidget(
                  context,
                  "Bag fee",
                  (order.bagFee ?? "").toString(),
                ),
                8.verticalSpace,
                _priceRowWidget(
                  context,
                  "Delivery Charges",
                  (order.deliveryCharge ?? 0).toString(),
                ),
                12.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 18.sp),
                    ),
                    Text(
                      "£ ${order.orderAmount}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                20.verticalSpace,
                if (isRouteFromRide)
                  CustomElevatedButton(
                    text: "On the way",
                    onPressed: () {
                      viewModel.navigateToOnWay(order);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pedal_bike_sharp,
                          color: kcWhitColor,
                          size: 16.sp,
                        ),
                        10.horizontalSpace,
                        Text(
                          "On the way",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: kcWhitColor),
                        )
                      ],
                    ),
                  ),
                20.verticalSpace,
                // CustomElevatedButton(text: 'FeedBack', onPressed: () {}),
                // 20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _priceRowWidget(BuildContext context, String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
        ),
        Text(
          "£ $price",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Container _reviewSection(
      BuildContext context, SpecificOrderViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
          color: kcWhitColor, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Review for Restaurant",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          5.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  (order.restReview?.reviewRemarks.toString()) ??
                      "Review not added",
                  maxLines: 2,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ),
              // SizedBox(
              //   height: 30.h,
              //   child: ListView.builder(
              //     // itemCount: order.review?.reviewStar ?? 0,
              //     itemCount: 4,
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (BuildContext context, int index) =>
              //         const Icon(Icons.star, color: Colors.yellow),
              //   ),
              // ),
              RatingBar.builder(
                itemSize: 20,
                initialRating: double.parse(
                    (order.restReview?.reviewStar ?? 0).toString()),
                // minRating: 0,
                direction: Axis.horizontal,
                tapOnlyMode: true,
                ignoreGestures: true,
                updateOnDrag: false,
                allowHalfRating: true,
                itemCount: 5,
                unratedColor: kcGreyColor,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  // print(rating);
                  // viewModel.rating = rating;
                  // viewModel.rebuildUi();
                },
              ),
            ],
          ),
          20.verticalSpace,
          Text(
            "Review for Ride",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          5.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  (order.riderReview?.reviewRemarks.toString()) ??
                      "Review not added",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12.sp),
                ),
              ),
              RatingBar.builder(
                itemSize: 20,
                initialRating: double.parse(
                    (order.riderReview?.reviewStar ?? 0).toString()),
                // minRating: 0,
                direction: Axis.horizontal,
                tapOnlyMode: true,
                ignoreGestures: true,
                updateOnDrag: false,
                allowHalfRating: true,
                itemCount: 5,
                unratedColor: kcGreyColor,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _orderNote(BuildContext context, SpecificOrderViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Order Note",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        12.verticalSpace,
        Text(
          // "Bhai mayo zayda daal dena. Ek pepsi free bejh dena.",
          order.orderNote ?? "No Note Yet",
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
        ),
      ]),
    );
  }

  Container _orderSummary(
      BuildContext context, SpecificOrderViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.orderDetail?.length ?? 0,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // "Chicken Broast with pepsi \nx1 (Half)",
                      order.orderDetail?[index].food?.name ?? "",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                          ),
                    ),
                    Text(
                      "£ ${order.orderDetail?[index].food?.totalPrice}  x  ${order.orderDetail?[index].quantity}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: kcBlackColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (order.orderDetail?[index].modifiers!.isNotEmpty ?? false)
                  showMoreButton(viewModel, index, context),
                viewModel.res?.body!.orders!.orderDetail![index].showMore ??
                        false
                    ? SubmodifiersList(
                        subModifers: viewModel
                            .getProductSubmod(order.orderDetail![index]),
                      )
                    : SizedBox(),
                if (order.orderDetail?[index].orderSubProducts.isNotEmpty ??
                    false) ...[
                  6.verticalSpace,
                  // Text(
                  //   "With Side items",
                  //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //         fontSize: 12.sp,
                  //       ),
                  // ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        order.orderDetail?[index].orderSubProducts.length ?? 0,
                    itemBuilder: (context, subIndex) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // "Chicken Broast with pepsi \nx1 (Half)",
                          "\t\t\t* ${order.orderDetail?[index].orderSubProducts[subIndex].sideItemName ?? ""}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 12.sp),
                        ),
                        Text(
                          "£ ${order.orderDetail?[index].orderSubProducts[subIndex].sideItemPrice} ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 12.sp, color: kcBlackColor),
                        ),
                      ],
                    ),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        6.verticalSpace,
                  ),
                ],
              ],
            ),
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) =>
                6.verticalSpace,
          ),

          // Text(
          //   "Order Summary",
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyMedium
          //       ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          // ),
        ],
      ),
    );
  }

  GestureDetector showMoreButton(
      SpecificOrderViewModel viewModel, int index, BuildContext context) {
    return GestureDetector(
        onTap: () {
          viewModel.toggleShowMore(
            index,
          );
        },
        child: Wrap(
          children: [
            Text(
              viewModel.res?.body!.orders!.orderDetail![index].showMore ?? false
                  ? "View less"
                  : " View more",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: kcPrimaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: kcPrimaryColor,
                  ),
            ),
            Icon(
              viewModel.res?.body!.orders!.orderDetail![index].showMore ?? false
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
              color: kcPrimaryColor,
              size: 20.sp,
            )
          ],
        ));
  }

  Container _deliveryAddress(
      BuildContext context, SpecificOrderViewModel viewModel) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Delivery Address",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        12.verticalSpace,
        Text(
          order.user?.name ?? "",
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
        ),
        8.verticalSpace,
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            viewModel.navigateToMap(
                order.deliveryAddressObj?.lat, order.deliveryAddressObj?.lang);
          },
          child: Text(
            order.deliveryAddressObj?.address ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: kcPrimaryColor,
                fontSize: 14.sp,
                decoration: TextDecoration.underline),
          ),
        ),
      ]),
    );
  }

  // Container _transactionDetail(
  //     BuildContext context, SpecificOrderViewModel viewModel) {
  //   return Container(
  //     width: screenWidth(context),
  //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
  //     decoration: BoxDecoration(
  //       color: kcWhitColor,
  //       borderRadius: BorderRadius.circular(12.r),
  //     ),
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       Text(
  //         "Transaction Detail",
  //         style: Theme.of(context)
  //             .textTheme
  //             .bodyMedium
  //             ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
  //       ),
  //       12.verticalSpace,
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             "Payment Method",
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .bodyMedium
  //                 ?.copyWith(fontSize: 13.sp),
  //           ),
  //           Text(
  //             (viewModel.res?.body?.orders?.paymentMethod ?? "other")
  //                 .toUpperCase(),
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .bodyMedium
  //                 ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //       8.verticalSpace,
  //       Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "Transaction Id",
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .bodyMedium
  //                 ?.copyWith(fontSize: 13.sp),
  //           ),
  //           Text(
  //             viewModel.res?.body?.orders?.transactionReference ?? "",
  //             maxLines: 2,
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .bodyMedium
  //                 ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //     ]),
  //   );
  // }

  Container _restaurantDetails(
      BuildContext context, SpecificOrderViewModel viewModel) {
    String? localTime = DateTimeHelper()
        .convertTimeToLocal(DateTime.parse(order.createdAt ?? ""));
    // const String originalDateTimeString = '2023-11-14T13:06:56.000000Z';
    // final DateFormat inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ");
    // final DateFormat outputFormat = DateFormat("MM-dd-yyyy, hh:mm a");
    // DateTime originalDateTime =
    //     inputFormat.parse(viewModel.res?.body?.orders?.createdAt ?? "");
    // String formattedDateTime = outputFormat.format(originalDateTime);
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: kcWhitColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Icon(Icons.add_business),
            12.horizontalSpace,
            Text(
              // "Yasir Broast",
              order.restaurant?.name ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                  ),
            ),
            // const Spacer(),
            // const Icon(Icons.schedule, size: 18, color: kcBlackColor),
            // 6.horizontalSpace,
            // Text(
            //   "Re-Order",
            //   style: Theme.of(context)
            //       .textTheme
            //       .bodyMedium
            //       ?.copyWith(fontSize: 14.sp, color: const Color(0xff9AC86E)),
            // ),
          ],
        ),
        12.verticalSpace,
        Text(
          // "Order ID: 12345678",
          "Order ID : ${order.id}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
              ),
        ),
        6.verticalSpace,
        Text(
          // "07-04-2022, 12:30 pm",
          "$localTime",
          // formattedDateTime,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 12.sp, color: kcBlackColor.withOpacity(0.7)),
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Status",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp, color: kcBlackColor.withOpacity(0.7)),
            ),
            Text(
              // "In Progress",
              // "${viewModel.res?.body?.orders?.orderStatus}",
              order.orderStatus == 'cancel_request'
                  ? "cancel request"
                  : "${order.orderStatus}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  color: order.orderStatus == "pending"
                      ? kcPrimaryColor
                      : order.orderStatus == "completed"
                          ? kGreenColor
                          : Colors.red),
            ),
          ],
        ),
      ]),
    );
  }

  @override
  SpecificOrderViewModel viewModelBuilder(BuildContext context) =>
      SpecificOrderViewModel(order);
}
