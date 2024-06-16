import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';

enum NavigationItem { dashboard, addEvent, cart, chat }

class NavigationItemUtil {
  static const Map<NavigationItem, String> itemNames = {
    NavigationItem.dashboard: 'Dashboard',
    NavigationItem.addEvent: 'Add Event',
    NavigationItem.cart: 'Cart',
    NavigationItem.chat: 'Chat',
  };

  static SvgPicture iconsOf(NavigationItem item) {
    switch (item) {
      case NavigationItem.dashboard:
        return SvgPicture.asset('assets/svg/dashboard.svg');
      case NavigationItem.addEvent:
        return SvgPicture.asset('assets/svg/add_event.svg');
      case NavigationItem.cart:
        return SvgPicture.asset('assets/svg/cart.svg');
      case NavigationItem.chat:
        return SvgPicture.asset('assets/svg/chat.svg');
      default:
        return SvgPicture.asset('assets/svg/dashboard.svg');
    }
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _selectedPage = BehaviorSubject<int>.seeded(0);
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: Implement Role Checking
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: const [
              Center(child: Text('Dashboard')),
              Center(child: Text('Add Event')),
              Center(child: Text('Cart')),
              Center(child: Text('Chat')),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: StreamBuilder<int>(
                stream: _selectedPage,
                builder: (context, snapshot) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: BottomNavigationBar(
                      items: NavigationItem.values
                          .map((e) => BottomNavigationBarItem(
                              icon: NavigationItemUtil.iconsOf(e),
                              label: "•",
                              backgroundColor: Colors.transparent))
                          .toList(),
                      currentIndex: _selectedPage.value,
                      onTap: (index) {
                        _selectedPage.add(index);
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                    ),
                  );
                })));
  }
}
