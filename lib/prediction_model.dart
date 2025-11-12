class PredictionResponse {
  final String plant;
  final String disease;
  final String maskPngB64;
  final String clusterPngB64;
  final double damage;
  // Deixei 'scores' de fora por enquanto para simplificar,
  // mas podemos adicionar depois se você quiser exibir porcentagens.

  PredictionResponse({
    required this.plant,
    required this.disease,
    required this.maskPngB64,
    required this.clusterPngB64,
    required this.damage
  });

  // Este método "Factory" é o responsável por pegar o Map (JSON)
  // e converter para a nossa classe.
  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      // Usamos '??' como segurança: se o valor vier nulo, usamos um texto padrão.
      plant: json['plant'] ?? 'Desconhecida',
      disease: json['disease'] ?? 'Não identificada',
      maskPngB64: json['leaf_mask_b64'] ?? '',
      clusterPngB64: json['leaf_cluster_vis_b64'],
      damage: json['damage_amount'],
    );
  }
}
