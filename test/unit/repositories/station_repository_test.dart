import 'package:flutter_test/flutter_test.dart';
import 'package:bicicoruna/repositories/station_repository.dart';
import 'package:bicicoruna/models/station_info.dart';
import 'package:bicicoruna/models/station_status.dart';
import 'package:bicicoruna/models/station.dart';

// FakeStationRepository: Sobrescribe solo los métodos HTTP
// pero usa la lógica real de getAllStations()
class FakeStationRepository extends StationRepository {
  final List<StationInfo>? fakeStationInfoList;
  final List<StationStatus>? fakeStationStatusList;
  final Exception? fakeInfoError;
  final Exception? fakeStatusError;

  FakeStationRepository({
    this.fakeStationInfoList,
    this.fakeStationStatusList,
    this.fakeInfoError,
    this.fakeStatusError,
  });

  @override
  Future<List<StationInfo>> getStationInfo() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simula latencia

    if (fakeInfoError != null) {
      throw fakeInfoError!;
    }

    return fakeStationInfoList ?? [];
  }

  @override
  Future<List<StationStatus>> getStationStatus() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simula latencia

    if (fakeStatusError != null) {
      throw fakeStatusError!;
    }

    return fakeStationStatusList ?? [];
  }

  // getAllStations() usa la implementación real del padre
  // que combina getStationInfo() y getStationStatus()
}

// Tests del Repository - Capa de acceso a datos
void main() {
  group('StationRepository - Integración de APIs GBFS', () {
    test(
        'Combina station_information y station_status correctamente usando station_id',
        () async {
      // PROPÓSITO: Verificar que el Repository empareja correctamente ambas APIs
      // La API real devuelve datos en 2 endpoints separados:
      // - station_information: nombre, capacidad, dirección
      // - station_status: bicis disponibles, estado en tiempo real
      // Se emparejan usando station_id como clave común
      // Impacto si falla: Las estaciones mostrarían información incorrecta o incompleta

      // Arrange: Creamos datos fake de ambas APIs con IDs coincidentes
      final fakeInfoList = [
        StationInfo(
          stationId: '1',
          name: 'Plaza De Pontevedra',
          capacity: 29,
          address: 'R. San Andrés, 164',
        ),
        StationInfo(
          stationId: '2',
          name: 'Aquarium',
          capacity: 15,
          address: 'P.º Marítimo',
        ),
        StationInfo(
          stationId: '3',
          name: 'Torre de Hércules',
          capacity: 15,
          address: 'Avda Navarra',
        ),
      ];

      final fakeStatusList = [
        StationStatus(
          stationId: '1', // Mismo ID que info
          numBikesAvailable: 5,
          numBikesDisabled: 2,
          numDocksAvailable: 22,
          numDocksDisabled: 0,
          numBikesElectric: 2,
          numBikesMechanic: 3,
          lastReported: DateTime.now(),
        ),
        StationStatus(
          stationId: '2', // Mismo ID que info
          numBikesAvailable: 7,
          numBikesDisabled: 4,
          numDocksAvailable: 4,
          numDocksDisabled: 0,
          numBikesElectric: 3,
          numBikesMechanic: 4,
          lastReported: DateTime.now(),
        ),
        StationStatus(
          stationId: '3', // Mismo ID que info
          numBikesAvailable: 10,
          numBikesDisabled: 0,
          numDocksAvailable: 5,
          numDocksDisabled: 0,
          numBikesElectric: 5,
          numBikesMechanic: 5,
          lastReported: DateTime.now(),
        ),
      ];

      final repository = FakeStationRepository(
        fakeStationInfoList: fakeInfoList,
        fakeStationStatusList: fakeStatusList,
      );

      // Act: Llamamos a getAllStations() que usa la lógica real
      final stations = await repository.getAllStations();

      // Assert: Verificamos que se combinaron correctamente
      expect(stations.length, 3,
          reason: 'Debe combinar las 3 estaciones usando station_id');

      // Verificamos que la primera estación tiene datos de ambas APIs
      final primeraEstacion = stations.firstWhere((s) => s.stationId == '1');
      expect(primeraEstacion.name, 'Plaza De Pontevedra',
          reason: 'Nombre debe venir de StationInfo');
      expect(primeraEstacion.capacity, 29,
          reason: 'Capacidad debe venir de StationInfo');
      expect(primeraEstacion.address, 'R. San Andrés, 164',
          reason: 'Dirección debe venir de StationInfo');
      expect(primeraEstacion.numBikesAvailable, 5,
          reason: 'Bicis disponibles debe venir de StationStatus');
      expect(primeraEstacion.numBikesElectric, 2,
          reason: 'Bicis eléctricas debe venir de StationStatus');

      // Verificamos la segunda estación
      final segundaEstacion = stations.firstWhere((s) => s.stationId == '2');
      expect(segundaEstacion.name, 'Aquarium');
      expect(segundaEstacion.numBikesAvailable, 7);
      expect(segundaEstacion.capacity, 15);
    });

    test('No incluye estaciones si no hay match de station_id entre ambas APIs',
        () async {

      // Arrange: IDs que NO coinciden entre ambas APIs
      final fakeInfoList = [
        StationInfo(
          stationId: '1',
          name: 'Estación A',
          capacity: 20,
          address: 'Dirección A',
        ),
        StationInfo(
          stationId: '2', // Este ID no existe en status
          name: 'Estación B',
          capacity: 15,
          address: 'Dirección B',
        ),
      ];

      final fakeStatusList = [
        StationStatus(
          stationId: '1', // Coincide con info
          numBikesAvailable: 10,
          numBikesDisabled: 0,
          numDocksAvailable: 10,
          numDocksDisabled: 0,
          numBikesElectric: 5,
          numBikesMechanic: 5,
          lastReported: DateTime.now(),
        ),
        StationStatus(
          stationId: '99', // Este ID no existe en info
          numBikesAvailable: 5,
          numBikesDisabled: 0,
          numDocksAvailable: 10,
          numDocksDisabled: 0,
          numBikesElectric: 2,
          numBikesMechanic: 3,
          lastReported: DateTime.now(),
        ),
      ];

      final repository = FakeStationRepository(
        fakeStationInfoList: fakeInfoList,
        fakeStationStatusList: fakeStatusList,
      );

      // Act
      final stations = await repository.getAllStations();

      // Assert: Solo debe incluir la estación con ID '1' que coincide en ambas
      expect(stations.length, 1,
          reason:
              'Solo debe combinar estaciones con station_id presente en ambas APIs');
      expect(stations.first.stationId, '1',
          reason: 'Solo el ID "1" coincide en ambas APIs');
      expect(stations.first.name, 'Estación A');
    });
  });
}
