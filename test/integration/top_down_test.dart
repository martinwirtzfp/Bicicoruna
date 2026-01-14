import 'package:flutter_test/flutter_test.dart';
import 'package:bicicoruna/viewmodels/station_viewmodel.dart';
import '../mocks/mock_station_repository.dart';

// Test de integración DESCENDENTE (Top-Down)
// Empezamos desde la capa superior (ViewModel) simulando las inferiores
void main() {
  group('Integración Descendente: ViewModel con MockRepository', () {
    test('Valida el flujo MockRepository → ViewModel → Búsqueda', () async {
      // ENFOQUE DESCENDENTE:
      // Empezamos por la lógica de negocio (ViewModel) sin depender de la API real:
      // 1. MockRepository proporciona datos fake predefinidos
      // 2. ViewModel procesa estos datos (carga, búsqueda, filtrado)
      // 3. Validamos que la lógica de negocio funciona correctamente
      //
      // Utilidad: Permite probar el ViewModel sin conexión a internet
      // Decisión: Usamos 5 estaciones fake con datos realistas variados

      // PASO 1: Preparamos el mock y el ViewModel
      final mockRepository = MockStationRepository();
      final viewModel = StationViewModel(mockRepository);

      expect(viewModel.state, StationState.initial);

      // PASO 2: Cargamos datos desde el mock
      await viewModel.loadStations();

      // Validamos que cargó correctamente
      expect(viewModel.state, StationState.loaded);
      expect(viewModel.stations.length, 5,
          reason: 'MockRepository devuelve 5 estaciones');
      expect(viewModel.filteredStations.length, 5,
          reason: 'Inicialmente muestra todas');

      // PASO 3: Validamos búsqueda (funcionalidad clave del ViewModel)
      viewModel.searchStations('torre');

      expect(viewModel.filteredStations.length, 1,
          reason: 'Solo debe encontrar "Torre de Hércules"');
      expect(viewModel.filteredStations[0].name, 'Torre de Hércules');

      // PASO 4: Validamos búsqueda case-insensitive
      viewModel.searchStations('AQUARIUM');
      expect(viewModel.filteredStations.length, 1);
      expect(viewModel.filteredStations[0].name, 'Aquarium');

      // PASO 5: Validamos búsqueda vacía (reset)
      viewModel.searchStations('');
      expect(viewModel.filteredStations.length, 5,
          reason: 'Búsqueda vacía debe mostrar todas');

      // PASO 6: Validación de integridad de datos del mock
      for (final station in viewModel.stations) {
        final total = station.numBikesAvailable +
            station.numBikesDisabled +
            station.numDocksAvailable +
            station.numDocksDisabled;

        expect(total, station.capacity,
            reason:
                '${station.name}: Los datos del mock deben ser consistentes');
      }

      // ✅ Si llegamos aquí, el flujo descendente funciona correctamente
      print('✅ Flujo descendente completado: Mock → ViewModel → Búsqueda → ✓');
    });
  });
}
