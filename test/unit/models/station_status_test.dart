import 'package:flutter_test/flutter_test.dart';
import 'package:bicicoruna/models/station_status.dart';

void main() {
  group('StationStatus - Parsing de tipos de bicicletas', () {
    test('Parsea correctamente tipos de bicis FIT, EFIT y BOOST', () {
      // PROPÓSITO: Verificar que el modelo clasifica correctamente los tipos de bicicletas
      // FIT = bicicletas mecánicas
      // EFIT y BOOST = bicicletas eléctricas
      
      // Arrange: JSON simulado tal como lo devuelve la API de BiciCoruña
      final json = {
        'station_id': '4',
        'num_bikes_available': 7,
        'num_bikes_disabled': 4,
        'num_docks_available': 4,
        'num_docks_disabled': 0,
        'last_reported': 1768427178,
        'vehicle_types_available': [
          {'vehicle_type_id': 'FIT', 'count': 3},
          {'vehicle_type_id': 'EFIT', 'count': 2},
          {'vehicle_type_id': 'BOOST', 'count': 2},
        ],
      };

      // Act: Parseamos el JSON
      final stationStatus = StationStatus.fromJson(json);

      // Assert: Verificamos que los tipos se clasifican correctamente
      // FIT = mecánica (3)
      // EFIT + BOOST = eléctricas (2 + 2 = 4)
      expect(stationStatus.numBikesMechanic, 3,
          reason: 'FIT debe contar como bici mecánica');
      expect(stationStatus.numBikesElectric, 4,
          reason: 'EFIT + BOOST deben sumar como bicis eléctricas');
    });

    test('El total de bicis disponibles coincide con la suma de tipos', () {
      // PROPÓSITO: Validar que no haya inconsistencias en los datos
      // La suma de bicis mecánicas + eléctricas debe igualar el total disponible
      
      // Arrange: JSON con bicis de ambos tipos
      final json = {
        'station_id': '10',
        'num_bikes_available': 5,
        'num_bikes_disabled': 0,
        'num_docks_available': 10,
        'num_docks_disabled': 0,
        'last_reported': 1768427178,
        'vehicle_types_available': [
          {'vehicle_type_id': 'FIT', 'count': 2},
          {'vehicle_type_id': 'EFIT', 'count': 1},
          {'vehicle_type_id': 'BOOST', 'count': 2},
        ],
      };

      // Act
      final stationStatus = StationStatus.fromJson(json);

      // Assert: La suma de mecánicas + eléctricas debe ser igual al total
      final sumaTipos =
          stationStatus.numBikesMechanic + stationStatus.numBikesElectric;
      expect(sumaTipos, stationStatus.numBikesAvailable,
          reason:
              'La suma de bicis mecánicas y eléctricas debe coincidir con el total disponible');
    });

    test('Convierte timestamp Unix a DateTime correctamente', () {
      // PROPÓSITO: Asegurar que las fechas se convierten bien desde el formato Unix
      // La API devuelve timestamps Unix (segundos desde 1970)
      // Necesitamos convertirlos a DateTime para mostrar "hace X minutos"
      
      // Arrange: Timestamp Unix de ejemplo (14 enero 2026)
      final json = {
        'station_id': '3',
        'num_bikes_available': 1,
        'num_bikes_disabled': 0,
        'num_docks_available': 28,
        'num_docks_disabled': 0,
        'last_reported': 1768427178, // Unix timestamp en segundos
        'vehicle_types_available': [
          {'vehicle_type_id': 'FIT', 'count': 1},
        ],
      };

      // Act
      final stationStatus = StationStatus.fromJson(json);

      // Assert: Verificamos que se convirtió correctamente
      expect(stationStatus.lastReported, isA<DateTime>(),
          reason: 'last_reported debe ser un DateTime');

      // Verificamos que el año sea 2026 (esperado del timestamp)
      expect(stationStatus.lastReported.year, 2026,
          reason: 'El timestamp debe convertirse al año correcto');
    });
  });
}
