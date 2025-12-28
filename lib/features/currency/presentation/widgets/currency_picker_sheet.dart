import 'package:flutter/material.dart';
import '../../domain/entities/currency.dart';

Future<Currency?> showCurrencyPickerSheet({
  required BuildContext context,
  required List<Currency> currencies,
  String title = "Select currency",
}) {
  return showModalBottomSheet<Currency>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _CurrencyPickerSheet(
      title: title,
      currencies: currencies,
    ),
  );
}

class _CurrencyPickerSheet extends StatefulWidget {
  const _CurrencyPickerSheet({required this.title, required this.currencies});

  final String title;
  final List<Currency> currencies;

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  String q = "";

  @override
  Widget build(BuildContext context) {
    final filtered = q.isEmpty
        ? widget.currencies
        : widget.currencies.where((c) {
      final s = "${c.id} ${c.name}".toLowerCase();
      return s.contains(q.toLowerCase());
    }).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                autofocus: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search...",
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => q = v.trim()),
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final c = filtered[i];
                  return ListTile(
                    title: Text("${c.id} - ${c.name}"),
                    onTap: () => Navigator.pop(context, c),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
