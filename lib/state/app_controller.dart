import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/bill_item.dart';
import '../models/stamp.dart';
import '../models/user_account.dart';

class AppController extends ChangeNotifier {
  static final AppController _instance = AppController._internal();
  factory AppController() => _instance;
  AppController._internal();

  // Estado de Autenticação / Sessão
  bool isAuthenticated = false;
  UserAccount? currentUser;

  int currentTabIndex = 0;
  String activeCategory = 'Favoritos da Brasa';
  String searchQuery = '';

  // Lista de Pratos do Cardápio
  final List<Dish> dishes = [
    const Dish(
      id: 'costela_bbq',
      name: 'Costela BBQ Defumada 12h',
      tag: 'DEFUMADO & LENHA',
      portion: 'Serve 2 pessoas • 700g + Costela e Lado',
      price: 109.90,
      description:
          'Costela suína selecionada, marinada em especiarias artesanais e defumada lentamente em lenha de macieira por 12 horas. Glaceada com molho barbecue da casa levemente picante.',
      chefNote: 'Receita de assinatura: Carne macia desmanchando do osso e selada no braseiro.',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80',
      accompaniments: [
        'Arroz Carreteiro',
        'Mandioca na Manteiga de Garrafa',
        'Farofa Crocante de Castanha',
        'Vinagrete da Roça',
      ],
      extraSauces: [
        SauceOption(name: 'Chimichurri Brasileiro com Ervas Frescas', price: 7.00),
        SauceOption(name: 'Molho Lambão com Pimenta Biquinho', price: 4.50),
        SauceOption(name: 'Geléia de Pimenta Defumada da Casa', price: 6.00),
      ],
    ),
    const Dish(
      id: 'feijoada',
      name: 'Feijoada Completa da Casa',
      tag: 'CLÁSSICO BRASILEIRO',
      portion: 'Serve 5 a 6 pessoas',
      price: 89.90,
      description:
          'Tradicional feijoada em panela de barro com carnes nobres defumadas, arroz branco, couve refogada no alho, farofa crocante e torresmo pururuca.',
      imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
      accompaniments: ['Arroz Branco', 'Couve Refogada', 'Farofa Crocante'],
    ),
    const Dish(
      id: 'baiao',
      name: 'Baião de Dois do Sertão',
      tag: 'TRADIÇÃO NORDESTINA',
      portion: 'Serve 2 pessoas',
      price: 74.90,
      description:
          'Feijão de corda cozido em ponto de barro com carnes nobres desfiadas suculentas, arroz soltinho, queijo coalho tostado na brasa, manteiga de garrafa e cheiro-verde fresco.',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80',
    ),
    const Dish(
      id: 'escondidinho',
      name: 'Escondidinho de Carne Seca Gratinado',
      tag: 'FORNO & LENHA',
      portion: 'Individual generoso',
      price: 68.00,
      description:
          'Cremoso purê de mandioca com recheio farto de carne seca desfiada temperada com especiarias, gratinado com queijo parmesão e catupiry borbulhante.',
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80',
    ),
    const Dish(
      id: 'strogonoff',
      name: 'Strogonoff de Carne Tradicional',
      tag: 'PREFERIDO DA FAMÍLIA',
      portion: 'Serve 1 a 2 pessoas',
      price: 64.50,
      description:
          'Tiras de filé mignon grelhadas no fogo alto, molho cremoso com cogumelos frescos, acompanhado de arroz branco soltinho e batata palha artesanal ultra crocante.',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
    ),
    const Dish(
      id: 'chimarrao',
      name: 'Chimarrão Artesanal Gaúcho',
      tag: 'EXPERIÊNCIA DO SUL',
      portion: 'Cuia individual + Refil',
      price: 22.00,
      description:
          'Autêntica cuia tradicional de porongo com bomba de alpaca, erva-mate pura folha moída fresca e água aquecida no ponto exato da brasa. Refil livre.',
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80',
    ),
  ];

  // Comanda Digital
  final List<BillItem> billItems = [
    const BillItem(
      id: 'b1',
      name: '1x Feijoada Completa',
      quantity: 1,
      price: 89.90,
      subtitle: 'Acompanha arroz, couve e farofa',
      deliveryTime: 'Entregue às 20:05',
      category: 'Individual',
    ),
    const BillItem(
      id: 'b2',
      name: '1x Torresmo de Rolo',
      quantity: 1,
      price: 58.90,
      subtitle: 'Com geleia de pimenta da roça',
      deliveryTime: 'Entregue às 19:55',
      category: 'Petisco',
    ),
    const BillItem(
      id: 'b3',
      name: '1x Baião de Dois do Sertão',
      quantity: 1,
      price: 74.90,
      subtitle: 'Queijo coalho tostado & carne de sol',
      deliveryTime: 'Entregue às 20:12',
      category: 'Para 2 Pessoas',
    ),
    const BillItem(
      id: 'b4',
      name: '2x Chopp Puro Malte 500ml',
      quantity: 2,
      price: 37.00,
      subtitle: 'Caneca ultracongelada 500ml',
      deliveryTime: 'Entregue às 19:48',
      category: 'R\$ 18,50 cada',
    ),
  ];

