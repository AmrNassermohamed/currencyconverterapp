import 'package:flutter/material.dart';
import 'currencies_page.dart';
import 'converter_page.dart';
import 'history_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Currency Converter"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Currencies"),
              Tab(text: "Convert"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CurrenciesPage(),
            ConverterPage(),
            HistoryPage(),
          ],
        ),
      ),
    );
  }
}
