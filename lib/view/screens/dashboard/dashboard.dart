import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affiliatepro_mobile/controller/dashboard_controller.dart';
import 'package:affiliatepro_mobile/utils/colors.dart' as app_colors;
import 'package:affiliatepro_mobile/utils/text.dart' as app_texts;
import 'package:affiliatepro_mobile/view/screens/dashboard/components/menu.dart';
import 'package:affiliatepro_mobile/view/screens/dashboard/components/notification_bar.dart';
import '../../../controller/payments_detail_controller.dart';
import '../../base/custom_app_bar.dart';
import 'components/data_cubic.dart';
import 'components/membership_plan.dart';
import 'components/profile_card.dart';
import 'components/shimmer_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  bool hideAISuggestionBox = false;
  bool hideForever = false;
  bool isAIPanelOpen = false;
  bool isRefreshing = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;


  @override
  void initState() {
    super.initState();
    Get.find<DashboardController>().getUser();
    Get.find<DashboardController>().getDashboardData();
    fetchPayment();
    checkHidePreference();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),  // Starts from right
      end: Offset.zero,                // Ends at original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void fetchPayment() {
    Get.find<PaymentDetailController>().getPaymentsData();
  }

  Future<void> checkHidePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hideForever = prefs.getBool('hide_ai_box_forever') ?? false;
    });
  }

  Future<void> setHideForever() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hide_ai_box_forever', true);
    setState(() {
      hideAISuggestionBox = true;
      hideForever = true;
      // Close the panel
      _toggleAIPanel();
    });
  }

  void hideOnce() {
    setState(() {
      hideAISuggestionBox = true;
      // Close the panel
      _toggleAIPanel();
    });
  }

  void _toggleAIPanel() {
    setState(() {
      isAIPanelOpen = !isAIPanelOpen;
      if (isAIPanelOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  // Handle the suggestion refresh with fade animation
  void _refreshSuggestion() {
    setState(() {
      isRefreshing = true;
    });

    // Get a new suggestion
    final dashboardController = Get.find<DashboardController>();
    dashboardController.refreshAISuggestion();

    // Reset the refresh state after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          isRefreshing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentDetailController>(
      builder: (paymentDetailController) {
        return GetBuilder<DashboardController>(
          builder: (dashboardController) {
            return Scaffold(
              drawer: const Drawer(child: MenuPage()),
              backgroundColor: app_colors.AppColor.dashboardBgColor,
              body: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        CustomAppBar(
                          title: app_texts.AppText.dashboard,
                          isProfile: true,
                        ),
                        Expanded(
                          child: _buildContent(
                            dashboardController,
                            paymentDetailController,
                          ),
                        ),
                      ],
                    ),

                    // Small, non-intrusive AI Button
                    if (!hideForever)
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _toggleAIPanel,
                              borderRadius: BorderRadius.circular(24),
                              child: Center(
                                child: Icon(
                                  isAIPanelOpen ? Icons.close : Icons.smart_toy_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Sliding AI Panel
                    if (!hideAISuggestionBox && !hideForever && isAIPanelOpen)
                      Positioned(
                        right: 16,
                        top: 80, // Position below app bar
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85 - 16,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header with AI Assistant title and close button
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.smart_toy_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "AI Assistant",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: _toggleAIPanel,
                                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // AI Assistant content
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // AI Assistant label with suggestion counter
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.smart_toy_outlined,
                                              color: Colors.deepPurple,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "AI Assistant",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepPurple.shade700,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const Spacer(),
                                            // Display suggestion counter
                                            if (dashboardController.totalSuggestionCount > 0)
                                              Text(
                                                "${dashboardController.currentSuggestionIndex + 1} of ${dashboardController.totalSuggestionCount}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),

                                        // Suggestion text with fade effect
                                        AnimatedOpacity(
                                          opacity: isRefreshing ? 0.0 : 1.0,
                                          duration: const Duration(milliseconds: 300),
                                          child: Text(
                                            dashboardController.getAISuggestion(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        // AI powered insights badge
                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              "AI powered insights",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Action buttons - matches screenshot exactly
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        // New Suggestion button
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: _refreshSuggestion,
                                            icon: const Icon(
                                              Icons.refresh,
                                              size: 16,
                                            ),
                                            label: const Text("New Suggestion"),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.deepPurple,
                                              side: BorderSide(color: Colors.grey[300]!),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Dismiss button
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: hideOnce,
                                            icon: const Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                            label: const Text("Dismiss"),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.grey[700],
                                              side: BorderSide(color: Colors.grey[300]!),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(
      DashboardController dashboardController,
      PaymentDetailController paymentDetailController,
      ) {
    if (dashboardController.isLoading ||
        dashboardController.isDashboardDataLoading) {
      return ShimmerWidget(controller: dashboardController);
    }

    var dashModel = dashboardController.dashboardData!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (paymentDetailController.PaymentDetailData?.data.notification
                ?.paymentList ==
                'Bank details are not set!')
              NotificationBar(controller: paymentDetailController),

            const SizedBox(height: 20),
            ProfileCard(controller: dashboardController),
            const SizedBox(height: 20),
            DataCubic(model: dashModel),
            const SizedBox(height: 20),

            // Affiliate Links Section - UPDATED SECTION
            if (dashboardController.dashboardData?.data != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: const [
                        Icon(Icons.link, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(
                          "Affiliate Links",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Affiliate Store URL
                    _buildAffiliateLink(
                      label: "Affiliate Store URL",
                      value: dashboardController.dashboardData!.data.affiliateStoreUrl,
                      icon: Icons.storefront_outlined,
                    ),

                    const SizedBox(height: 16),

                    // Reseller Registration Link
                    _buildAffiliateLink(
                      label: "Reseller Registration Link",
                      value: dashboardController.dashboardData!.data.uniqueResellerLink,
                      icon: Icons.person_add_outlined,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            MembershipPlan(controller: dashboardController),
          ],
        ),
      ),
    );
  }

  // Helper method to build the affiliate link items with copy functionality
  Widget _buildAffiliateLink({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with icon
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Link container with copy button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              // Link text
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Copy button
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  Get.snackbar(
                    'Copied!',
                    'Link copied to clipboard',
                    backgroundColor: Colors.green[50],
                    colorText: Colors.green[800],
                    margin: const EdgeInsets.all(8),
                    duration: const Duration(seconds: 2),
                    snackPosition: SnackPosition.BOTTOM,
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                  );
                },
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.copy,
                        size: 14,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Copy",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}