# 📱 Brasa Viva • Mesa 14 (Cardápio, Comanda & Câmera Social)

Projeto desenvolvido fielmente com base no protótipo Figma, simulando a experiência completa de atendimento móvel para clientes de restaurante e churrascaria na **Mesa 14**.

---

## 🎯 Telas Implementadas

1. **Cardápio Digital (`menu_screen.dart`):**
   - Cabeçalho com indicador de mesa ativa (`MESA 14 • SALÃO PRINCIPAL`).
   - Banner de fidelidade com contagem de selos (`PASSPORTE DO FOGO • 7/8 selos`).
   - Barra de busca dinâmica e filtros por categorias (Favoritos, Cortes Nobres, etc.).
   - Cards com fotos, badges temáticos (*Clássico Brasileiro*, *Tradição Nordestina*, *Defumado & Lenha*), porções, preços e botão `+ Pedir`.
   - Mini-barra flutuante inferior indicando comanda coletiva ativa.

2. **Detalhes do Prato & Customização (`dish_detail_screen.dart`):**
   - Imagem em destaque com gradiente e badge *Defumado & Lenha*.
   - Costela BBQ Defumada 12h, especificações de gramatura e receita de assinatura.
   - Seleção obrigatória de acompanhamento (Arroz Carreteiro, Mandioca, Farofa, Vinagrete).
   - Checkboxes de molhos adicionais com recálculo de preço em tempo real.
   - Campo de observações para a cozinha e seletor de quantidade com botão dinâmico de adicionar.

3. **Pagamento da Conta / Comanda (`bill_screen.dart`):**
   - Detalhamento de todos os itens consumidos na mesa com horário de entrega e garçom responsável.
   - Seletor interativo de taxa de serviço do garçom (0%, 10% ou 12%).
   - Cálculo automático de subtotal, gorjeta e desconto PIX (5% OFF).
   - Opções de pagamento: PIX com modal de QR Code e Copia-e-Cola, Cartão e Carteiras Digitais.
   - Botão de pagamento integrado que redireciona automaticamente para a Câmera Social.

4. **Câmera Social da Mesa (`camera_screen.dart`):**
   - Viewfinder interativo simulando a foto da galera na churrascaria.
   - Marca d'água oficial (`Mesa 14 • Noite Épica de Riba & Cia`).
   - Filtros de imagem em tempo real: *Fogo & Brasa* (tom quente), *Vintage 35mm* e *No Filter*.
   - Botão disparador (shutter) com efeito visual de flash.
   - Fluxo de salvamento que autentica e carimba o 8º selo.

5. **Passaporte Fidelidade (`loyalty_passport_screen.dart`):**
   - Banner comemorativo de conquista (*Pitmaster • 8/8 Selos*).
   - Grade com os 8 selos da temporada carimbados e datados.
   - Voucher promocional desbloqueado (`#SERMANHA-8SELOS-2025`) com botão de cópia.
   - Modal de validação e resgate com o garçom.
   - Mural de memórias fotográficas das visitas anteriores.

---

## 🚀 Como Visualizar no GitHub Pages (Para os Professores)

O projeto já contém o arquivo `index.html` e a pasta `docs/` prontos para hospedar no GitHub Pages sem precisar compilar nada:

1. Suba este repositório para o seu GitHub:
   ```bash
   git init
   git add .
   git commit -m "feat: Projeto Mesa 14 mobile completo"
   git branch -M main
   git remote add origin https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git
   git push -u origin main
   ```
2. No GitHub do repositório, clique em **Settings** (Configurações) > **Pages** (no menu lateral esquerdo).
3. Em **Build and deployment** > **Source**, selecione **Deploy from a branch**.
4. Em **Branch**, selecione `main` e a pasta `/ (root)` ou `/docs` e clique em **Save**.
5. Aguarde cerca de 1 a 2 minutos e o GitHub fornecerá o link público (ex: `https://seu-usuario.github.io/seu-repositorio/`) para enviar aos seus professores! Eles poderão testar todas as 5 telas interativamente pelo celular ou pelo computador.

---

## 🛠️ Como Abrir e Rodar no Android Studio (Flutter)

1. Extraia o arquivo `.zip` ou abra a pasta no **Android Studio**.
2. O Android Studio reconhecerá automaticamente como projeto **Flutter**.
3. No terminal ou pela interface do Android Studio:
   ```bash
   flutter pub get
   flutter run
   ```
4. Escolha um emulador Android ou seu dispositivo físico conectado via USB.

---

## 📁 Estrutura de Pastas do Flutter

```
projeto_camera/
├── android/                  # Configurações nativas do Android
├── lib/
│   ├── main.dart             # Ponto de entrada do aplicativo
│   ├── theme/
│   │   └── app_theme.dart    # Paleta de cores escura, tons de brasa e tipografia
│   ├── models/
│   │   ├── dish.dart         # Modelos de prato e molhos
│   │   ├── bill_item.dart    # Modelo de itens da comanda
│   │   └── stamp.dart        # Modelo de selos do passaporte
│   ├── state/
│   │   └── app_controller.dart # Gerenciamento de estado (carrinho, gorjeta, filtros)
│   ├── widgets/
│   │   ├── custom_app_bar.dart # Barra superior personalizada da mesa
│   │   └── dish_card.dart      # Card de comida com badges e botão de pedido
│   └── screens/
│       ├── main_navigation_screen.dart # Navegação inferior (BottomNav)
│       ├── menu_screen.dart            # Tela 1: Cardápio
│       ├── dish_detail_screen.dart     # Tela 5: Detalhes do Prato
│       ├── bill_screen.dart            # Tela 2: Comanda e Pagamento
│       ├── camera_screen.dart          # Tela 3: Câmera Social
│       └── loyalty_passport_screen.dart# Tela 4: Passaporte Fidelidade
├── test/
├── docs/                     # Suporte nativo para GitHub Pages
├── index.html                # Aplicação web standalone para visualização direta
└── pubspec.yaml              # Dependências e metadados do projeto Flutter
```
