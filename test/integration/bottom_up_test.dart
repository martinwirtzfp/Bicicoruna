import 'package:flutter_test/flutter_test.dart';
import 'package:bicicoruna/models/station_info.dart';
import 'package:bicicoruna/models/station_status.dart';
import 'package:bicicoruna/models/station.dart';

// Test de integración ASCENDENTE (Bottom-Up)
// Empezamos desde la capa más baja (JSON) y vamos subiendo
void main() {
  group('Integración Ascendente: Flujo completo de procesamiento de datos', () {
    test(
        'Valida el flujo JSON → StationInfo/Status → Station.combine → Integridad',
        () {

      // PASO 1: Datos crudos JSON (como vienen de la API)
      final stationInfoJson = {
        'station_id': '4',
        'name': 'Aquarium',
        'capacity': 15,
        'address': 'P.º Marítimo Alcalde Francisco Vázquez, 59',
      };

      final stationStatusJson = {
        'station_id': '4',
        'num_bikes_available': 7,
        'num_bikes_disabled': 4,
        'num_docks_available': 4,
        'num_docks_disabled': 0,
        'last_reported': 1768427178,
        'vehicle_types_available': [
          {'vehicle_type_id': 'FIT', 'count': 4},
          {'vehicle_type_id': 'EFIT', 'count': 2},
          {'vehicle_type_id': 'BOOST', 'count': 1},
        ],
      };

      // PASO 2: Parsing a modelos (capa de modelos)
      final stationInfo = StationInfo.fromJson(stationInfoJson);
      final stationStatus = StationStatus.fromJson(stationStatusJson);

      // Validamos parsing correcto
      expect(stationInfo.name, 'Aquarium');
      expect(stationStatus.numBikesAvailable, 7);
      expect(stationStatus.numBikesElectric, 3,
          reason: 'EFIT(2) + BOOST(1) = 3');

      // PASO 3: Combinación en Station (capa de dominio)
      final station = Station.combine(stationInfo, stationStatus);

      // Validamos que la combinación funciona
      expect(station.name, 'Aquarium');
      expect(station.capacity, 15);
      expect(station.numBikesAvailable, 7);
      expect(station.numBikesElectric, 3);

      // PASO 4: Validación de integridad (reglas de negocio)
      final total = station.numBikesAvailable +
          station.numBikesDisabled +
          station.numDocksAvailable +
          station.numDocksDisabled;

      expect(total, station.capacity,
          reason:
              'La suma de todos los elementos debe igualar la capacidad total');

      final totalBikes =
          station.numBikesElectric + station.numBikesMechanic;
      expect(totalBikes, station.numBikesAvailable,
          reason: 'La suma de bicis por tipo debe igualar el total disponible');

      // Si llegamos aquí, el flujo completo funciona correctamente
      print('Flujo ascendente completado: JSON → Modelos → Station → Integridad');
    });
  });
}
