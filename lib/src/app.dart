import 'package:flutter/material.dart';
import 'package:v1tesis/src/screens/pagina_adicional.dart';
import 'package:v1tesis/src/screens/pagina_ayuda.dart';
import 'package:v1tesis/src/screens/pagina_principal.dart';
import 'package:v1tesis/src/screens/inicio_sesion.dart';
import 'package:v1tesis/src/screens/pagina_registro.dart';
import 'package:v1tesis/src/screens/qr.dart';
import 'package:v1tesis/src/screens/tiempo_real.dart';

// definicion del material app

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      routes: {
        "/": (context) => const LoginPage(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan,
        hintColor: Colors.cyan[300]!,
      ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            // Login
            case "/login":
              return const LoginPage();
            // Principal
            case "/home_page":
              return const HomePage();
            // Registro
            case "/register":
              return const RegisterPage();
            // Help
            case "/help":
              return const HelpPage();
            // Adicional
            case "/additional":
              return const AdditionalPage();
            case "/real":
              return TimePage();
            case "/qrpage":
              return QrPage();
            // Mapa
            case "/map":
            //return const mapa();
            case "/map_routes":
            //return const mapa();
            default:
              // Mostrar una página de error o redireccionar a una ruta específica
              return const Text("error");
          }
        });
      },
    );
  }
}
