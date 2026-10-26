import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'state/app_controller.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const BrasaVivaApp());
}

class BrasaVivaApp extends StatelessWidget {
  const BrasaVivaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brasa Viva • Mesa 14',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppAuthWrapper(),
    );
  }
}

class AppAuthWrapper extends StatefulWidget {
  const AppAuthWrapper({Key? key}) : super(key: key);

  @override
  State<AppAuthWrapper> createState() => _AppAuthWrapperState();
}

class _AppAuthWrapperState extends State<AppAuthWrapper> {
  final AppController _controller = AppController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _controller.isAuthenticated
          ? const MainNavigationScreen(key: ValueKey('main_nav'))
          : const LoginScreen(key: ValueKey('login_screen')),
    );
  }
}
