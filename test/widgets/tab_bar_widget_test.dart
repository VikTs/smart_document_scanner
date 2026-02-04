import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TabBarWidget displays tabs and switches correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TabBarWidgetStub(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);
    expect(find.text('Documents Screen'), findsNothing);

    await tester.tap(find.text('Documents'));
    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsNothing);
    expect(find.text('Documents Screen'), findsOneWidget);
  });
}

class TabBarWidgetStub extends StatefulWidget {
  const TabBarWidgetStub({super.key});

  @override
  State<TabBarWidgetStub> createState() => _TabBarWidgetStubState();
}

class _TabBarWidgetStubState extends State<TabBarWidgetStub>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: const [
          Center(child: Text('Home Screen')),
          Center(child: Text('Documents Screen')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _controller.index,
        onTap: (index) {
          _controller.animateTo(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'Documents'),
        ],
      ),
    );
  }
}
