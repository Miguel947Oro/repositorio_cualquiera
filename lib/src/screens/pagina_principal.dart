import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:v1tesis/src/autenticacion/firebase_auth_services.dart';

// DRAWER Y PRINCIPAL
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _boton1Realizado = false;

  String _nombreU = '';
  String _telefonoU = '';

  final firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _latitud2Controller = TextEditingController();
  final TextEditingController _longitud2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerDatosDesdeFirestore();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PRINCIPAL"),
        backgroundColor: Colors.cyan.shade400,
      ),
      drawer: _MyDrawer(context),
      body: _Principal(context),
    );
  }

  // -----------------Menú del costado
  Widget _MyDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.shade300,
                  Colors.cyan.shade600,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  "assets/usuario.png",
                  height: 100,
                  width: 100,
                ),
                const Text(
                  "Taxi - Radiotaxi - Seguro",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: const Text("INICIO"),
                leading: const Icon(Icons.home),
                onTap: () => _homepage(context),
              ),
              ListTile(
                title: const Text("AYUDA"),
                leading: const Icon(Icons.help_outline_rounded),
                onTap: () => _help(context),
              ),
              ListTile(
                title: const Text("SALIR"),
                leading: const Icon(Icons.subdirectory_arrow_left_rounded),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  salir(context);
                },
              ),
              // Separación entre los elementos de la lista y la imagen
              /*SizedBox(
                width: 150,
                height: 150,
                child: Image.network(
                  "https://i.gifer.com/GzKv.gif",
                  width: 150,
                  height: 150,
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  // ----------------- BOTON 3 salir de la pagina principal
  void salir(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de que deseas salir?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salir'),
              onPressed: () {
                _login(context);
              },
            ),
          ],
        );
      },
    );
  }

  // CUERPO DE LA APP
  Widget _Principal(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ----------------------------------- Imagen de Taxi
            Container(
              width: double.infinity,
              height: 300,
              child: Image.asset(
                "assets/taxi.png",
                fit: BoxFit.contain, // Ajusta la imagen sin estirarla
              ),
            ),
            const SizedBox(height: 16),
            // ----------------------------------- Nombre de Usuario
            Text(
              'Nombre: $_nombreU',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Teléfono: $_telefonoU',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 14),
            // ----------------------------------- MAPA
            InkWell(
              onTap: () {
                // Coloca aquí el código que deseas ejecutar al hacer clic en la imagen
                _real(context);
                print('Imagen cliclada');
              },
              child: Container(
                width: 200.0,
                height: 200.0,
                child: Center(
                  child: Image.asset(
                    "assets/map.png", // Reemplaza con la URL de tu imagen
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            //IMAGEN DE MAPA!
            //---------------------------------- Botones
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // -------------------------BOTON 1 DATOS ADICIONALES MAPA
                ElevatedButton(
                  onPressed: () {
                    adicional(context);
                  },
                  child: const Text('DATOS ADICIONALES'),
                ),
                //---------------------------BOTON 2 QR
                /*ElevatedButton(
                  onPressed: () {
                    if (_boton1Realizado) {
                      _generarQR(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Primero debes realizar la geolocalizacion'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('GENERAR QR'),
                ),*/
                ElevatedButton(
                  onPressed: () {
                    _qrpage(context);
                  },
                  child: Text('GENERAR QR'),
                )
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Obtener datos
  Future<String?> obtenerDatosDesdeFirestore() async {
    FirebaseAuthService authService = FirebaseAuthService();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        DocumentSnapshot snapshot =
            await firestore.collection('usuarios').doc(uid).get();

        if (snapshot.exists) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;

          setState(() {
            _nombreU = userData['usuario'];
            _telefonoU = userData['telefono'];
          });

          // Devuelve el UID
          return uid;
        } else {
          print(
              'No se encontraron datos en Firestore para el usuario con UID $uid');
          return null;
        }
      } catch (e) {
        print('Error al obtener datos de Firestore: $e');
        return null;
      }
    }

    return null; // Devuelve null si no hay usuario autenticado
  }

  // DATOS PARA NAVEGAR ENTRE LAS PAGINAS
  void adicional(BuildContext context) {
    Navigator.of(context).pushNamed('/additional');
  }

  void _homepage(BuildContext context) {
    Navigator.of(context).pushNamed('/home_page');
  }

  void _login(BuildContext context) {
    Navigator.of(context).pushNamed('/login');
  }

  void _help(BuildContext context) {
    Navigator.of(context).pushNamed('/help');
  }

  void _real(BuildContext) {
    Navigator.of(context).pushNamed('/real');
  }

  void _qrpage(BuildContext) {
    Navigator.of(context).pushNamed('/qrpage');
  }

  // ----------------- GENERAR UBICACION
  //void _generarUbicacion() {}
  // ----------------- GENERAR QR
  void _generarQR(BuildContext context) {}
  // ------------------ MOSTRAR DATOS ADICIONALES
}
