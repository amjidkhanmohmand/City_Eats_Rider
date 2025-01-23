import 'package:rider/models/food.dart';
import 'package:rider/responses/order_response.dart';

class OrderDetail {
  int? id;
  int? foodId;
  int? orderId;
  String? price;
  dynamic foodDetails;
  dynamic variation;
  dynamic addOns;
  dynamic discountOnItem;
  String? discountType;
  int? quantity;
  String? taxAmount;
  dynamic variant;
  String? createdAt;
  String? updatedAt;
  dynamic itemCampaignId;
  String? totalAddOnPrice;
  Food? food;
  List<OrderSubProduct> orderSubProducts = [];
  List<Modifiers>? modifiers = [];
  bool showMore = false;

  OrderDetail({
    this.id,
    this.foodId,
    this.orderId,
    this.price,
    this.foodDetails,
    this.variation,
    this.addOns,
    this.discountOnItem,
    this.discountType,
    this.quantity,
    this.taxAmount,
    this.variant,
    this.createdAt,
    this.updatedAt,
    this.itemCampaignId,
    this.totalAddOnPrice,
    this.food,
    this.modifiers,
  });

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodId = json['food_id'];
    orderId = json['order_id'];
    price = json['price'];
    foodDetails = json['food_details'];
    variation = json['variation'];
    addOns = json['add_ons'];
    discountOnItem = json['discount_on_item'];
    discountType = json['discount_type'];
    quantity = json['quantity'];
    taxAmount = json['tax_amount'];
    variant = json['variant'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemCampaignId = json['item_campaign_id'];
    totalAddOnPrice = json['total_add_on_price'];
    food = json['food'] != null ? Food.fromJson(json['food']) : null;
    if (json['order_sub_products'] != null) {
      orderSubProducts = <OrderSubProduct>[];
      json['order_sub_products'].forEach((v) {
        orderSubProducts.add(OrderSubProduct.fromJson(v));
      });
    }
    modifiers = <Modifiers>[];
    if (json['modifiers'] != null) {
      json['modifiers'].forEach((v) {
        modifiers!.add(Modifiers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['food_id'] = foodId;
    data['order_id'] = orderId;
    data['price'] = price;
    data['food_details'] = foodDetails;
    data['variation'] = variation;
    data['add_ons'] = addOns;
    data['discount_on_item'] = discountOnItem;
    data['discount_type'] = discountType;
    data['quantity'] = quantity;
    data['tax_amount'] = taxAmount;
    data['variant'] = variant;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['item_campaign_id'] = itemCampaignId;
    data['total_add_on_price'] = totalAddOnPrice;
    if (food != null) {
      data['food'] = food!.toJson();
    }

    data['order_sub_products'] =
        orderSubProducts.map((v) => v.toJson()).toList();
    data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Modifiers {
  int? id;
  int? foodId;
  String? name;
  String? type;
  String? optionStatus;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  List<SubModifiers>? subModifiers;
  Modifiers(
      {this.id,
      this.foodId,
      this.name,
      this.type,
      this.optionStatus,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.subModifiers});

  Modifiers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodId = json['food_id'];
    name = json['name'];
    type = json['type'];
    optionStatus = json['option_status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['sub_modifiers'] != null) {
      subModifiers = <SubModifiers>[];
      json['sub_modifiers'].forEach((v) {
        subModifiers!.add(SubModifiers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['food_id'] = foodId;
    data['name'] = name;
    data['type'] = type;
    data['option_status'] = optionStatus;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (subModifiers != null) {
      data['sub_modifiers'] = subModifiers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubModifiers {
  int? id;
  int? modifierId;
  int? cartmodifierProductId;
  int? submodifierId;
  String? name;
  double? price;
  String? description;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  bool? isSelected;

  SubModifiers(
      {this.id,
      this.modifierId,
      this.cartmodifierProductId,
      this.submodifierId,
      this.name,
      this.price,
      this.description,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.isSelected = false});

  SubModifiers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modifierId = json['modifier_id'];
    submodifierId = json['sub_modifier_id'];
    cartmodifierProductId = json['cart_modifier_products_id'];
    name = json['name'];
    price = double.parse(((json['price'] ?? '0').toString()));
    description = json['description'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['modifier_id'] = modifierId;
    data['cart_modifier_products_id'] = cartmodifierProductId;
    data['sub_modifier_id'] = submodifierId;
    data['name'] = name;
    data['price'] = price;
    data['description'] = description;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
