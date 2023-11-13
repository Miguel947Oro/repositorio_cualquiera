import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:v1tesis/src/screens/mapa_rutas.dart';

class AdditionalPage extends StatefulWidget {
  const AdditionalPage({Key? key}) : super(key: key);

  @override
  State<AdditionalPage> createState() => _AdditionalPageState();
}

class _AdditionalPageState extends State<AdditionalPage> {
  final _formKey = GlobalKey<FormState>();

  final firestore = FirebaseFirestore.instance;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _contactoController = TextEditingController();
  final TextEditingController _latitud2Controller = TextEditingController();
  final TextEditingController _longitud2Controller = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _placaController.dispose();
    _colorController.dispose();
    _marcaController.dispose();
    _contactoController.dispose();
    _latitud2Controller.dispose();
    _longitud2Controller.dispose();
    super.dispose();
  }

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
                                width: 240,
                                height: 200,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/adicional1.png'),
                                  ),
                                ),
                              ),
                              //----------------------------
                              const SizedBox(
                                height: 5,
                              ),
                              // --------------------------- CHOFER
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _nombreController,
                                decoration: const InputDecoration(
                                  labelText: "Nombre del chofer",
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-Z ]+$')),
                                ],
                              ),
                              // --------------------------- PLACA
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _placaController,
                                decoration: const InputDecoration(
                                  labelText: "Nro de Placa",
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-Z0-9]+$')),
                                ],
                              ),
                              // --------------------------- COLOR
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _colorController,
                                decoration: const InputDecoration(
                                  labelText: "Color del vehículo",
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-Z ]+$')),
                                ],
                              ),
                              // --------------------------- MARCA
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _marcaController,
                                decoration: const InputDecoration(
                                  labelText: "Marca del vehículo",
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-Z0-9]+$')),
                                ],
                              ),
                              // --------------------------- CONTACTO
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _contactoController,
                                decoration: const InputDecoration(
                                  labelText: "Contacto Persona Despachante",
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //-----------------------------Boton 1
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _homepage(context);
                                      // Muestra un mensaje indicando que la acción no se realizó
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('La acción no se realizó.'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: const Text('Volver'),
                                  ),
                                  //-----------------------------BOTON UBICACION 2
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_contactoController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Por favor, ingrese el contacto antes de obtener la ubicación.'),
                                          ),
                                        );
                                        return;
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        Position position =
                                            await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high,
                                        );

                                        // Abrir la pantalla de mapa
                                        var result =
                                            await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => MapScreen2(
                                              segundaCoordenadaLatitude:
                                                  position.latitude,
                                              segundaCoordenadaLongitude:
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
                                            _latitud2Controller.text =
                                                result['latitude'].toString();
                                            _longitud2Controller.text =
                                                result['longitude'].toString();
                                          });
                                        }
                                      } else {
                                        // Mostrar una alerta o un mensaje de error, ya que los campos del formulario no son válidos
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Por favor, complete el numero de celular y la ubicacion.'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text('Ubicacion'),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  //-------------------------------Boton 3
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_contactoController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Por favor, ingrese el contacto antes de registrar.'),
                                          ),
                                        );
                                        return;
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        _registrado();
                                        _homepage(context);
                                      }
                                    },
                                    child: const Text('Registrar'),
                                  ),
                                ],
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

  // Crear datos en firestore
  void _registrado() async {
    String nombre = _nombreController.text;
    String placa = _placaController.text;
    String color = _colorController.text;
    String marca = _marcaController.text;
    String contacto = _contactoController.text;
    String latitud = _latitud2Controller.text;
    String longitud = _longitud2Controller.text;

    if (contacto.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;

      // Realiza una transacción para obtener y actualizar el valor del contador del usuario
      await FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        // Obtiene la referencia al documento del contador en la colección 'usuarios' usando el UID del usuario
        DocumentReference userCounterRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('viajes')
            .doc('contador');

        // Obtiene el valor actual del contador del usuario
        DocumentSnapshot userCounterSnapshot =
            await transaction.get(userCounterRef);
        int currentCounter =
            userCounterSnapshot.exists ? userCounterSnapshot['valor'] ?? 0 : 0;

        // Genera el identificador único
        String idUnico = iduni(currentCounter);
        int cantidad = obtenerValorNumerico(currentCounter);

        // Agrega nuevos datos en Firestore sin especificar un ID en la subcolección 'viajes' del usuario
        transaction.set(userCounterRef,
            {'valor': currentCounter + 1}); // Actualiza el contador del usuario

        // Agrega los datos del servidor en la subcolección 'viajes' del usuario
        DocumentReference userViajesRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('viajes')
            .doc(idUnico); // Firestore generará un ID único automáticamente
        transaction.set(userViajesRef, {
          'viajeId': idUnico,
          'choferno': nombre,
          'placa': placa,
          'color': color,
          'marca': marca,
          'contacto': contacto,
          'nroviaje': cantidad,
          'latitud2': latitud,
          'longitud2': longitud,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Datos extra registrados'),
      ));
    }
  }

  String iduni(int contador) {
    // Puedes ajustar la lógica para generar un ID único con letra y número
    String letra = 'NV'; // Por ejemplo, 'S' para servidor
    String numero = (contador + 1)
        .toString()
        .padLeft(2, '0'); // Asegura que el número tenga al menos 2 dígitos

    return '$letra$numero';
  }

  int obtenerValorNumerico(int contador) {
    return contador + 1;
  }

  void _homepage(BuildContext context) {
    Navigator.of(context).pushNamed('/home_page');
  }
}
