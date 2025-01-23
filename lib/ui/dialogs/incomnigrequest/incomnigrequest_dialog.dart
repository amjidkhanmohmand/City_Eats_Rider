import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider/app/app.locator.dart';
import 'package:rider/responses/order_response.dart';
import 'package:rider/ui/common/app_colors.dart';
import 'package:rider/ui/dialogs/progress_indicator/progress.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'incomnigrequest_dialog_model.dart';

const double _graphicSize = 60;
Timer? timerObj;

class IncomnigrequestDialog extends StackedView<IncomnigrequestDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const IncomnigrequestDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);
  @override
  Widget builder(BuildContext context, IncomnigrequestDialogModel viewModel,
      Widget? child) {
    OrderModel order = request.data as OrderModel;
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              completer(DialogResponse(confirmed: true));
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Incoming Request",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: kcBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                viewModel.navigateToOrderDetail();
                              },
                              child: Text(
                                "View Details",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        decoration: TextDecoration.underline,
                                        color: const Color(0xff235289)),
                              ),
                            ),
                          ],
                        ),
                        24.verticalSpace,
                        Text(
                          "Pickup",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        8.verticalSpace,
                        Text(
                          // "Macdonalds, Cape Town",
                          order.restaurant?.name ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        5.verticalSpace,
                        Text(
                          // "Street 123, G1 Johar Town Lahore City, Punjab",
                          order.restaurant?.address ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 12.sp),
                        ),
                        20.verticalSpace,
                        Text(
                          "Drop off",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        8.verticalSpace,
                        Text(
                          "${order.deliveryAddressObj?.address ?? ""}, ${order.deliveryAddressObj?.city ?? ""}, ${order.deliveryAddressObj?.zipCode ?? ""}",
                          // "Street 123, G1 Johar Town Lahore City, Punjab",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 12.sp),
                        ),
                        60.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estd. Earnings",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: kcBlackColor),
                                ),
                                Text(
                                  // "\$ 5.00",
                                  "£ ${order.riderCharges ?? 5.00}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kcBlackColor),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Total Distance",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: kcBlackColor.withOpacity(.4)),
                                ),
                                Text(
                                  // "10 kms",
                                  "${viewModel.findDistance().toStringAsFixed(2)} kms",
                                  // "${order.restaurant?.latitude} kms",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: kcBlackColor),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              40.verticalSpace,

              ///
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!(order.isManual ?? false))
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          // backgroundColor: kcPrimaryColor,
                          ),
                      onPressed: () =>
                          completer(DialogResponse(confirmed: true)),
                      child: Text(
                        "Reject",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: kcBlackColor),
                      ),
                    ),
                  20.horizontalSpace,
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: kcPrimaryColor,
                    ),
                    onPressed: () async {
                    
                      //
                      // accept api
                      ///
                      if (order.id != null) {
                        final res = await viewModel.acceptRide(order.id!);
                        if (res) {
                          completer(DialogResponse(confirmed: true));
                          viewModel.navigateToJobView();
                        } else {
                          completer(DialogResponse(confirmed: true));
                        }
                      }
                    },
                    child: Text(
                      "Accept",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: kcWhitColor),
                    ),
                  ),
                ],
              ),

              ///
              10.verticalSpace,
              // GestureDetector(
              //   onTap: () => completer(DialogResponse(confirmed: true)),
              //   child: Container(
              //     height: 50,
              //     width: double.infinity,
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //       color: Colors.black,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: const Text(
              //       'Got it',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void dispose(IncomnigrequestDialogModel viewModel) {
    timerObj?.cancel();
  }

  @override
  void onViewModelReady(IncomnigrequestDialogModel viewModel) {
    Timer.periodic(1.minutes, (timer) {
      if (timerObj?.isActive ?? false) {
        locator<NavigationService>().back();
        // completer(DialogResponse(confirmed: true));
        timerObj?.cancel();
      }
    });
    super.onViewModelReady(viewModel);
  }

  @override
  IncomnigrequestDialogModel viewModelBuilder(BuildContext context) =>
      IncomnigrequestDialogModel(request.data as OrderModel);
}
