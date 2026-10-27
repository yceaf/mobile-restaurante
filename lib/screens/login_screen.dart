import 'package:flutter/material.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final AppController _controller = AppController();

  late TabController _tabController;

  // Controllers do Login
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  bool _loginObscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  // Controllers do Cadastro
  final TextEditingController _regNameController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPhoneController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();
  bool _regObscurePassword = true;
  bool _acceptTerms = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Pre-popula opcional para agilidade se desejado
    _loginEmailController.text = 'ycaro@brasaviva.com';
    _loginPasswordController.text = '123456';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _regNameController.dispose();
    _regEmailController.dispose();
    _regPhoneController.dispose();
    _regPasswordController.dispose();
    super.dispose();
  }

  void _showNotification(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? Colors.white : AppTheme.accentGold,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFC62828) : AppTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isError ? Colors.redAccent : AppTheme.primary.withOpacity(0.4),
          ),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    if (email.isEmpty) {
      _showNotification('Por favor, informe seu e-mail ou usuário', isError: true);
      return;
    }
    if (password.isEmpty) {
      _showNotification('Por favor, digite sua senha de acesso', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    final error = _controller.login(email: email, password: password);
    if (error != null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showNotification(error, isError: true);
      return;
    }
    // Sucesso: AppAuthWrapper desmonta LoginScreen automaticamente
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _handleRegister() async {
    final name = _regNameController.text.trim();
    final email = _regEmailController.text.trim();
    final phone = _regPhoneController.text.trim();
    final password = _regPasswordController.text.trim();

    if (name.isEmpty) {
      _showNotification('Informe seu nome completo', isError: true);
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showNotification('Informe um e-mail válido', isError: true);
      return;
    }
    if (password.length < 4) {
      _showNotification('A senha deve conter no mínimo 4 caracteres', isError: true);
      return;
    }
    if (!_acceptTerms) {
      _showNotification('Aceite os termos para criar sua conta', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    // register() chama notifyListeners() → AppAuthWrapper desmonta LoginScreen.
    _controller.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    // Após notifyListeners() o widget pode ter sido desmontado.
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    // loginAsGuest() chama notifyListeners() → AppAuthWrapper desmonta LoginScreen.
    _controller.loginAsGuest();
    // Após notifyListeners() o widget pode ter sido desmontado.
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _controller.register(
      name: 'Cliente $provider',
      email: 'usuario.${provider.toLowerCase()}@exemplo.com',
      password: 'social_login',
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _navigateToMain() {
    // A navegação é gerenciada pelo AppAuthWrapper no main.dart.
    // Quando AppController.login() / register() / loginAsGuest() chama
    // notifyListeners(), o AppAuthWrapper detecta isAuthenticated == true
    // e troca automaticamente para MainNavigationScreen via AnimatedSwitcher.
    // Não é necessário (nem possível) fazer Navigator.pop() aqui,
    // pois LoginScreen é a rota raiz.
  }

  void _showForgotPasswordDialog() {
    final recoveryEmailController = TextEditingController(text: _loginEmailController.text);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AppTheme.surfaceElevated,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: AppTheme.border, width: 1.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_reset, color: AppTheme.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Recuperar Senha',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Digite o e-mail cadastrado para enviarmos o código de redefinição imediato.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: recoveryEmailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.textMuted),
                  hintText: 'seuemail@exemplo.com',
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _showNotification('Instruções enviadas para ${recoveryEmailController.text.trim()}!');
                  },
                  child: const Text(
                    'ENVIAR LINK DE RECUPERAÇÃO',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Efeito de Fundo Decorativo com Fogo/Brasa
          Positioned(
            top: -100,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.18),
                    AppTheme.primary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentGold.withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Conteúdo Principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),

                  // Mesa Conectada Pill Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.accentGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'MESA 14 • SALÃO PRINCIPAL CONECTADO',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Logotipo Brasa Viva
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7A00), Color(0xFFD63B00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.35),
                          blurRadius: 22,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Nome da Marca
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'BRASA ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        TextSpan(
                          text: 'VIVA',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'STEAKHOUSE • CARDÁPIO & FIDELIDADE',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Abas: [Entrar] | [Cadastrar]
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6A00), Color(0xFFE65100)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppTheme.textSecondary,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Entrar na Conta'),
                        Tab(text: 'Criar Nova Conta'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Container das Abas
                  SizedBox(
                    height: 420,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildLoginForm(),
                        _buildRegisterForm(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Botão de Entrada Rápida como Convidado
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: InkWell(
                      onTap: _isLoading ? null : _handleGuestLogin,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.table_restaurant_outlined,
                                color: AppTheme.primaryLight,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Continuar como Convidado da Mesa 14',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Acesse o cardápio e comanda sem precisar de senha',
                                    style: TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppTheme.textMuted,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Rodapé de Segurança
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shield_outlined, color: AppTheme.textMuted, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Ambiente Seguro • Brasa Viva Gourmet v1.0',
                        style: TextStyle(
                          color: AppTheme.textMuted.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Loading Overlay se estiver autenticando
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Conectando à Mesa 14...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ================= FORMULÁRIO DE LOGIN =================
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo E-mail / Usuário
        _buildInputField(
          controller: _loginEmailController,
          label: 'E-mail ou Telefone',
          hint: 'ex: ycaro@brasaviva.com',
          icon: Icons.alternate_email_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),

        // Campo Senha
        _buildInputField(
          controller: _loginPasswordController,
          label: 'Senha',
          hint: 'Sua senha secreta',
          icon: Icons.lock_outline_rounded,
          obscureText: _loginObscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _loginObscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppTheme.textMuted,
              size: 20,
            ),
            onPressed: () => setState(() => _loginObscurePassword = !_loginObscurePassword),
          ),
        ),

        const SizedBox(height: 8),

        // Lembrar-me e Esqueci a Senha
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: AppTheme.primary,
                    checkColor: Colors.white,
                    side: const BorderSide(color: AppTheme.borderLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (val) => setState(() => _rememberMe = val ?? false),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Lembrar conta',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
            TextButton(
              onPressed: _showForgotPasswordDialog,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                'Esqueceu a senha?',
                style: TextStyle(
                  color: AppTheme.primaryLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Botão Principal de Login
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6A00), Color(0xFFE65100)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'ACESSAR MINHA CONTA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Divisor OU
        Row(
          children: [
            const Expanded(child: Divider(color: AppTheme.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OU CONECTE COM',
                style: TextStyle(
                  color: AppTheme.textMuted.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppTheme.border)),
          ],
        ),

        const SizedBox(height: 12),

        // Botões Sociais Google e Apple
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                title: 'Google',
                icon: Icons.g_mobiledata_rounded,
                iconColor: Colors.redAccent,
                onTap: () => _handleSocialLogin('Google'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSocialButton(
                title: 'Apple',
                icon: Icons.apple,
                iconColor: Colors.white,
                onTap: () => _handleSocialLogin('Apple'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= FORMULÁRIO DE CADASTRO =================
  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo Nome Completo
          _buildInputField(
            controller: _regNameController,
            label: 'Nome Completo',
            hint: 'ex: Ycaro Ferreira',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 10),

          // Campo E-mail
          _buildInputField(
            controller: _regEmailController,
            label: 'E-mail Principal',
            hint: 'seu@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),

          // Campo Telefone / WhatsApp
          _buildInputField(
            controller: _regPhoneController,
            label: 'WhatsApp / Celular',
            hint: '(11) 98765-4321',
            icon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),

          // Campo Senha
          _buildInputField(
            controller: _regPasswordController,
            label: 'Criar Senha de Acesso',
            hint: 'Mínimo de 4 dígitos',
            icon: Icons.lock_outline_rounded,
            obscureText: _regObscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _regObscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppTheme.textMuted,
                size: 20,
              ),
              onPressed: () => setState(() => _regObscurePassword = !_regObscurePassword),
            ),
          ),

          const SizedBox(height: 12),

          // Card Bônus de Fidelidade
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.badgeTagBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.badgeTagBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.military_tech_rounded, color: AppTheme.accentGold, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bônus do Clube: Ao criar sua conta você já ganha +1 carimbo no Passaporte Fidelidade!',
                    style: TextStyle(
                      color: AppTheme.textGold,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Termos de Uso Checkbox
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _acceptTerms,
                  activeColor: AppTheme.primary,
                  checkColor: Colors.white,
                  side: const BorderSide(color: AppTheme.borderLight),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Concordo com os Termos de Uso e Política de Privacidade do Restaurante',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Botão Cadastrar
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A3D), Color(0xFFFF6A00)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'CADASTRAR E RECEBER BENEFÍCIOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ================= COMPONENTES REUTILIZÁVEIS =================
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 18),
              suffixIcon: suffixIcon,
              hintText: hint,
              hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
