import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../core/di/service_locator.dart';
import '../../domain/entities/currency.dart';
import '../bloc/converter/converter_cubit.dart';
import '../bloc/converter/converter_state.dart';
import '../bloc/currencies/currencies_bloc.dart';
import '../bloc/currencies/currencies_event.dart';
import '../bloc/currencies/currencies_state.dart';
import '../widgets/currency_picker_sheet.dart';

class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CurrenciesBloc>()..add(const CurrenciesRequested())),
        BlocProvider(create: (_) => getIt<ConverterCubit>()),
      ],
      child: const _ConverterView(),
    );
  }
}

class _ConverterView extends StatefulWidget {
  const _ConverterView();

  @override
  State<_ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<_ConverterView> {
  Currency? from;
  Currency? to;
  final amountCtrl = TextEditingController(text: "1");

  @override
  void dispose() {
    amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrenciesBloc, CurrenciesState>(
      builder: (context, curState) {
        final list = curState.all; // full list

        if (curState!.status == CurrenciesStatus.loading || curState.status == CurrenciesStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (curState.status == CurrenciesStatus.failure) {
          return Center(child: Text(curState.error ?? "Failed to load currencies"));
        }

        // default selection
        from ??= list.isNotEmpty ? list.first : null;
        to ??= list.length > 1 ? list[1] : from;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _pickerTile(
                label: "From",
                value: from,
                onTap: () async {
                  final picked = await showCurrencyPickerSheet(
                    context: context,
                    currencies: list,
                    title: "Select FROM currency",
                  );
                  if (picked != null) setState(() => from = picked);
                },
              ),
              const SizedBox(height: 12),
              _pickerTile(
                label: "To",
                value: to,
                onTap: () async {
                  final picked = await showCurrencyPickerSheet(
                    context: context,
                    currencies: list,
                    title: "Select TO currency",
                  );
                  if (picked != null) setState(() => to = picked);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.currency_exchange),
                  label: const Text("Convert"),
                  onPressed: (from == null || to == null)
                      ? null
                      : () {
                    final amount = double.tryParse(amountCtrl.text.trim()) ?? 0;
                    context.read<ConverterCubit>().submit(
                      from: from!.id,
                      to: to!.id,
                      amount: amount,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ConverterCubit, ConverterState>(
                builder: (context, s) {
                  if (s.status == ConverterStatus.loading) {
                    return const CircularProgressIndicator();
                  }
                  if (s.status == ConverterStatus.failure) {
                    return Text(s.error ?? "Error", style: const TextStyle(color: Colors.red));
                  }
                  if (s.status == ConverterStatus.success) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text("Rate: ${s.rate}", style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 6),
                            Text(
                              "Result: ${s.result}",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Text("Pick currencies & amount then Convert");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pickerTile({
    required String label,
    required Currency? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: ListTile(
          title: Text(label),
          subtitle: Text(value == null ? "-" : "${value.id} - ${value.name}"),
          trailing: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
