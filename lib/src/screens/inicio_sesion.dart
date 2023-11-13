import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:v1tesis/src/autenticacion/firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String nombre = '';
  String contra = '';
  bool showContra = false;
  bool _Iniciando = false;

  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  IconButton visibilityIconButton() {
    return IconButton(
      icon: Icon(showContra ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        setState(() {
          showContra = !showContra;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Añade un valor para el relleno.
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan[300]!, Colors.cyan[800]!],
              ),
            ),
            child: Image.asset(
              'assets/logo.png',
              width: 200,
              height: 150,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -100),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 240, bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          "Bienvenidos",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ----------------------------------- CORREO
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller:
                              _emailController, // Utiliza el controlador
                          decoration:
                              const InputDecoration(labelText: "Correo"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Este campo es obligatorio";
                            }
                            return null;
                          },
                        ),

                        // ----------------------------------- CONTRASEÑA
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            suffixIcon: IconButton(
                              icon: Icon(showContra
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  showContra = !showContra;
                                });
                              },
                            ),
                          ),
                          obscureText: !showContra,
                          controller:
                              _passwordController, // Utiliza el controlador
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Este campo es obligatorio";
                            }
                            return null;
                          },
                        ),

                        // ----------------------------------- BOTON LOGIN
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            _inicio();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.join_full),
                              const SizedBox(width: 8),
                              const Text('INICIAR SESION'),
                              if (_Iniciando)
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: const CircularProgressIndicator(),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // -------------------------- BOTON REGISTRAR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('¿No estás registrado?'),
                            const SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                _mostrarRegistro(context);
                              },
                              child: const Text(
                                "REGISTRATE",
                                style: TextStyle(
                                  color: Colors
                                      .blue, // Cambia el color del texto a azul
                                  decoration: TextDecoration
                                      .underline, // Subraya el texto para indicar que es un enlace
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Controlador de eventos para el botón de inicio de sesión 16/10

  void _inicio() async {
    setState(() {
      _Iniciando = true;
    });

    String correo = _emailController.text;
    String contra = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(correo, contra);

    setState(() {
      _Iniciando = false;
    });
    if (user != null) {
      print('Usuario iniciado');

      Navigator.pushNamed(context, '/home_page');
    } else {
      print('Error');
    }
  }

  void _mostrarRegistro(BuildContext context) {
    Navigator.of(context).pushNamed('/register');
  }

  void _homepage(BuildContext context) {
    Navigator.of(context).pushNamed('/home_page');
  }
}
