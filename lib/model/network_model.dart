import 'dart:convert';

NetworkModel NetworkModelFromJson(String str) =>
    NetworkModel.fromJson(json.decode(str));

class NetworkModel {
  NetworkModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  NetworkData data;

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: NetworkData.fromJson(json["data"]),
      );
}

class NetworkData {
  NetworkData({
    required this.referTotal,
    required this.referredUsersTree,
    required this.userslist,
  });

  List<Userslist> userslist;
  ReferTotal referTotal;
  List<ReferredUsersTree> referredUsersTree;

  factory NetworkData.fromJson(Map<String, dynamic> json) => NetworkData(
        userslist: List<Userslist>.from(
            json["userslist"].map((x) => Userslist.fromJson(x))),
        referTotal: ReferTotal.fromJson(json["refer_total"]),
        referredUsersTree: List<ReferredUsersTree>.from(
            json["referred_users_tree"]
                .map((x) => ReferredUsersTree.fromJson(x))),
      );
}

class Userslist {
  String name;
  List<Userslist> children;
  Userslist({required this.children, required this.name});
  factory Userslist.fromJson(Map<String, dynamic> json) => Userslist(
        name: json["name"].toString(),
        children: List<Userslist>.from(
            json["children"].map((x) => Userslist.fromJson(x))),
      );
}

class ReferTotal {
  ReferTotal({
    required this.totalProductClick,
    required this.totalGaneralClick,
    required this.totalAction,
    required this.totalProductSale,
  });

  TotalProductClick totalProductClick;
  TotalGaneralClick totalGaneralClick;
  TotalAction totalAction;
  TotalProductSale totalProductSale;

  factory ReferTotal.fromJson(Map<String, dynamic> json) => ReferTotal(
        totalProductClick:
            TotalProductClick.fromJson(json["total_product_click"]),
        totalGaneralClick:
            TotalGaneralClick.fromJson(json["total_ganeral_click"]),
        totalAction: TotalAction.fromJson(json["total_action"]),
        totalProductSale: TotalProductSale.fromJson(json["total_product_sale"]),
      );
}

class TotalAction {
  TotalAction({
    required this.clickCount,
  });

  String clickCount;

  factory TotalAction.fromJson(Map<String, dynamic> json) => TotalAction(
        clickCount: json["click_count"].toString(),
      );
}

class TotalGaneralClick {
  TotalGaneralClick({
    required this.totalClicks,
  });

  String totalClicks;

  factory TotalGaneralClick.fromJson(Map<String, dynamic> json) =>
      TotalGaneralClick(
        totalClicks: json["total_clicks"].toString(),
      );
}

class TotalProductClick {
  TotalProductClick({
    required this.amounts,
    required this.clicks,
  });

  dynamic amounts;
  String clicks;

  factory TotalProductClick.fromJson(Map<String, dynamic> json) =>
      TotalProductClick(
        amounts: json["amounts"],
        clicks: json["clicks"].toString(),
      );
}

class TotalProductSale {
  TotalProductSale({
    required this.amounts,
    required this.counts,
    required this.paid,
    required this.request,
    required this.unpaid,
  });

  dynamic amounts;
  String counts;
  dynamic paid;
  dynamic request;
  dynamic unpaid;

  factory TotalProductSale.fromJson(Map<String, dynamic> json) =>
      TotalProductSale(
        amounts: json["amounts"],
        counts: json["counts"],
        paid: json["paid"],
        request: json["request"],
        unpaid: json["unpaid"],
      );
}


enum Type { USER }

final typeValues = EnumValues({"user": Type.USER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class ReferredUsersTree {
  String title;
  String email;
  int click;
  int external_click;
  int form_click;
  int aff_click;
  String click_commission;
  int external_action_click;
  String action_click_commission;
  String amount_external_sale_amount;
  String sale_commission;
  String paid_commition;
  String unpaid_commition;
  String in_request_commiton;
  String all_commition;
  List children;
  ReferredUsersTree({
    required this.action_click_commission,
    required this.aff_click,
    required this.all_commition,
    required this.amount_external_sale_amount,
    required this.children,
    required this.click,
    required this.click_commission,
    required this.email,
    required this.external_action_click,
    required this.external_click,
    required this.form_click,
    required this.in_request_commiton,
    required this.paid_commition,
    required this.sale_commission,
    required this.title,
    required this.unpaid_commition,
  });
  factory ReferredUsersTree.fromJson(Map<String, dynamic> json) =>
      ReferredUsersTree(
        title: json["title"] ?? "",
        email: json["email"] ?? "",
        click: json["click"] ?? 0,
        external_click: json["external_click"] ?? 0,
        form_click: json["form_click"] ?? 0,
        aff_click: json["aff_click"] ?? 0,
        click_commission: json["click_commission"] ?? "",
        external_action_click: json["external_action_click"] ?? 0,
        action_click_commission: json["action_click_commission"] ?? "",
        amount_external_sale_amount: json["amount_external_sale_amount"] ?? "",
        sale_commission: json["sale_commission"] ?? "",
        paid_commition: json["paid_commition"] ?? "",
        unpaid_commition: json["unpaid_commition"] ?? "",
        in_request_commiton: json["in_request_commiton"] ?? "",
        all_commition: json["all_commition"] ?? "",
        children: json["children"] ?? [],
      );
}
