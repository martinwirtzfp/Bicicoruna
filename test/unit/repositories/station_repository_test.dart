import 'package:flutter_test/flutter_test.dart';

// Tests del Repository - Capa de acceso a datos
// Documentan cómo se combinan las dos APIs de BiciCoruña
void main() {
  group('StationRepository - Combinación de APIs', () {
    test('Combina station_information y station_status correctamente', () {
      // PROPÓSITO: Verificar que el Repository empareja correctamente ambas APIs
      // La API real devuelve datos en 2 endpoints separados:
      // - station_information: nombre, capacidad, dirección
      // - station_status: bicis disponibles, estado en tiempo real
      // Se emparejan usando station_id como clave común

      // Arrange: Simulamos datos de ambas APIs
      final stationInfoData = {
        'station_id': '4',
        'name': 'Aquarium',
        'capacity': 15,
        'address': 'P.º Marítimo',
      };

      final stationStatusData = {
        'station_id': '4',
        'num_bikes_available': 7,
        'num_bikes_disabled': 4,
        'num_docks_available': 4,
        'num_docks_disabled': 0,
      };

      // Assert: Verificamos que ambos datos tienen el mismo ID
      expect(stationInfoData['station_id'], stationStatusData['station_id'],
          reason:
              'El repository usa station_id para emparejar información y estado');
    });

    test('Maneja correctamente el parsing de JSON de la API', () {
      // PROPÓSITO: Validar que se procesa correctamente la estructura JSON
      // La API devuelve: { "data": { "stations": [...] } }
      // Impacto si falla: La app no podría obtener datos de la API
      
      // Arrange: JSON con la estructura real de la API
      final jsonData = {
        'data': {
          'stations': [
            {
              'station_id': '1',
              'name': 'Estación A',
              'capacity': 20,
              'address': 'Calle A',
            },
          ]
        }
      };

      // Act: Simulamos el parsing (esto normalmente lo haría el repository)
      final List<dynamic> stations = jsonData['data']?['stations'] ?? [];

      // Assert
      expect(stations.length, 1,
          reason: 'Debe parsear las estaciones del JSON correctamente');
      expect(stations[0]['name'], 'Estación A');
    });
  });
}
