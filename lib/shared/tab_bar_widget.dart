import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_documents_scanner/screens/documents/documents_screen.dart';
import 'package:smart_documents_scanner/screens/home/home_screen.dart';
import 'package:smart_documents_scanner/screens/settings/settings_screen.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();

  static _TabBarWidgetState? of(BuildContext context) {
    return context.findAncestorStateOfType<_TabBarWidgetState>();
  }
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  void goToTab(int index) {
    _controller.animateTo(index);
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: const [HomeScreen(), DocumentsScreen(), SettingsScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _controller.index,
        onTap: (index) {
          _controller.animateTo(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'appBar.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'appBar.documents'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'appBar.settings'.tr(),
          ),
        ],
      ),
    );
  }
}
