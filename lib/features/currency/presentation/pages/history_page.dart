import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/currency.dart';
import '../bloc/currencies/currencies_bloc.dart';
import '../bloc/currencies/currencies_event.dart';
import '../bloc/currencies/currencies_state.dart';
import '../bloc/history/history_bloc.dart';
import '../bloc/history/history_event.dart';
import '../bloc/history/history_state.dart';
import '../widgets/currency_picker_sheet.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CurrenciesBloc>()..add(const CurrenciesRequested())),
        BlocProvider(create: (_) => getIt<HistoryBloc>()),
      ],
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatefulWidget {
  const _HistoryView();

  @override
  State<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<_HistoryView> {
  Currency? from;
  Currency? to;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrenciesBloc, CurrenciesState>(
      builder: (context, curState) {
        if (curState.status == CurrenciesStatus.loading || curState.status == CurrenciesStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (curState.status == CurrenciesStatus.failure) {
          return Center(child: Text(curState.error ?? "Failed to load currencies"));
        }

        final currencies = curState.all;
        from ??= currencies.isNotEmpty ? currencies.first : null;
        to ??= currencies.length > 1 ? currencies[1] : from;

        // أول تحميل للـ history لما يبقى عندي from/to
        if (from != null && to != null) {
          // نطلق request مرة واحدة فقط بعد build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<HistoryBloc>().add(HistoryRequested(from: from!.id, to: to!.id));
          });
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: _chip(
                      label: "From: ${from?.id ?? '-'}",
                      onTap: () async {
                        final picked = await showCurrencyPickerSheet(
                          context: context,
                          currencies: currencies,
                          title: "Select FROM currency",
                        );
                        if (picked != null) {
                          setState(() => from = picked);
                          context.read<HistoryBloc>().add(HistoryRequested(from: from!.id, to: to!.id));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _chip(
                      label: "To: ${to?.id ?? '-'}",
                      onTap: () async {
                        final picked = await showCurrencyPickerSheet(
                          context: context,
                          currencies: currencies,
                          title: "Select TO currency",
                        );
                        if (picked != null) {
                          setState(() => to = picked);
                          context.read<HistoryBloc>().add(HistoryRequested(from: from!.id, to: to!.id));
                        }
                      },
                    ),
                  ),
                  IconButton(
                    tooltip: "Reload",
                    onPressed: () {
                      if (from != null && to != null) {
                        context.read<HistoryBloc>().add(HistoryRequested(from: from!.id, to: to!.id));
                      }
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state.status == HistoryStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == HistoryStatus.failure) {
                    return Center(child: Text(state.error ?? "Failed to load history"));
                  }
                  if (state.rates.isEmpty) {
                    return const Center(child: Text("No history data"));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.rates.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final r = state.rates[i];
                      return ListTile(
                        title: Text(r.date),
                        trailing: Text(r.rate.toStringAsFixed(4)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _chip({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Text(label),
      ),
    );
  }
}
