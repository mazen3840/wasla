import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:affiliatepro_mobile/model/dashboard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../service/api_service.dart';
import '../utils/preference.dart';

class DashboardController extends GetxController {
  DashboardController({required this.preferences});
  SharedPreferences preferences;

  bool _isLoading = false;
  bool _isDashboardDataLoading = false;
  UserModel? _loginModel;
  DashboardModel? _dashboardModel;

  // For AI suggestion tracking
  int _currentSuggestionIndex = -1;
  List<String> _cachedSuggestions = [];

  bool get isLoading => _isLoading;
  bool get isDashboardDataLoading => _isDashboardDataLoading;
  UserModel? get loginModel => _loginModel;
  DashboardModel? get dashboardData => _dashboardModel;

  // Getters for suggestion count display
  int get currentSuggestionIndex => _currentSuggestionIndex >= 0 ? _currentSuggestionIndex : 0;
  int get totalSuggestionCount => _cachedSuggestions.isEmpty ? 0 : _cachedSuggestions.length;

  @override
  void onInit() {
    super.onInit();
    _loadSavedSuggestionIndex();
  }

  // Load the saved suggestion index from preferences
  Future<void> _loadSavedSuggestionIndex() async {
    _currentSuggestionIndex = preferences.getInt('current_suggestion_index') ?? -1;
  }

  // Save the current suggestion index to preferences
  Future<void> _saveSuggestionIndex() async {
    await preferences.setInt('current_suggestion_index', _currentSuggestionIndex);
  }

  changeIsLoading(bool data) {
    _isLoading = data;
    update();
  }

  changeDashboardLoading(bool data) {
    _isDashboardDataLoading = data;
    update();
  }

  updateUserData(UserModel model) {
    _loginModel = model;
    update();
  }

  updateDashboardData(DashboardModel model) {
    _dashboardModel = model;
    // Reset suggestions when dashboard data changes
    _cachedSuggestions = [];
    // Don't reset _currentSuggestionIndex to preserve the last viewed suggestion
    update();
  }

  Future<void> getUser() async {
    changeIsLoading(true);
    final userModel = await SharedPreference.getUserData();
    final token = userModel?.data?.token;
    await ApiService.instance
        .getData('User/get_my_profile_details', token: token)
        .then((value) {
      debugPrint('getUser : $value');
      if (value != null) {
        updateUserData(UserModel.fromJson(value));
      }
    });
    changeIsLoading(false);
  }

  getDashboardData() async {
    changeDashboardLoading(true);
    final userModel = await SharedPreference.getUserData();
    final token = userModel?.data?.token;
    String endPoint = 'User/dashboard';
    String params =
        '?includes=plan_details,totals_count,top_affiliate,notifications,market_tools';
    await ApiService.instance
        .getData(endPoint + params, token: token)
        .then((value) {
      //debugPrint('Get Dashboard : $value');
      if (value != null) {
        updateDashboardData(DashboardModel.fromJson(value));
      }
    });
    changeDashboardLoading(false);
  }

  // Refresh AI suggestion - pick a different one
  void refreshAISuggestion() {
    // Generate suggestions if not already done
    if (_cachedSuggestions.isEmpty) {
      _cachedSuggestions = _generateAdvancedAIInsights();
    }

    // Pick a different suggestion if possible
    if (_cachedSuggestions.length > 1) {
      int newIndex;
      do {
        newIndex = DateTime.now().millisecond % _cachedSuggestions.length;
      } while (newIndex == _currentSuggestionIndex && _cachedSuggestions.length > 1);

      _currentSuggestionIndex = newIndex;
    } else {
      // If only one suggestion, keep the same
      _currentSuggestionIndex = 0;
    }

    // Save the current suggestion index
    _saveSuggestionIndex();

    // Update UI
    update();
  }

  String getAISuggestion() {
    // If no cached suggestions, generate them
    if (_cachedSuggestions.isEmpty) {
      _cachedSuggestions = _generateAdvancedAIInsights();

      // If we have a saved index and it's valid, use it
      if (_currentSuggestionIndex >= 0 && _currentSuggestionIndex < _cachedSuggestions.length) {
        // Use the saved index
      } else {
        // Otherwise generate a new index
        _currentSuggestionIndex = DateTime.now().millisecond % _cachedSuggestions.length;
        _saveSuggestionIndex();
      }
    }

    return _cachedSuggestions[_currentSuggestionIndex];
  }

