import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rider/ui/common/app_colors.dart';
import 'package:rider/ui/common/ui_helpers.dart';
import 'package:rider/ui/dialogs/progress_indicator/progress.dart';
import 'package:rider/ui/widgets/common/cache_network_image.dart';
import 'package:stacked/stacked.dart';
import 'my_vehicles_viewmodel.dart';

class MyVehiclesView extends StackedView<MyVehiclesViewModel> {
  const MyVehiclesView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, MyVehiclesViewModel viewModel, Widget? child) {
    return CustomProgressIndicator(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            title: Text(
          "Vehicle Documents",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        )),
        body: Container(
          padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Align(
              //   alignment: Alignment.center,
              //   child: NetworkImageWidget(
              //       height: 150.h,
              //       width: 150.w,
              //       url: viewModel.vehicleObject.frontImage ?? ""),
              // ),
              viewModel.isBusy
                  ? const SpinKitFadingCircle(color: kcPrimaryColor, size: 30)
                  : _bannerSlider(viewModel, context),

              50.verticalSpace,
              Container(
                // height: 120.h,
                width: screenWidth(context),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: kcGreyColor.withOpacity(.5),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.car_crash,
                      color: kcPrimaryColor,
                      size: 30.spMax,
                    ),
                    30.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MAKE",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          5.verticalSpace,
                          Text(
                            "MODEL",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          5.verticalSpace,
                          Text(
                            "YEAR",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          5.verticalSpace,
                          Text(
                            "LICENSE PLATE",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (viewModel.vehicleObject.make ?? "").toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          5.verticalSpace,
                          Text(
                            (viewModel.vehicleObject.model ?? "").toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          12.verticalSpace,
                          Text(
                            "${viewModel.vehicleObject.year ?? ""}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          5.verticalSpace,
                          Text(
                            viewModel.vehicleObject.licensePlate ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ///
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      viewModel.navigateToVehicleView();
                    },
                    child: Text(
                      "Update Vehicle Details",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kcPrimaryColor,
                          decoration: TextDecoration.underline),
                    )),
              ),
              50.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      if (viewModel.pFile != null) {
                        viewModel.isFullScreen = true;
                        viewModel.rebuildUi;
                        _showPdfFullScreen(context, viewModel);
                      }
                    },
                    child: Text(
                      "Insurance Documents",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kcPrimaryColor,
                          decoration: TextDecoration.underline),
                    )),
              ),
              // Text(
              //   "Insurance Documents",
              //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //         color: kcPrimaryColor,
              //       ),
              // ),
              // 10.verticalSpace,

              ///
              InkWell(
                onTap: () {
                  if (viewModel.pFile != null) {
                    _showPdfFullScreen(context, viewModel);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kcGreyColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  height: 100.h,
                  width: 100.w,
                  child: viewModel.pFile == null
                      ? const SpinKitFadingCircle(
                          color: kcPrimaryColor, size: 30)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: PDFView(
                            filePath: viewModel.pFile?.path,
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: false,
                            onRender: (pages) {
                              // setState(() {
                              //   pages = _pages;
                              //   isReady = true;
                              // });
                            },
                            onError: (error) {
                              print(error.toString());
                            },
                            onPageError: (page, error) {
                              print('$page: ${error.toString()}');
                            },
                            onViewCreated:
                                (PDFViewController pdfViewController) {
                              viewModel.pdfViewController = pdfViewController;
                            },
                            // onPageChanged: (int page, int total) {
                            //   // print('page change: $page/$total');
                            // },
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerSlider(MyVehiclesViewModel viewModel, BuildContext context) {
    return CarouselSlider(
      items: viewModel.bannerList.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            // final res = viewModel.findRestaurantById(banner.restaurantId);
            return InkWell(
                onTap: () {
                  if (viewModel.pFile != null) {
                    _showFullScreenImage(context, banner);
                  }
                },
                child: roundedImage(context, false, banner));
          },
        );
      }).toList(),
      carouselController: viewModel.controller,
      options: CarouselOptions(
          autoPlay: true,
          height: 160.h,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: false,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.8,
          reverse: true,
          autoPlayInterval: 6.seconds,
          onPageChanged: (index, reason) {
            viewModel.onPageChange(index);
          }),
    );
  }

  Widget roundedImage(context, bool isBusy, String imageUrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      width: screenWidth(context),
      child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10.r), // Adjust the radius as needed
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                // _isLoading = false;
                return child;
              } else {
                // _isLoading = true;
                return const SpinKitFadingCircle(
                    color: kcPrimaryColor, size: 30);
              }
            },
          )
          // NetworkImageWidget(url: imageUrl),
          ),
    );
  }

  void _showPdfFullScreen(BuildContext context, MyVehiclesViewModel viewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Insurance Document',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: Center(
            child: PDFView(
              filePath:
                  viewModel.pFile?.path, // Replace with your PDF file path
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
              },
              onViewCreated: (PDFViewController vc) {
                print('controller initialized');
              },
              onRender: (int? pages) {
                print('rendered $pages pages');
              },
              onError: (error) {
                print(error.toString());
              },
            ),
          ),
        ),
      ),
    ).then((_) {
      // setState(() {
      viewModel.isFullScreen = true;
      viewModel.rebuildUi;
      // });
    });
  }

  _showFullScreenImage(BuildContext context, String imageFile) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
              child: SizedBox(
            // height: 400.h,
            width: screenWidth(context),
            child: NetworkImageWidget(
              url: imageFile,
              fit: BoxFit.contain,
            ),
          )
              // Image.network(imageFile, fit: BoxFit.cover)
              ),
        ),
      ),
    );
    return res;
  }

  @override
  MyVehiclesViewModel viewModelBuilder(BuildContext context) =>
      MyVehiclesViewModel();
}