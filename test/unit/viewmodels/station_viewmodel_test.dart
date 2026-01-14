import 'package:flutter_test/flutter_test.dart';
import 'package:bicicoruna/viewmodels/station_viewmodel.dart';
import 'package:bicicoruna/models/station.dart';
import 'package:bicicoruna/models/station_info.dart';
import 'package:bicicoruna/models/station_status.dart';

void main() {
  group('StationViewModel - Búsqueda', () {
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

    test('Búsqueda vacía muestra todas las estaciones', () {
      // PROPÓSITO: Al borrar el texto de búsqueda, deben aparecer todas las estaciones
      // Impacto si falla: El usuario no podría volver a ver todas las estaciones
      
      // Arrange: ViewModel con 3 estaciones
      final viewModel = StationViewModel();
      viewModel.stations.addAll([
        _crearEstacionFake('1', 'Plaza De Pontevedra'),
        _crearEstacionFake('2', 'Aquarium'),
        _crearEstacionFake('3', 'Torre de Hércules'),
      ]);
      viewModel.filteredStations.clear(); // Simulamos una búsqueda previa

      // Act: Búsqueda vacía
      viewModel.searchStations('');

      // Assert: Debe mostrar todas las estaciones
      expect(viewModel.filteredStations.length, 3,
          reason: 'Búsqueda vacía debe mostrar todas las estaciones');
    });
  });

  group('StationViewModel - Gestión de Estado', () {
    test('Estado inicial es StationState.initial', () {
      // PROPÓSITO: Verificar que el ViewModel empieza en estado "initial"
      // Impacto si falla: La UI podría mostrar estados incorrectos al inicio
      
      // Arrange & Act: Creamos un ViewModel nuevo
      final viewModel = StationViewModel();

      // Assert
      expect(viewModel.state, StationState.initial,
          reason: 'El estado inicial debe ser "initial"');
    });

    test('filteredStations actualiza cuando se busca', () {
      // PROPÓSITO: La lista filtrada debe actualizarse al realizar búsquedas
      // Impacto si falla: La UI no se refrescaría con los resultados de búsqueda
      
      // Arrange: ViewModel con 2 estaciones
      final viewModel = StationViewModel();
      viewModel.stations.addAll([
        _crearEstacionFake('1', 'Torre de Hércules'),
        _crearEstacionFake('2', 'Aquarium'),
      ]);
      viewModel.filteredStations.addAll(viewModel.stations);

      // Act
      viewModel.searchStations('torre');

      // Assert
      expect(viewModel.filteredStations.length, 1,
          reason: 'filteredStations debe actualizarse con la búsqueda');
      expect(viewModel.filteredStations.first.name, 'Torre de Hércules');
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
