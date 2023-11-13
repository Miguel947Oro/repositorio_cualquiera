import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as directions;

class MapScreen2 extends StatefulWidget {
  final double segundaCoordenadaLatitude;
  final double segundaCoordenadaLongitude;

  const MapScreen2({
    required this.segundaCoordenadaLatitude,
    required this.segundaCoordenadaLongitude,
  });

  @override
  _MapScreen2State createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  late GoogleMapController _googleMapController;
  Marker? _origen;
  Marker? _destino;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    _mostrarOrigen();
    super.initState();
  }

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
              target: LatLng(-16.505433, -68.145165),
              zoom: 14,
            ),
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _marcadores(),
            polylines: _polylines,
            onTap: _seleccionarUbicacion2,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () => _trazarRutas(),
                  child: const Text('Trazar Rutas'),
                ),
              ),
              const SizedBox(
                  height: 1), // Ajusta la altura del espacio entre botones
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () => _guardarRegistro2(),
                  child: const Text('Confirmar'),
                ),
              ),
            ],
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

  // Obtener puntos guardados de la base de datos
  Future<List<LatLng>> _obtenerPuntos() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('usuarios').get();
      List<LatLng> puntos = [];

      for (var doc in snapshot.docs) {
        // Convertir las coordenadas de cadenas a números
        double lat = double.parse(doc['latitud']);
        double lng = double.parse(doc['longitud']);

        puntos.add(LatLng(lat, lng));
      }

      return puntos;
    } catch (e) {
      print('Error al obtener puntos desde Firestore: $e');
      return [];
    }
  }

  // Mostrar marcadores de origen desde la base de datos
  Future<void> _mostrarOrigen() async {
    List<LatLng> puntos = await _obtenerPuntos();
    if (puntos.isNotEmpty) {
      setState(() {
        _origen = Marker(
          markerId: const MarkerId('Origen'),
          infoWindow: const InfoWindow(title: 'Origen'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: puntos.first,
        );
      });
    }
  }

  // PRUEBA 2
  Set<Marker> _marcadores() {
    Set<Marker> markers = {};
    if (_origen != null) {
      markers.add(_origen!);
    }
    if (_destino != null) {
      markers.add(_destino!);
    }
    return markers;
  }

  CameraPosition _posicionActual() {
    return const CameraPosition(
      target: LatLng(-16.505433, -68.145165),
      zoom: 14,
    );
  }

  // Marcar un segundo punto con un marcador de color rojo
  void _seleccionarUbicacion2(LatLng pos) {
    setState(() {
      _destino = Marker(
        markerId: const MarkerId('Destino'),
        infoWindow: const InfoWindow(title: 'Destino'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      );
    });
  }

  // Guarda el registro
  Future<void> _guardarRegistro2() async {
    if (_destino != null) {
      try {
        // Retornar datos a la pantalla de registro
        Navigator.pop(context, {
          'latitude': widget.segundaCoordenadaLatitude,
          'longitude': widget.segundaCoordenadaLongitude
        });
      } catch (e) {
        print('Error al retornar datos desde MapScreen: $e');
      }
    } else {
      print('Por favor, selecciona una ubicación de origen en el mapa.');
    }
  }

  // Trazar rutas utilizando el servicio de direcciones de Google Maps
  void _trazarRutas() async {
    try {
      directions.GoogleMapsDirections directionsApi =
          directions.GoogleMapsDirections(
        apiKey:
            'AIzaSyBLlFjaXxbfHgSkpaK6TXcp6sepMMrK9cw', // Reemplaza con tu clave de API de Google Maps
      );

      directions.DirectionsResponse response =
          await directionsApi.directionsWithLocation(
        directions.Location(
            lat: _destino!.position.latitude,
            lng: _destino!.position.longitude),
        directions.Location(
            lat: _origen!.position.latitude, lng: _origen!.position.longitude),
        travelMode: directions.TravelMode.driving,
      );

      if (response.isOkay) {
        List<LatLng> rutaCoordinates =
            _decodePolyline(response.routes.first.overviewPolyline.points);

        Polyline ruta = Polyline(
          polylineId: PolylineId('ruta'),
          color: Colors.blue,
          points: rutaCoordinates,
        );

        setState(() {
          _polylines.add(ruta);
        });
      }
    } catch (e) {
      print('Error al trazar rutas: $e');
    }
  }

  // Decodificar las coordenadas de la polyline

  List<LatLng> _decodePolyline(String encoded) {
    List<PointLatLng> polylinePoints = PolylinePoints().decodePolyline(encoded);

    // Utilizar PointLatLng en lugar de PolylinePoint
    return polylinePoints
        .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
        .toList();
  }
}