  // Generate advanced AI insights based on all available data
  List<String> _generateAdvancedAIInsights() {
    final List<String> insights = [];

    // Safety check for null data
    if (dashboardData == null) {
      return ["Please wait while I analyze your data..."];
    }

    final data = dashboardData!.data;
    final totals = data.userTotals;
    final marketTools = data.marketTools;
    final referTotal = data.referTotal;

    // Extract key metrics from UserTotals
    // Currency and balance information
    final userBalance = totals.userBalance;
    final currencyMatch = RegExp(r'^\D+').firstMatch(userBalance);
    final currency = currencyMatch != null ? currencyMatch.group(0)! : "";
    final balanceAmount = double.tryParse(userBalance.replaceAll(RegExp(r'[^\d.]'), "")) ?? 0;

    // Earnings data
    final weekEarnings = data.userTotalsWeek;
    final monthEarnings = data.userTotalsMonth;
    final yearEarnings = data.userTotalsYear;
    final weekAmount = double.tryParse(weekEarnings.replaceAll(RegExp(r'[^\d.]'), "")) ?? 0;
    final monthAmount = double.tryParse(monthEarnings.replaceAll(RegExp(r'[^\d.]'), "")) ?? 0;
    final yearAmount = double.tryParse(yearEarnings.replaceAll(RegExp(r'[^\d.]'), "")) ?? 0;

    // Wallet and commission data
    final walletUnpaidAmount = totals.walletUnpaidAmount is num ? totals.walletUnpaidAmount : 0.0;
    final walletUnpaidCount = totals.walletUnpaidCount is num ? totals.walletUnpaidCount : 0;

    // Click and sale data
    final totalClicksCount = totals.totalClicksCount is num ? totals.totalClicksCount : 0;
    final totalClicksCommission = totals.totalClicksCommission is num ? totals.totalClicksCommission : 0.0;
    final saleLocalstoreCount = totals.saleLocalstoreCount is num ? totals.saleLocalstoreCount : 0;
    final saleLocalstoreTotal = totals.saleLocalstoreTotal is num ? totals.saleLocalstoreTotal : 0.0;
    final saleLocalstoreCommission = totals.saleLocalstoreCommission is num ? totals.saleLocalstoreCommission : 0.0;

    // External and local store data
    final clickLocalstoreTotal = totals.clickLocalstoreTotal;
    final clickExternalTotal = totals.clickExternalTotal is num ? totals.clickExternalTotal : 0;
    final orderExternalCount = int.tryParse(totals.orderExternalCount) ?? 0;

    // Action and form data
    final clickActionTotal = totals.clickActionTotal is num ? totals.clickActionTotal : 0;
    final clickFormTotal = totals.clickFormTotal is num ? totals.clickFormTotal : 0;

    // Vendor data
    final vendorClickLocalstoreTotal = totals.vendorClickLocalstoreTotal is num ? totals.vendorClickLocalstoreTotal : 0;
    final vendorSaleLocalstoreCount = totals.vendorSaleLocalstoreCount is num ? totals.vendorSaleLocalstoreCount : 0;

    // Refer data
    final referStatus = data.referStatus;
    final uniqueResellerLink = data.uniqueResellerLink;
    final totalProductClicks = int.tryParse(referTotal.totalProductClick.clicks) ?? 0;
    final totalGeneralClicks = int.tryParse(referTotal.totalGaneralClick.totalClicks) ?? 0;
    final totalActionClicks = int.tryParse(referTotal.totalAction.clickCount) ?? 0;
    final totalProductSalesCounts = int.tryParse(referTotal.totalProductSale.counts) ?? 0;

    // Membership data
    final isMembershipAccess = data.isMembershipAccess;
    final userPlan = data.userPlan;
    final daysLeft = userPlan.expireAt.difference(DateTime.now()).inDays;
    final isLifetime = userPlan.isLifetime == "1";

    // Store URL
    final storeUrl = data.affiliateStoreUrl;

    // === ADVANCED AI INSIGHTS ===

    // 1. WALLET AND EARNINGS INSIGHTS
    if (walletUnpaidAmount > 0 && walletUnpaidCount > 0) {
      if (balanceAmount > 0) {
        final totalAvailable = balanceAmount + walletUnpaidAmount;
        insights.add("I've analyzed your account: you have $currency$balanceAmount available plus $currency$walletUnpaidAmount in pending commissions from $walletUnpaidCount unpaid transactions. Your total potential is $currency$totalAvailable. Consider withdrawing some funds while continuing to grow your earnings.");
      } else {
        insights.add("You have $walletUnpaidCount unpaid commissions waiting for you, totaling $currency$walletUnpaidAmount. Requesting a withdrawal would convert these pending commissions into available funds.");
      }
    }

    // 2. PERFORMANCE TREND INSIGHT
    if (weekAmount > 0 && monthAmount > 0 && yearAmount > 0) {
      final weekPercentageOfMonth = (weekAmount / monthAmount * 100).toStringAsFixed(1);
      final monthPercentageOfYear = (monthAmount / yearAmount * 100).toStringAsFixed(1);

      if (double.parse(weekPercentageOfMonth) > 25) {
        insights.add("You're outperforming your average! This week's earnings ($currency$weekAmount) represent $weekPercentageOfMonth% of your monthly total ($currency$monthAmount), which is above the expected 25% weekly rate. Keep up this momentum to significantly increase your monthly earnings.");
      } else {
        insights.add("This week's earnings ($currency$weekAmount) represent $weekPercentageOfMonth% of your monthly earnings ($currency$monthAmount), which is ${double.parse(weekPercentageOfMonth) < 25 ? "below" : "at"} the expected weekly pace. Your month is currently at $monthPercentageOfYear% of your yearly earnings.");
      }
    }

    // 3. MARKET TOOLS PERFORMANCE INSIGHT
    if (marketTools.isNotEmpty) {
      // Find best performing tool by click count
      final bestClickTool = marketTools.reduce((a, b) => a.clickCount > b.clickCount ? a : b);
      // Find best performing tool by sale count
      final bestSaleTool = marketTools.reduce((a, b) => a.saleCount > b.saleCount ? a : b);

      if (bestClickTool.clickCount > 0) {
        insights.add("Your top-performing tool by traffic is \"${bestClickTool.title}\" with ${bestClickTool.clickCount} clicks. ${bestClickTool.saleCount > 0 ? "It has generated ${bestClickTool.saleCount} sales so far." : "Consider optimizing your funnel to convert more of this traffic into sales."}");
      }

      if (bestSaleTool.saleCount > 0 && bestSaleTool.title != bestClickTool.title) {
        insights.add("\"${bestSaleTool.title}\" is your best converter with ${bestSaleTool.saleCount} sales. Its conversion rate of ${(bestSaleTool.saleCount / (bestSaleTool.clickCount > 0 ? bestSaleTool.clickCount : 1) * 100).toStringAsFixed(1)}% is impressive. Consider driving more traffic to this high-performing tool.");
      }

      // Find tools with zero clicks but good commission potential
      final unusedTools = marketTools.where((tool) =>
      tool.clickCount == 0 &&
          (double.tryParse(tool.saleCommisionYouWillGet.replaceAll(RegExp(r'[^\d.]'), "")) ?? 0) > 0
      ).toList();

      if (unusedTools.isNotEmpty && unusedTools.length <= 3) {
        final toolNames = unusedTools.map((t) => "\"${t.title}\"").join(", ");
        insights.add("I've identified untapped potential: $toolNames ${unusedTools.length == 1 ? "is" : "are"} not generating traffic yet but offer${unusedTools.length == 1 ? "s" : ""} good commission rates. Try promoting ${unusedTools.length == 1 ? "this tool" : "these tools"} to diversify your revenue streams.");
      }
    }

    // 4. CONVERSION RATE ANALYSIS
    if (totalClicksCount > 0) {
      if (saleLocalstoreCount > 0) {
        final conversionRate = (saleLocalstoreCount / totalClicksCount * 100).toStringAsFixed(2);
        insights.add("Your overall conversion rate is $conversionRate% ($saleLocalstoreCount sales from $totalClicksCount clicks). ${double.parse(conversionRate) > 2 ? "This is above the industry average of 1-2%, indicating effective targeting or persuasive content." : "The industry average is 1-2%, so optimizing your landing pages and promotional content could increase conversions."}");
      } else if (totalClicksCount >= 20) {
        insights.add("You've generated $totalClicksCount clicks but haven't converted any sales yet. With this volume of traffic, focus on optimizing your funnel - check that landing pages are compelling and products are matched to your audience's interests.");
      } else {
        insights.add("You've started generating clicks ($totalClicksCount so far) but need more traffic before focusing on conversion optimization. Continue building your audience to reach at least 100 clicks for meaningful conversion data.");
      }
    }

    // 5. COMMISSION EFFICIENCY ANALYSIS
    if (totalClicksCount > 0 && totalClicksCommission > 0) {
      final earningsPerClick = (totalClicksCommission / totalClicksCount).toStringAsFixed(2);
      insights.add("Your average commission per click is $currency$earningsPerClick. ${double.parse(earningsPerClick) > 0.15 ? "This is a strong earnings ratio, indicating you're promoting high-value products or have favorable commission terms." : "Consider promoting products with higher commission rates to maximize your return on traffic."}");
    }

    // 6. TRAFFIC SOURCE ANALYSIS
    if (clickLocalstoreTotal > 0 || clickExternalTotal > 0 || clickActionTotal > 0 || clickFormTotal > 0) {
      final totalTraffic = clickLocalstoreTotal + (clickExternalTotal as num) + (clickActionTotal as num) + (clickFormTotal as num);

      if (totalTraffic > 0) {
        final localPercent = (clickLocalstoreTotal / totalTraffic * 100).toStringAsFixed(1);
        final externalPercent = (clickExternalTotal / totalTraffic * 100).toStringAsFixed(1);
        final actionPercent = (clickActionTotal / totalTraffic * 100).toStringAsFixed(1);
        final formPercent = (clickFormTotal / totalTraffic * 100).toStringAsFixed(1);

        // Find highest traffic source
        String highestSource = "local store";
        double highestPercent = double.parse(localPercent);

        if (double.parse(externalPercent) > highestPercent) {
          highestSource = "external links";
          highestPercent = double.parse(externalPercent);
        }
        if (double.parse(actionPercent) > highestPercent) {
          highestSource = "action links";
          highestPercent = double.parse(actionPercent);
        }
        if (double.parse(formPercent) > highestPercent) {
          highestSource = "form submissions";
          highestPercent = double.parse(formPercent);
        }

        insights.add("Your traffic analysis shows that $highestPercent% of your clicks come from $highestSource. ${highestPercent > 75 ? "Consider diversifying your traffic sources to reduce dependency on a single channel." : "Your traffic diversification is healthy, but you could still optimize your $highestSource channel further for better results."}");
      }
    }

    // 7. REFERRAL PROGRAM INSIGHT
    if (!referStatus && totalProductClicks == 0 && totalGeneralClicks == 0) {
      insights.add("Your referral program is currently disabled. Enabling this feature could create a passive income stream through your network. Consider activating it in your account settings to expand your earning potential.");
    } else if (referStatus && (totalProductClicks > 0 || totalGeneralClicks > 0)) {
      if (totalProductSalesCounts > 0) {
        insights.add("Your referral program is generating results with $totalGeneralClicks general clicks, $totalProductClicks product clicks, and $totalProductSalesCounts sales. Continue sharing your unique reseller link to grow these numbers further.");
      } else {
        insights.add("Your referral program has generated traffic ($totalGeneralClicks general clicks and $totalProductClicks product clicks) but hasn't converted to sales yet. Consider coaching your referrals on effective promotion strategies to improve conversions.");
      }
    } else if (referStatus && uniqueResellerLink.isNotEmpty && totalProductClicks == 0 && totalGeneralClicks == 0) {
      insights.add("Your referral program is active but hasn't generated any traffic yet. Share your unique reseller link with potential partners or on your social platforms to start building your referral network.");
    }

    // 8. MEMBERSHIP STATUS INSIGHT
    if (isMembershipAccess && !isLifetime && daysLeft > 0) {
      if (daysLeft <= 7) {
        insights.add("⚠️ Your membership expires in just $daysLeft day${daysLeft == 1 ? '' : 's'}! To maintain access to all affiliate tools and features, renew your subscription soon to avoid any interruption to your earnings.");
      } else if (daysLeft <= 30) {
        insights.add("Your membership will expire in $daysLeft days. If you're seeing positive results, consider renewing to maintain your momentum. Your current plan runs until ${Jiffy.parseFromDateTime(userPlan.expireAt).yMMMMd}.");
      }
    } else if (!isMembershipAccess) {
      insights.add("You don't currently have active membership access. Upgrading to a paid plan would unlock additional affiliate tools, higher commission rates, and more promotional opportunities.");
    }

    // 9. STORE INSIGHT
    if (storeUrl.isEmpty) {
      insights.add("I notice your affiliate store URL isn't configured. Setting this up would create a dedicated storefront for your products, potentially increasing your conversion rates and providing a more professional experience for your customers.");
    } else if (storeUrl.isNotEmpty && saleLocalstoreCount == 0 && clickLocalstoreTotal > 20) {
      insights.add("Your affiliate store is getting traffic ($clickLocalstoreTotal clicks) but hasn't generated sales yet. Consider reviewing your store layout, product selection, and call-to-action elements to improve the customer journey.");
    } else if (storeUrl.isNotEmpty && saleLocalstoreCount > 0) {
      final storeConversionRate = (saleLocalstoreCount / clickLocalstoreTotal * 100).toStringAsFixed(2);
      insights.add("Your affiliate store has a conversion rate of $storeConversionRate% ($saleLocalstoreCount sales from $clickLocalstoreTotal clicks). ${double.parse(storeConversionRate) > 2.5 ? "This is above average for e-commerce, indicating an effective store design." : "The average e-commerce conversion rate is 2-3%, so there may be room to optimize your store layout or product presentation."}");
    }

    // 10. VENDOR PERFORMANCE INSIGHT
    if (vendorClickLocalstoreTotal > 0 || vendorSaleLocalstoreCount > 0) {
      if (vendorSaleLocalstoreCount > 0) {
        final vendorConversionRate = (vendorSaleLocalstoreCount / (vendorClickLocalstoreTotal > 0 ? vendorClickLocalstoreTotal : 1) * 100).toStringAsFixed(2);
        insights.add("As a vendor, your products have achieved a $vendorConversionRate% conversion rate ($vendorSaleLocalstoreCount sales from $vendorClickLocalstoreTotal clicks). ${double.parse(vendorConversionRate) > 3 ? "This is strong performance, suggesting your products resonate well with buyers." : "Consider optimizing your product listings or pricing strategy to improve conversions."}");
      } else if (vendorClickLocalstoreTotal > 0) {
        insights.add("Your vendor products are receiving attention ($vendorClickLocalstoreTotal clicks) but haven't converted to sales yet. Review your product descriptions, pricing, and images to make your offerings more appealing to potential buyers.");
      }
    }

    // 11. EXTERNAL ORDER INSIGHT
    if (orderExternalCount > 0) {
      insights.add("You've generated $orderExternalCount external orders. This shows your ability to drive conversions through external platforms. Continue leveraging these channels while expanding your promotional reach to maximize cross-platform sales.");
    }

    // If we somehow still have very few insights (unlikely with this comprehensive analysis)
    if (insights.length < 3) {
      if (totalClicksCount > 0 || saleLocalstoreCount > 0 || balanceAmount > 0) {
        insights.add("I'm actively monitoring your affiliate marketing performance. As you generate more data through continued promotions, I'll provide increasingly detailed and actionable insights to help optimize your strategy.");
      } else {
        insights.add("Your account is set up and ready for affiliate marketing activities. Start by promoting your links through content marketing, social media, or email campaigns to generate your first clicks and sales data.");
      }
    }

    return insights;
  }

  String daysBetween(DateTime time) {
    final now = DateTime.now();
    final days = time.difference(now).inDays;
    return days.toString();
  }

  String convertDate(DateTime time) {
    try {
      return Jiffy.parseFromDateTime(time).yMMMMdjm;
    } catch (e) {
      // Fallback to a basic format if Jiffy fails
      return '${time.year}-${time.month}-${time.day} ${time.hour}:${time.minute}';
    }
  }
}