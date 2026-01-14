import 'package:bicicoruna/models/station.dart';
import 'package:bicicoruna/models/station_info.dart';
import 'package:bicicoruna/models/station_status.dart';
import 'package:bicicoruna/repositories/station_repository.dart';

// Mock del Repository para pruebas descendentes (top-down)
// Simula las respuestas de la API sin hacer llamadas reales
class MockStationRepository implements IStationRepository {
  // Simula un retraso de red
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Devuelve una lista predefinida de estaciones fake
  Future<List<Station>> getAllStations() async {
    await _simulateNetworkDelay();

    return [
      _crearEstacionMock(
        id: '1',
        nombre: 'Plaza De Pontevedra',
        direccion: 'R. San Andrés, 164',
        capacity: 29,
        bikesAvailable: 5,
        bikesDisabled: 2,
        docksAvailable: 22,
        docksDisabled: 0,
        electric: 2,
        mechanic: 3,
      ),
      _crearEstacionMock(
        id: '2',
        nombre: 'Aquarium',
        direccion: 'P.º Marítimo Alcalde Francisco Vázquez, 59',
        capacity: 15,
        bikesAvailable: 7,
        bikesDisabled: 4,
        docksAvailable: 4,
        docksDisabled: 0,
        electric: 3,
        mechanic: 4,
      ),
      _crearEstacionMock(
        id: '3',
        nombre: 'Torre de Hércules',
        direccion: 'P.º Marítimo Alcalde Francisco Vázquez, 151',
        capacity: 15,
        bikesAvailable: 10,
        bikesDisabled: 0,
        docksAvailable: 5,
        docksDisabled: 0,
        electric: 5,
        mechanic: 5,
      ),
      _crearEstacionMock(
        id: '4',
        nombre: 'Puerto - Palexco',
        direccion: 'Rúa Celedonio de Uribe, 2',
        capacity: 15,
        bikesAvailable: 0,
        bikesDisabled: 1,
        docksAvailable: 14,
        docksDisabled: 0,
        electric: 0,
        mechanic: 0,
      ),
      _crearEstacionMock(
        id: '5',
        nombre: 'Obelisco',
        direccion: 'Rúa Cantón Grande, 4',
        capacity: 23,
        bikesAvailable: 15,
        bikesDisabled: 0,
        docksAvailable: 8,
        docksDisabled: 0,
        electric: 8,
        mechanic: 7,
      ),
    ];
  }

  // Simula un error de red
  Future<List<Station>> getAllStationsWithError() async {
    await _simulateNetworkDelay();
    throw Exception('No se pudo conectar con el servidor');
  }

  // Función auxiliar para crear estaciones mock
  Station _crearEstacionMock({
    required String id,
    required String nombre,
    required String direccion,
    required int capacity,
    required int bikesAvailable,
    required int bikesDisabled,
    required int docksAvailable,
    required int docksDisabled,
    required int electric,
    required int mechanic,
  }) {
    return Station(
      stationId: id,
      name: nombre,
      address: direccion,
      capacity: capacity,
      numBikesAvailable: bikesAvailable,
      numBikesDisabled: bikesDisabled,
      numDocksAvailable: docksAvailable,
      numDocksDisabled: docksDisabled,
      numBikesElectric: electric,
      numBikesMechanic: mechanic,
      lastReported: DateTime.now().subtract(const Duration(minutes: 5)),
    );
  }
}
