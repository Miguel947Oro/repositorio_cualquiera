/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:v1tesis/src/autenticacion/firebase_auth_services.dart';

class QrPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('QR'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<Map<String, dynamic>?>(
                // Llamada a la función para obtener datos del primer viaje
                future: obtenerDatosDelPrimerViajeDesdeFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Mientras se espera la respuesta de la función
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Si hay un error
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    // Si no se encuentra ningún dato
                    return Text('No se encontraron datos');
                  } else {
                    // Mostrar datos del primer viaje
                    String choferno = snapshot.data!['choferno'];
                    String color = snapshot.data!['color'];
                    String contacto = snapshot.data!['contacto'];
                    double latitud = snapshot.data!['latitud'];
                    double longitud = snapshot.data!['longitud'];
                    String marca = snapshot.data!['marca'];

                    return Column(
                      children: <Widget>[
                        Text("Chofer: $choferno"),
                        Text("Color: $color"),
                        Text("Contacto: $contacto"),
                        Text("Latitud: $latitud"),
                        Text("Longitud: $longitud"),
                        Text("Marca: $marca"),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?>
      obtenerDatosDelPrimerViajeDesdeFirestore() async {
    FirebaseAuthService authService = FirebaseAuthService();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        // Obtener la referencia a la colección 'viajes' dentro del documento del usuario
        CollectionReference viajesCollection =
            firestore.collection('usuarios').doc(uid).collection('viajes');

        // Obtener el primer documento de la colección 'viajes'
        QuerySnapshot viajesQuery = await viajesCollection.limit(1).get();

        if (viajesQuery.docs.isNotEmpty) {
          // Obtener los datos del primer viaje
          Map<String, dynamic> primerViajeData =
              viajesQuery.docs.first.data() as Map<String, dynamic>;

          // Devolver los datos del primer viaje
          return {
            'choferno': primerViajeData['choferno'],
            'color': primerViajeData['color'],
            'contacto': primerViajeData['contacto'],
            'latitud': primerViajeData['latitud2'],
            'longitud': primerViajeData['longitud2'],
            'marca': primerViajeData['marca'],
          };
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
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:v1tesis/src/autenticacion/firebase_auth_services.dart';

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  String choferno = '';
  String color = '';
  int contacto = 0;
  String latitud2 = '';
  String longitud2 = '';
  String marca = '';
  int nroviaje = 0;
  String placa = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generador de Código QR'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: obtenerDatos(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data != null) {
              Map<String, dynamic> viajeData = snapshot.data!;
              String jsonData = viajeData.toString();

              return QrImageView(
                data: jsonData,
                version: QrVersions.auto,
                size: 200.0,
              );
            } else {
              return Text('No se encontraron datos');
            }
          },
        ),
      ),
    );
  }

  /*Future<Map<String, dynamic>?> obtenerDatos() async {
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

          // Verifica si hay una subcolección 'viajes'
          if (userData.containsKey('viajes')) {
            // Obtiene los datos de la subcolección 'viajes'
            QuerySnapshot viajesSnapshot =
                await firestore.collection('usuarios/$uid/viajes').get();

            // Verifica si hay documentos en la subcolección 'viajes'
            if (viajesSnapshot.docs.isNotEmpty) {
              // Tomamos solo el primer documento, puedes ajustarlo según tus necesidades
              Map<String, dynamic> viajeData =
                  viajesSnapshot.docs.first.data() as Map<String, dynamic>;

              // Actualiza el estado con los datos del viaje
              setState(() {
                choferno = viajeData['choferno'] ?? '';
                color = viajeData['color'] ?? '';
                contacto = viajeData['contacto'] ?? 0;
                latitud2 = viajeData['latitud2'] ?? '';
                longitud2 = viajeData['longitud2'] ?? '';
                marca = viajeData['marca'] ?? '';
                nroviaje = viajeData['nroviaje'] ?? 0;
                placa = viajeData['placa'] ?? '';
              });

              // Devuelve los datos del viaje
              return viajeData;
            } else {
              print(
                  'La subcolección "viajes" está vacía para el usuario con UID $uid');
              return null;
            }
          } else {
            print(
                'No se encontró la subcolección "viajes" para el usuario con UID $uid');
            return null;
          }
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
  }*/

  Future<Map<String, dynamic>> obtenerDatos() async {
    // Puedes modificar este método para obtener datos de donde quieras (Firebase, etc.)
    choferno = 'Juan';
    color = 'Plata';
    contacto = 78945612;
    latitud2 = '-16.509312';
    longitud2 = '-68.135758';
    marca = 'VW';
    nroviaje = 1;
    placa = '4574TAS';

    // Devuelve los datos en forma de mapa
    return {
      'choferno': choferno,
      'color': color,
      'contacto': contacto,
      'latitud2': latitud2,
      'longitud2': longitud2,
      'marca': marca,
      'nroviaje': nroviaje,
      'placa': placa,
    };
  }
}
/*
  void obtenerDatos1() {
    choferno = 'Pedro';
    color = 'ROJO';
    contacto = 78123742;
    latitud2 = (-16.515798) as String;
    longitud2 = (-68.139418) as String;
    marca = 'TOYOTA';
    nroviaje = 1;
    placa = '4232TSS';
  }

  void obtenerDatos2() {
    choferno = 'German';
    color = '';
    contacto = 78945612;
    latitud2 = (-16.509707) as String;
    longitud2 = (-68.142033) as String;
    marca = '';
    nroviaje = 2;
    placa = '4785QSD';
  }
*/
  
