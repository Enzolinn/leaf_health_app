import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leaf_health_app/base64_image_widget.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    super.key,
    required this.base64String,
    required this.selectedImage,
    required this.clusterBase64,
    required this.doenca,
    required this.planta,
    required this.damage,
  });

  final String base64String;
  final File selectedImage;
  final String clusterBase64;
  final String planta;
  final String doenca;
  final double damage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalizedDamage = (damage / 100)
        .clamp(0, 1)
        .toDouble(); // garante faixa 0 - 1
    final Color severityColor = normalizedDamage > 0.6
        ? Colors.redAccent
        : normalizedDamage > 0.3
        ? Colors.orangeAccent
        : Colors.green;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F3),
      appBar: AppBar(title: const Text('Resultado da análise')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo da folha',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      label: 'Planta identificada',
                      value: planta,
                      icon: Icons.eco_outlined,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Doença inferida',
                      value: doenca,
                      icon: Icons.spa_outlined,
                      valueColor: Colors.red.shade600,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Dano na folha',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${damage.toStringAsFixed(1)}%',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: severityColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: severityColor.withValues(alpha: .14),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            _severityLabel(normalizedDamage),
                            style: TextStyle(
                              color: severityColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: normalizedDamage,
                        color: severityColor,
                        backgroundColor: severityColor.withValues(alpha: .15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _LabeledImageCard(
              title: 'Imagem original',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  selectedImage,
                  height: 320,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _LabeledImageCard(
              title: 'Máscara de clusters',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Base64ImageDisplay(base64String: clusterBase64),
              ),
            ),
            const SizedBox(height: 20),
            _LabeledImageCard(
              title: 'Regiões saudáveis',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Base64ImageDisplay(base64String: base64String),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.done_all),
              label: const Text('Voltar e iniciar outra análise'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _severityLabel(double normalizedDamage) {
    if (normalizedDamage > 0.6) return 'Crítico';
    if (normalizedDamage > 0.3) return 'Atenção';
    return 'Estável';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LabeledImageCard extends StatelessWidget {
  const _LabeledImageCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