  // Estado da Comanda / Pagamento
  double selectedTipPercentage = 12.0; // 0, 10, 12
  String selectedPaymentMethod = 'pix'; // 'pix', 'card', 'wallet'
  bool isPaid = false;
  bool isPaymentProcessing = false;

  // Estado da Câmera
  String selectedFilter = 'Fogo & Brasa';
  bool photoTaken = false;
  String? capturedPhotoPath;

  // Estado do Passaporte
  int completedStampsCount = 7; // sobe para 8 após foto
  bool rewardClaimed = false;

  // Getters de Cálculos da Conta
  double get subtotalItems => billItems.fold(0.0, (sum, item) => sum + item.price);
  double get tipAmount => (subtotalItems * selectedTipPercentage) / 100.0;
  double get pixDiscount => selectedPaymentMethod == 'pix' ? (subtotalItems * 0.05) : 0.0;
  double get totalAmount => subtotalItems + tipAmount - pixDiscount;

  void setTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  void setCategory(String category) {
    activeCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void setTipPercentage(double percentage) {
    selectedTipPercentage = percentage;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<void> processPayment() async {
    isPaymentProcessing = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    isPaymentProcessing = false;
    isPaid = true;
    currentTabIndex = 2; // Leva automaticamente para a tela de Câmera Social
    notifyListeners();
  }

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void takeSocialPhoto() {
    photoTaken = true;
    completedStampsCount = 8;
    notifyListeners();
  }

  void proceedToStamps() {
    currentTabIndex = 3; // Vai para Passaporte Fidelidade
    notifyListeners();
  }

  void claimReward() {
    rewardClaimed = true;
    notifyListeners();
  }

  // Lista de Contas Cadastradas (com senha para validação real)
  final List<Map<String, String>> _registeredAccounts = [
    {
      'name': 'Ycaro Ferreira',
      'email': 'ycaro@brasaviva.com',
      'phone': '(11) 98765-4321',
      'password': '123456',
    },
    {
      'name': 'Professor Avaliador',
      'email': 'professor@restaurante.com',
      'phone': '(11) 99999-8888',
      'password': 'admin',
    },
  ];

  // Métodos de Autenticação / Login com validação real de senha
  String? login({
    required String email,
    required String password,
    String? name,
    String tableNumber = 'Mesa 14',
  }) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPass = password.trim();

    // Busca conta correspondente
    final account = _registeredAccounts.firstWhere(
      (acc) => acc['email']?.toLowerCase() == cleanEmail || acc['phone'] == cleanEmail,
      orElse: () => {},
    );

    if (account.isEmpty) {
      return 'Conta não encontrada! Verifique o e-mail ou cadastre-se.';
    }

    if (account['password'] != cleanPass) {
      return 'Senha incorreta! Digite a senha cadastrada.';
    }

    final accountName = account['name'] ?? (name != null && name.trim().isNotEmpty ? name.trim() : 'Cliente VIP');

    currentUser = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: accountName,
      email: account['email'] ?? cleanEmail,
      phone: account['phone'] ?? '(11) 98765-4321',
      tableNumber: tableNumber,
      isGuest: false,
      stampsCount: completedStampsCount,
    );
    isAuthenticated = true;
    currentTabIndex = 0;
    notifyListeners();
    return null; // Sucesso
  }

  void loginAsGuest({
    String name = 'Convidado Mesa 14',
    String tableNumber = 'Mesa 14',
  }) {
    currentUser = UserAccount(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: 'convidado@mesa14.local',
      tableNumber: tableNumber,
      isGuest: true,
      stampsCount: completedStampsCount,
    );
    isAuthenticated = true;
    currentTabIndex = 0;
    notifyListeners();
  }

  void register({
    required String name,
    required String email,
    required String password,
    String phone = '',
    String tableNumber = 'Mesa 14',
  }) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim().isEmpty ? 'Novo Cliente' : name.trim();
    final cleanPass = password.trim();

    // Salva ou atualiza a conta
    final existingIndex = _registeredAccounts.indexWhere(
      (acc) => acc['email']?.toLowerCase() == cleanEmail,
    );

    final newAcc = {
      'name': cleanName,
      'email': cleanEmail,
      'phone': phone.trim(),
      'password': cleanPass,
    };

    if (existingIndex >= 0) {
      _registeredAccounts[existingIndex] = newAcc;
    } else {
      _registeredAccounts.add(newAcc);
    }

    currentUser = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: cleanName,
      email: cleanEmail,
      phone: phone.trim(),
      tableNumber: tableNumber,
      isGuest: false,
      stampsCount: completedStampsCount,
    );
    isAuthenticated = true;
    currentTabIndex = 0;
    notifyListeners();
  }

  bool resetPassword(String email, String newPassword) {
    final cleanEmail = email.trim().toLowerCase();
    final existingIndex = _registeredAccounts.indexWhere(
      (acc) => acc['email']?.toLowerCase() == cleanEmail,
    );
    if (existingIndex >= 0) {
      _registeredAccounts[existingIndex]['password'] = newPassword;
      return true;
    }
    return false;
  }

  void logout() {
    isAuthenticated = false;
    currentUser = null;
    currentTabIndex = 0;
    notifyListeners();
  }
}

