import 'dart:convert';

BannerAndLinksModel dashboardModelFromJson(String str) =>
    BannerAndLinksModel.fromJson(json.decode(str));

class BannerAndLinksModel {
  BannerAndLinksModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<BannerData> data;

  factory BannerAndLinksModel.fromJson(Map<String, dynamic> json) =>
      BannerAndLinksModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: List<BannerData>.from(json["data"].map((x) => BannerData.fromJson(x))),
      );
}

class BannerData {
  BannerData({
    required this.action_amount,
    required this.action_count,
    required this.aff_tool_type,
    required this.click_amount,
    required this.click_commision_you_will_get,
    required this.click_count,
    required this.click_ratio,
    required this.clicks_commission,
    required this.description,
    required this.displayed_on_store,
    required this.fevi_icon,
    required this.general_amount,
    required this.general_count,
    required this.is_campaign_product,
    required this.price,
    required this.product_sku,
    required this.public_page,
    required this.sale_amount,
    required this.sale_commision_you_will_get,
    required this.sale_count,
    required this.sale_ratio,
    required this.sales_commission,
    required this.share_url,
    required this.title,
    required this.total_commission,
    required this.recurring,
  });

  String aff_tool_type;
  bool is_campaign_product;
  String public_page;
  String share_url;
  String fevi_icon;
  String title;
  String recurring;
  String sale_commision_you_will_get;
  String click_commision_you_will_get;
  String description;
  String price;
  String product_sku;
  String sales_commission;
  String clicks_commission;
  String total_commission;
  bool displayed_on_store;
  dynamic sale_count;
  String sale_amount;
  dynamic click_count;
  String click_amount;
  String click_ratio;
  dynamic general_count;
  String general_amount;
  String sale_ratio;
  dynamic action_count;
  String action_amount;

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
        aff_tool_type: json["aff_tool_type"] ?? "",
        public_page: json["public_page"] ?? "",
        fevi_icon: json["fevi_icon"] ?? "",
        title: json["title"] ?? "",
        share_url: json["share_url"] ?? "",
        click_commision_you_will_get:
            json["click_commision_you_will_get"] ?? "",
        click_ratio: json["click_ratio"] ?? "",
        recurring: json["recurring"] ?? "",
        general_count: json["general_count"] ?? 0,
        general_amount: json["general_amount"] ?? "",
        sale_commision_you_will_get: json["sale_commision_you_will_get"] ?? "",
        sale_ratio: json["sale_ratio"] ?? "",
        sale_count: json["sale_count"] ?? 0,
        sale_amount: json["sale_amount"] ?? "",
        click_count: json["click_count"] ?? 0,
        click_amount: json["click_amount"] ?? "",
        action_count: json["action_count"] ?? 0,
        action_amount: json["action_amount"] ?? "",
        is_campaign_product: json["is_campaign_product"] ?? false,
        description: json["description"] ?? "",
        price: json["price"] ?? "",
        product_sku: json["product_sku"] ?? "",
        sales_commission: json["sales_commission"] ?? "",
        clicks_commission: json["clicks_commission"] ?? "",
        total_commission: json["total_commission"] ?? "",
        displayed_on_store: json["displayed_on_store"] ?? false,
      );
}
