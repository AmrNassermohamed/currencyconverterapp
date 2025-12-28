import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/currency.dart';
import '../bloc/currencies/currencies_bloc.dart';
import '../bloc/currencies/currencies_event.dart';
import '../bloc/currencies/currencies_state.dart';


class CurrenciesPage extends StatelessWidget {
  const CurrenciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CurrenciesBloc>()..add(const CurrenciesRequested()),
      child: const _CurrenciesView(),
    );
  }
}

class _CurrenciesView extends StatelessWidget {
  const _CurrenciesView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: TextField(
            onChanged: (v) => context.read<CurrenciesBloc>().add(CurrenciesSearchChanged(v)),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search (USD, EGP, Euro...)",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<CurrenciesBloc, CurrenciesState>(
            builder: (context, state) {
              switch (state.status) {
                case CurrenciesStatus.initial:
                case CurrenciesStatus.loading:
                  return const Center(child: CircularProgressIndicator());

                case CurrenciesStatus.failure:
                  return _ErrorView(
                    message: state.error ?? "Failed to load currencies",
                    onRetry: () => context.read<CurrenciesBloc>().add(
                      const CurrenciesRequested(forceRefresh: true),
                    ),
                  );

                case CurrenciesStatus.success:
                  final list = state.filtered;

                  if (list.isEmpty) {
                    return const Center(child: Text("No currencies found"));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<CurrenciesBloc>().add(
                        const CurrenciesRequested(forceRefresh: true),
                      );
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) => _CurrencyTile(currency: list[i]),
                    ),
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({required this.currency});

  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final flagUrl =
        "https://flagcdn.com/w40/${currency.countryCode.toLowerCase()}.png";

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          flagUrl,
          width: 32,
          height: 24,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.flag_outlined),
        ),
      ),
      title: Text("${currency.id} - ${currency.name}"),
      subtitle: Text(currency.countryCode.toUpperCase()),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
