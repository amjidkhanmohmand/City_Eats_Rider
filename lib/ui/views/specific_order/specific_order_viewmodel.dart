import 'package:rider/app/app.locator.dart';
import 'package:rider/app/app.logger.dart';
import 'package:rider/app/app.router.dart';
import 'package:rider/models/order_detials.dart';
import 'package:rider/responses/order_response.dart';
import 'package:rider/responses/specific_order_response.dart';
import 'package:rider/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificOrderViewModel extends BaseViewModel {
  final OrderModel order;
  final _navService = locator<NavigationService>();

  double rating = 0;

  final log = getLogger("OrderDetailViewModel");

  SpecificOrderViewModel(this.order) {
    getSpecificOrder(order.id ?? 0);
  }
  navigateToOnWay(order) {
    _navService.navigateToOnWayView(order: order);
  }

  final _dbService = locator<DatabaseService>();
  SpecificOrderResponse? res;
  bool isLoaded = false;

  getSpecificOrder(int orderId) async {
    setBusy(true);
    res = await _dbService.fetchOrderDetails(orderId);
    log.wtf("FetchOrderDetails: ${res?.body?.orders?.toJson()}");
    if (res?.success ?? false) {
      isLoaded = true;
      print(res?.body?.orders?.deliveryAddress);
    } else {}

    setBusy(false);
  }

  void navigateToMap(latitude, longitude) async {
    double lat = double.parse("${latitude?.toString() ?? 0.0}");
    double lng = double.parse("${longitude?.toString() ?? 0.0}");
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  getProductSubmod(OrderDetail product) {
    List<SubModifiers> cartSubModifiers = [];
    for (int i = 0; i < product.modifiers!.length; i++) {
      for (int j = 0; j < product.modifiers![i].subModifiers!.length; j++) {
        cartSubModifiers.add(product.modifiers![i].subModifiers![j]);
      }
    }
    log.wtf("cartSubMmodifers:${cartSubModifiers.length}");
    return cartSubModifiers;
  }

   toggleShowMore(int index) {
    int length = res?.body?.orders?.orderDetail!.length ?? 0;
    log.w('@toggleShowMore');

    if (res?.body?.orders?.orderDetail != null) {
      for (int i = 0; i < length; i++) {
        if (i == index) {
          res?.body?.orders?.orderDetail![index].showMore =
              !res!.body!.orders!.orderDetail![index].showMore;
        } else {
          res!.body!.orders!.orderDetail![i].showMore = false;
        }
      }
    }

    rebuildUi();
  }
}
