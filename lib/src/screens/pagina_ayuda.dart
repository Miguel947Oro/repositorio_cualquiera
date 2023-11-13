import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home_page');
          },
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Geolocalización:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'La geolocalización es el proceso de determinar la ubicación geográfica precisa de un objeto, persona o dispositivo utilizando tecnologías como el GPS (Sistema de Posicionamiento Global), redes móviles, Wi-Fi o sensores. Permite conocer las coordenadas geográficas (latitud y longitud) de un punto en particular.',
              ),
              SizedBox(height: 16),
              Text(
                'Seguridad:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'La seguridad se refiere a la protección y salvaguardia de personas, activos o información contra amenazas, peligros o riesgos. En el contexto de las aplicaciones, la seguridad se enfoca en garantizar la protección de los datos, la privacidad y la integridad de los sistemas y usuarios. En el ámbito de la seguridad con geolocalización, se utiliza la tecnología de ubicación en tiempo real para proporcionar servicios de seguimiento, alertas de seguridad, respuesta a emergencias y control de accesos.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
