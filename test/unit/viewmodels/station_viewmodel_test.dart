import 'package:flutter_test/flutter_test.dart';
import 'package:bicicoruna/viewmodels/station_viewmodel.dart';
import 'package:bicicoruna/models/station.dart';
import 'package:bicicoruna/models/station_info.dart';
import 'package:bicicoruna/models/station_status.dart';

void main() {
  group('StationViewModel - Gestión de estado y búsqueda', () {
    test('Filtra estaciones correctamente por nombre', () {
      // PROPÓSITO: Verificar que el buscador filtra estaciones por su nombre
      // Impacto si falla: El usuario no podría encontrar estaciones específicas
      
      // Arrange: Creamos un ViewModel con estaciones de prueba
      final viewModel = StationViewModel();

      // Añadimos 4 estaciones, 2 con "plaza" en el nombre
      viewModel.stations.addAll([
        _crearEstacionFake('1', 'Plaza De Pontevedra'),
        _crearEstacionFake('2', 'Aquarium'),
        _crearEstacionFake('3', 'Torre de Hércules'),
        _crearEstacionFake('4', 'Plaza de Vigo'),
      ]);
      viewModel.filteredStations.addAll(viewModel.stations);

      // Act: Buscamos "plaza"
      viewModel.searchStations('plaza');

      // Assert: Solo deben aparecer estaciones con "plaza" en el nombre
      expect(viewModel.filteredStations.length, 2,
          reason: 'Debe encontrar 2 estaciones con "plaza"');

      expect(
          viewModel.filteredStations
              .every((s) => s.name.toLowerCase().contains('plaza')),
          true,
          reason: 'Todas las estaciones filtradas deben contener "plaza"');
    });

    test('Búsqueda es case-insensitive', () {
      // PROPÓSITO: El buscador debe funcionar sin importar mayúsculas/minúsculas
      // Impacto si falla: Búsquedas como "PLAZA" o "plaza" darían resultados diferentes
      
      // Arrange: ViewModel con estaciones de prueba
      final viewModel = StationViewModel();
      viewModel.stations.addAll([
        _crearEstacionFake('1', 'Plaza De Pontevedra'),
        _crearEstacionFake('2', 'Aquarium'),
      ]);
      viewModel.filteredStations.addAll(viewModel.stations);

      // Act: Buscamos con mayúsculas
      viewModel.searchStations('PLAZA');

      // Assert: Debe encontrar "Plaza De Pontevedra" aunque busquemos en mayúsculas
      expect(viewModel.filteredStations.length, 1,
          reason: 'Búsqueda debe ser case-insensitive');
      expect(viewModel.filteredStations.first.name, 'Plaza De Pontevedra');
    });
  });
}

// Función auxiliar para crear estaciones fake en los tests
Station _crearEstacionFake(String id, String nombre) {
  return Station(
    stationId: id,
    name: nombre,
    address: 'Dirección de prueba',
    capacity: 15,
    numBikesAvailable: 5,
    numBikesDisabled: 0,
    numDocksAvailable: 10,
    numDocksDisabled: 0,
    numBikesElectric: 2,
    numBikesMechanic: 3,
    lastReported: DateTime.now(),
  );
}
