import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:v1tesis/src/autenticacion/firebase_auth_services.dart';
import 'package:v1tesis/src/screens/mapa.dart';
import 'package:geolocator/geolocator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool showContra = false;
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _latitudController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();
  bool _iniciando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    super.dispose();
  }

  // ----- Para observar la contraseña -----
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

  // TODO
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.cyan[300]!,
                  Colors.cyan[800]!,
                ]),
              ),
              child: SizedBox(
                height: kToolbarHeight + 25,
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // --------------------------- IMAGEN
                              Container(
                                width: 140,
                                height: 80,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/img1.png'),
                                  ),
                                ),
                              ),
                              const Text("Registre los siguientes campos"),
                              //----------------------------
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "TODOS LOS CAMPOS SON OBLIGATORIOS",
                              ),
                              // --------------------------- USUARIO
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller:
                                    _nombreController, // Utiliza el controlador
                                decoration: const InputDecoration(
                                  labelText: "Nombre y Apellido",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Este campo es obligatorio";
                                  }
                                  if (!RegExp(r'^[a-zA-Z ]+$')
                                      .hasMatch(value)) {
                                    return "Solo se permiten letras y espacios";
                                  }
                                  return null;
                                },
                              ),

                              // --------------------------- CORREO
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller:
                                    _emailController, // Utiliza el controlador
                                decoration: const InputDecoration(
                                  labelText: "Correo Electrónico",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Este campo es obligatorio";
                                  }
                                  if (!RegExp(
                                          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                      .hasMatch(value)) {
                                    return "Ingresa una dirección de correo electrónico válida";
                                  }
                                  return null;
                                },
                              ),
                              // --------------------------- TELEFONO
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                controller:
                                    _telefonoController, // Utiliza el controlador
                                decoration: const InputDecoration(
                                  labelText: "Teléfono",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Este campo es obligatorio";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "Ingresa solo números";
                                  }
                                  return null;
                                },
                              ),
                              // --------------------------- Contraseña
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
                                  if (value!.length < 8 ||
                                      !value.contains(RegExp(r'[0-9]')) ||
                                      !value.contains(
                                          RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                                    return "La contraseña debe tener al menos 8 caracteres, incluir al menos un número y un carácter especial";
                                  }
                                  return null; // La contraseña cumple con los requisitos
                                },
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                              // --------------------------- UBICACION
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high,
                                    );

                                    // Abrir la pantalla de mapa
                                    var result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MapScreen(
                                          primeraCoordenadaLatitude:
                                              position.latitude,
                                          primeraCoordenadaLongitude:
                                              position.longitude,
                                        ),
                                      ),
                                    );

                                    // Manejar el resultado de MapScreen
                                    if (result != null &&
                                        result.containsKey('latitude') &&
                                        result.containsKey('longitude')) {
                                      // Actualizar la ubicación en la pantalla de registro con los datos retornados
                                      setState(() {
                                        _latitudController.text =
                                            result['latitude'].toString();
                                        _longitudController.text =
                                            result['longitude'].toString();
                                      });
                                    }
                                  } else {
                                    // Mostrar una alerta o un mensaje de error, ya que los campos del formulario no son válidos
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Por favor, complete todos los campos requeridos.'),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Ubicacion'),
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                              //-----------------------------REGISTRAR---------
                              ElevatedButton(
                                onPressed: () async {
                                  final position =
                                      await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.best,
                                  );
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    if (_iniciando) {
                                      Container(
                                        height: 20,
                                        width: 20,
                                        margin: const EdgeInsets.only(left: 10),
                                        child:
                                            const CircularProgressIndicator(),
                                      );
                                    }
                                    _registro();
                                    // Muestra el mensaje emergente "Usuario Registrado"
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Usuario registrado'),
                                    )); // Navega a la página de inicio de sesión
                                    _homepage;
                                  }
                                },
                                child: Text('Registrar'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registro() async {
    setState(() {
      bool _Iniciando = true;
    });

    String nombre = _nombreController.text;
    String telefono = _telefonoController.text;
    String correo = _emailController.text;
    String contra = _passwordController.text;
    String latitud = _latitudController.text;
    String longitud = _longitudController.text;

    // Obtén el UID del usuario actual
    User? user = await _auth.signUpWithEmailAndPassword(correo, contra);
    String uid = user?.uid ?? '';

    // Almacena los datos del usuario en Firestore usando el UID como ID del documento
    firestore.collection('usuarios').doc(uid).set({
      'usuario': nombre,
      'telefono': telefono,
      'correo': correo,
      'contra': contra,
      'latitud': latitud,
      'longitud': longitud,
    });

    setState(() {
      bool _Iniciando = false;
    });

    if (user != null) {
      print('Usuario creado con UID: $uid');
      _homepage(context);
    } else {
      print('Error');
    }
  }

  void _homepage(BuildContext) {
    Navigator.of(context).pushNamed('/home_page');
  }
}
