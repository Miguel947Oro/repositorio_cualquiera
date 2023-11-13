import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double primeraCoordenadaLatitude;
  final double primeraCoordenadaLongitude;

  const MapScreen({
    required this.primeraCoordenadaLatitude,
    required this.primeraCoordenadaLongitude,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _googleMapController;
  Marker? _origen;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: const CameraPosition(
                target: LatLng(-16.504817, -68.140178), zoom: 14),
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _marcadorOrigen(),
            onTap: _seleccionarUbicacion,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () => _guardarRegistros(),
              child: const Text('Confirmar'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_posicionActual()),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  // TODO PARA ORIGEN
  // MARCADOR
  Set<Marker> _marcadorOrigen() {
    Set<Marker> markers = {};
    if (_origen != null) {
      markers.add(_origen!);
    }
    return markers;
  }

  // POSISCION ORIGEN
  CameraPosition _posicionActual() {
    return const CameraPosition(
      target: LatLng(-16.504817, -68.140178),
      zoom: 14,
    );
  }

  // SELLECIONA UBICACION PARA ORIGEn
  // GUARDA LA SELECCION DEL DISPOSITIVO SIN LA NECESIDAD DEL PUNTERO LO MAS CERCA
  void _seleccionarUbicacion(LatLng pos) {
    setState(() {
      _origen = Marker(
        markerId: const MarkerId('Origen'),
        infoWindow: const InfoWindow(title: 'Origen'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
    });
  }

  // GUARDA EL PUNTERO DE ORIGEN
  // ACA TUILIZO EL -SELECCIONAR UBICACION Y ME DA LAS OTRAS COORDENADAS
  Future<void> _guardarRegistro() async {
    if (_origen != null) {
      try {
        // Retornar datos a la pantalla de registro
        Navigator.pop(context, {
          'latitude': widget.primeraCoordenadaLatitude,
          'longitude': widget.primeraCoordenadaLongitude,
        });
      } catch (e) {
        print('Error al retornar datos desde MapScreen: $e');
      }
    } else {
      print('Por favor, selecciona una ubicación de origen en el mapa.');
    }
  }

  LatLng? obtenerCoordenadasMarcador() {
    if (_origen != null && _origen!.position != null) {
      return _origen!.position;
    }
    return null;
  }

  Future<void> _guardarRegistros() async {
    LatLng? coordenadasMarcador = obtenerCoordenadasMarcador();

    if (coordenadasMarcador != null) {
      try {
        // Retornar datos a la pantalla de registro
        Navigator.pop(context, {
          'latitude': coordenadasMarcador.latitude,
          'longitude': coordenadasMarcador.longitude,
        });
      } catch (e) {
        print('Error al retornar datos desde MapScreen: $e');
      }
    } else {
      print('Por favor, selecciona una ubicación de origen en el mapa.');
    }
  }
}
