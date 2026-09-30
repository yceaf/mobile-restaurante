import 'package:flutter/material.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class LoyaltyPassportScreen extends StatefulWidget {
  const LoyaltyPassportScreen({Key? key}) : super(key: key);

  @override
  State<LoyaltyPassportScreen> createState() => _LoyaltyPassportScreenState();
}

class _LoyaltyPassportScreenState extends State<LoyaltyPassportScreen> {
  final AppController _controller = AppController();

  final List<Map<String, dynamic>> _stamps = [
    {'date': '15/MAR', 'title': 'Mesa 08', 'type': 'Almoço Executivo'},
    {'date': '24/ABR', 'title': 'Mesa 12', 'type': 'Rodízio Brasa'},
    {'date': '12/FEV', 'title': 'Mesa 04', 'type': 'Happy Hour'},
    {'date': '05/MAI', 'title': 'Mesa 19', 'type': 'Picanha Nobre'},
    {'date': '19/MAI', 'title': 'Mesa 14', 'type': 'Costela BBQ'},
    {'date': '28/ABR', 'title': 'Mesa 07', 'type': 'Feijoada Casa'},
    {'date': '10/JUL', 'title': 'Mesa 03', 'type': 'Cortes Especiais'},
    {'date': 'HOJE', 'title': 'Mesa 14', 'type': 'Social BBQ'},
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  void _showRedeemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceElevated,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.stars, color: AppTheme.accentGold, size: 24),
              SizedBox(width: 8),
              Text(
                'Resgatar Brinde',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apresente este código para o Garçom Lucas na Mesa 14:',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.badgeTagBorder),
                ),
                child: const Center(
                  child: Text(
                    '#SERMANHA-8SELOS-2025',
                    style: TextStyle(
                      color: AppTheme.textGold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Escolha entre:\n• 1x Pudim de Leite Defumado na Brasa\n• 1x Tábua de Petiscos da Casa',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR', style: TextStyle(color: AppTheme.textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.claimReward();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFF1E2F1E),
                    content: Text('Brinde validado com o garçom! Em breve na sua mesa!'),
                  ),
                );
              },
              child: const Text('CONFIRMAR COM GARÇOM'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _controller.completedStampsCount >= 8;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const CustomAppBar(title: 'Passaporte Fidelidade'),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 40),
        children: [
          // Banner de Parabéns / Pitmaster
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF331D0E), Color(0xFF221206)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.badgeTagBorder, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.accentGold, width: 0.8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.workspace_premium, color: AppTheme.accentGold, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'PASSAPORTE COMPLETO',
                            style: TextStyle(
                              color: AppTheme.accentGold,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${_controller.completedStampsCount} / 8 SELOS',
                      style: const TextStyle(
                        color: AppTheme.textGold,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Parabéns, Pitmaster!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Você carimbou suas 8 visitas lendárias na brasa viva e destravou o brinde supremo.',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(Icons.local_fire_department, color: AppTheme.primary, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'TEMPORADA 2025 • Nível Mestre Churrasqueiro',
                      style: TextStyle(
                        color: AppTheme.textGold,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Grid com os 8 Selos
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Carimbos da Temporada',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Autenticado pelo Fogo da Casa',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    final stamp = _stamps[index];
                    final isStamped = index < _controller.completedStampsCount;

                    return Container(
                      decoration: BoxDecoration(
                        color: isStamped ? const Color(0xFF261A11) : AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isStamped ? AppTheme.primary : AppTheme.border,
                          width: isStamped ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isStamped ? AppTheme.primary : Colors.transparent,
                              border: Border.all(
                                color: isStamped ? AppTheme.accentGold : AppTheme.borderLight,
                              ),
                            ),
                            child: Center(
                              child: isStamped
                                  ? const Icon(Icons.local_fire_department, color: Colors.white, size: 20)
                                  : Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: AppTheme.textMuted,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            stamp['date'],
                            style: TextStyle(
                              color: isStamped ? Colors.white : AppTheme.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            stamp['title'],
                            style: TextStyle(
                              color: isStamped ? AppTheme.textGold : AppTheme.textMuted,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Card de Brinde Desbloqueado
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E1C10), Color(0xFF1E130B)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.badgeTagBorder, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.card_giftcard, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'BRINDE DESBLOQUEADO!',
                          style: TextStyle(
                            color: AppTheme.textGold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          'Pudim de Leite Defumado na Brasa ou Tábua de Petiscos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pudim artesanal de leite condensado tostado no forno a lenha com calda de caramelo âmbar e raspas de limão caipira.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.35),
                ),
                const SizedBox(height: 14),

                // Cupom de Resgate
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.badgeTagBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'CÓDIGO DO CUPOM DE MESA',
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '#SERMANHA-8SELOS-2025',
                            style: TextStyle(
                              color: AppTheme.textGold,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: AppTheme.primaryLight, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Código copiado com sucesso!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Botão de Resgate
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isComplete ? _showRedeemDialog : null,
                    icon: const Icon(Icons.restaurant, size: 16),
                    label: Text(
                      _controller.rewardClaimed ? 'BRINDE JÁ RESGATADO' : 'Resgatar Brinde com Garçom',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Mural das 8 Mesas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Mural das 8 Mesas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Momentos eternizados',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Carrossel de fotos das mesas
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildMuralCard(
                  imageUrl: 'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=500&q=80',
                  title: 'Churrascada Final',
                  date: '29 de Set, 2025',
                  mesa: 'HOJE • MESA 14',
                ),
                const SizedBox(width: 10),
                _buildMuralCard(
                  imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80',
                  title: 'Costela dos Campeões',
                  date: '10 de Jul, 2025',
                  mesa: 'MESA 03',
                ),
                const SizedBox(width: 10),
                _buildMuralCard(
                  imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=500&q=80',
                  title: 'Feijoada Completa',
                  date: '28 de Abr, 2025',
                  mesa: 'MESA 07',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuralCard({
    required String imageUrl,
    required String title,
    required String date,
    required String mesa,
  }) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.black.withOpacity(0.85)],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                mesa,
                style: const TextStyle(color: AppTheme.textGold, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
