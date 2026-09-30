import 'package:flutter/material.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with SingleTickerProviderStateMixin {
  final AppController _controller = AppController();
  bool _isFlashing = false;
  late AnimationController _pulseController;

  final List<String> _filters = ['Fogo & Brasa', 'Vintage 35mm', 'No Filter'];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChange);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  void _takeSnapshot() {
    setState(() => _isFlashing = true);
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() => _isFlashing = false);
        _controller.takeSocialPhoto();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF1E2F1E),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 20),
                SizedBox(width: 8),
                Text('Foto registrada com sucesso! 8º Selo liberado!'),
              ],
            ),
          ),
        );
      }
    });
  }

  ColorFilter? _getFilterMatrix(String filter) {
    if (filter == 'Fogo & Brasa') {
      // Tom quente alaranjado
      return const ColorFilter.matrix(<double>[
        1.25, 0, 0, 0, 15,
        0, 1.05, 0, 0, 5,
        0, 0, 0.85, 0, -10,
        0, 0, 0, 1, 0,
      ]);
    } else if (filter == 'Vintage 35mm') {
      // Sepia vintage
      return const ColorFilter.matrix(<double>[
        0.393, 0.769, 0.189, 0, 0,
        0.349, 0.686, 0.168, 0, 0,
        0.272, 0.534, 0.131, 0, 0,
        0, 0, 0, 1, 0,
      ]);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const CustomAppBar(title: 'Câmera Social'),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 40),
        children: [
          // Banner de Status da Conta
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C190A), Color(0xFF1E1308)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.badgeTagBorder, width: 1.2),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.celebration, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'CONTA PAGA • MESA 14 LIBERADA!',
                        style: TextStyle(
                          color: AppTheme.textGold,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Registre a mesa e libere seu brinde!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Falta só este clique para conquistar o 8º selo.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Viewfinder da Câmera (Simulador com Foto da Mesa e Overlays)
          Container(
            height: 380,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Imagem de Fundo (Amigos brindando com chopp na churrascaria)
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: _getFilterMatrix(_controller.selectedFilter) ??
                        const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF1E1E1E),
                          child: const Center(
                            child: Icon(Icons.group, color: AppTheme.primary, size: 64),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Gradientes de Sombra Superior e Inferior
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.0, 0.25, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),

                // Flash Effect
                if (_isFlashing)
                  Positioned.fill(
                    child: Container(color: Colors.white.withOpacity(0.9)),
                  ),

                // Header Superior da Câmera (AO VIVO e Nome da Mesa)
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tag AO VIVO com pulso vermelho
                      Row(
                        children: [
                          FadeTransition(
                            opacity: _pulseController,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'AO VIVO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.camera_alt, color: AppTheme.accentGold, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Câmera Social',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.flash_off, color: Colors.white70, size: 18),
                    ],
                  ),
                ),

                // Marca D'água da Mesa
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.badgeTagBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mesa 14 • Noite Épica de Riba & Cia',
                          style: TextStyle(
                            color: AppTheme.textGold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Salão Principal • Braseiro BBQ Oficial',
                          style: TextStyle(color: Colors.white70, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Seleção de Filtros Fotográficos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _filters.map((filter) {
              final isSelected = _controller.selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.surfaceElevated,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
                  ),
                  showCheckmark: false,
                  onSelected: (_) => _controller.setFilter(filter),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Controles de Disparo (Galeria, Shutter, Inverter)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Miniatura da Galeria
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 20),
              ),

              // Botão Principal de Disparo (Shutter)
              GestureDetector(
                onTap: _takeSnapshot,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.accentGold, width: 3),
                    gradient: const RadialGradient(
                      colors: [AppTheme.primary, AppTheme.primaryDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 30),
                  ),
                ),
              ),

              // Alternar Câmera / Timer
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Card Explicativo: "Como funciona o resgate?"
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.help_outline, color: AppTheme.accentGold, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Como funciona o resgate?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Ao registrar este clique, sua foto será fixada no Mural de Memórias da mesa e seu passaporte completará os 8 carimbos!',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Botões de Ação
          ElevatedButton(
            onPressed: () {
              _controller.takeSocialPhoto();
              _controller.proceedToStamps();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Salvar Foto & Carimbar Selo Final',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          TextButton(
            onPressed: () => _controller.proceedToStamps(),
            child: const Text(
              'Carimbar sem foto (Continuar)',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
