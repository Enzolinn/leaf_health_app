import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'prediction_provider.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _handleNavigation(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pages = [
      OverviewPage(
        key: const ValueKey('overview'),
        onStartScan: () => _handleNavigation(1),
      ),
      const ScanPage(key: ValueKey('scan')),
      const TipsPage(key: ValueKey('tips')),
    ];
    final titles = ['', 'Nova análise', 'Cuidados & dicas'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        backgroundColor: theme.colorScheme.primary.withValues(alpha: .12),

        // actions: _currentIndex == 0
        //     ? [
        //         IconButton(
        //           tooltip: 'Iniciar nova análise',
        //           onPressed: () => _handleNavigation(1),
        //           icon: const Icon(Icons.play_circle_outline),
        //         ),
        //       ]
        //     : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _handleNavigation,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            selectedIcon: Icon(Icons.document_scanner),
            label: 'Escanear',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.local_florist_outlined),
          //   selectedIcon: Icon(Icons.local_florist),
          //   label: 'Cuidados',
          // ),
        ],
      ),
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key, required this.onStartScan});

  final VoidCallback onStartScan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<PredictionProvider>();
    final prediction = provider.predictionResponse;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2F9E44), Color(0xFF52B788)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monitoramento inteligente',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Separe o processo em etapas claras, acompanhe resultados recentes e saiba exatamente o que fazer depois da análise.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                  ),
                  onPressed: onStartScan,
                  icon: const Icon(Icons.document_scanner),
                  label: const Text('Começar nova análise'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Última inspeção',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          prediction == null
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: .1,
                          ),
                          child: Icon(
                            Icons.qr_code_scanner,
                            color: theme.colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Nenhuma análise foi executada ainda. Capture uma folha e visualize informações de dano e máscaras segmentadas.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resultado mais recente',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _InfoBadge(
                          icon: Icons.eco_outlined,
                          label: 'Planta',
                          value: prediction.plant,
                        ),
                        const SizedBox(height: 12),
                        _InfoBadge(
                          icon: Icons.spa_outlined,
                          label: 'Doença',
                          value: prediction.disease,
                          valueColor: Colors.red.shade600,
                        ),
                        const SizedBox(height: 12),
                        _InfoBadge(
                          icon: Icons.shield_outlined,
                          label: 'Dano estimado',
                          value: '${prediction.damage.toStringAsFixed(1)}%',
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(height: 24),
          Text(
            'Fluxo recomendado',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const _ProcessStep(
            icon: Icons.photo_camera_back_outlined,
            title: '1. Capture em boa luz',
            description: 'Centralize a folha e evite sombras intensas.',
          ),
          const SizedBox(height: 10),
          const _ProcessStep(
            icon: Icons.auto_awesome_motion_outlined,
            title: '2. Destaque a área afetada',
            description: 'Garanta foco na região com danos visíveis.',
          ),
          const SizedBox(height: 10),
          const _ProcessStep(
            icon: Icons.insights_outlined,
            title: '3. Receba recomendações',
            description: 'Veja dano estimado e máscaras segmentadas.',
          ),
        ],
      ),
    );
  }
}

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PredictionProvider>();
    final theme = Theme.of(context);
    final hasImage = provider.selectedImage != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Envie uma nova foto',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Separe o fluxo: escolha a imagem, analise e visualize o resultado em outra tela dedicada.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _ImagePickerCard(
            hasImage: hasImage,
            selectedImage: provider.selectedImage,
            onTap: () => _showPicker(context),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.tonalIcon(
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Usar câmera'),
                onPressed: provider.isLoading
                    ? null
                    : () => provider.pickImage(ImageSource.camera),
              ),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Abrir galeria'),
                onPressed: provider.isLoading
                    ? null
                    : () => provider.pickImage(ImageSource.gallery),
              ),
            ],
          ),
          const SizedBox(height: 30),
          FilledButton.icon(
            icon: const Icon(Icons.science_outlined),
            label: const Text('Analisar imagem'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: hasImage && !provider.isLoading
                ? () => provider.uploadAndPredict()
                : null,
          ),
          const SizedBox(height: 20),
          if (provider.isLoading)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Analisando imagem, isso leva apenas alguns segundos...',
                    ),
                  ],
                ),
              ),
            ),
          if (provider.predictionResponse != null && !provider.isLoading)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resultado disponível',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Abra a página dedicada para visualizar máscaras, porcentagem de dano e recomendações.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Ver resultado detalhado'),
                      onPressed: () {
                        final response = provider.predictionResponse!;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultPage(
                              doenca: response.disease,
                              planta: response.plant,
                              selectedImage: provider.selectedImage!,
                              base64String: response.maskPngB64,
                              clusterBase64: response.clusterPngB64,
                              damage: response.damage,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Checklist rápido antes da captura',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _ChecklistItem(
                    text: 'Limpe a lente da câmera e aproxime-se da folha.',
                  ),
                  const _ChecklistItem(
                    text:
                        'Evite fundos com cores muito semelhantes à folha para facilitar a segmentação.',
                  ),
                  const _ChecklistItem(
                    text:
                        'Segure o aparelho com firmeza para evitar borrões na imagem.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext bc) {
        final provider = context.read<PredictionProvider>();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Escolher da galeria'),
                  onTap: () {
                    provider.pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Abrir câmera'),
                  onTap: () {
                    provider.pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tips = [
      const _TipCardData(
        icon: Icons.sunny,
        title: 'Capture em luz uniforme',
        description:
            'Prefira locais com luz natural indireta para evitar reflexos e sombras que confundem a segmentação.',
      ),
      const _TipCardData(
        icon: Icons.gradient,
        title: 'Use fundos contrastantes',
        description:
            'Coloque uma folha branca ou cinza claro atrás da folha para destacar melhor os danos.',
      ),
      const _TipCardData(
        icon: Icons.medication_liquid,
        title: 'Aja rapidamente',
        description:
            'Com o resultado em mãos, aplique o tratamento recomendado e registre o processo para criar um histórico.',
      ),
      const _TipCardData(
        icon: Icons.library_books_outlined,
        title: 'Crie um diário de análises',
        description:
            'Mantenha registros individuais das plantas para acompanhar evolução e comparar resultados.',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      itemBuilder: (context, index) {
        final tip = tips[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: .12,
                  ),
                  child: Icon(
                    tip.icon,
                    color: theme.colorScheme.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(tip.description, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: tips.length,
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
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
                  color: valueColor ?? theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProcessStep extends StatelessWidget {
  const _ProcessStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: .12),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(description),
      ),
    );
  }
}

class _ImagePickerCard extends StatelessWidget {
  const _ImagePickerCard({
    required this.hasImage,
    required this.selectedImage,
    required this.onTap,
  });

  final bool hasImage;
  final File? selectedImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: hasImage
              ? null
              : const LinearGradient(
                  colors: [Color(0xFFB7E4C7), Color(0xFF95D5B2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: hasImage ? Colors.white : null,
          border: Border.all(color: const Color(0xFFE0F2E9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(selectedImage!, fit: BoxFit.cover),
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.all(12),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Text(
                            'Trocar imagem',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.white,
                    size: 76,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Toque para selecionar a folha',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Organize cada etapa em uma tela dedicada',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _TipCardData {
  const _TipCardData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
