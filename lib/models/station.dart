import 'station_info.dart';
import 'station_status.dart';

// Modelo completo de una estación que combina información y estado
class Station {
  final String stationId;
  final String name;
  final String address;
  final int capacity;
  final int numBikesAvailable;
  final int numBikesDisabled;
  final int numDocksAvailable;
  final int numDocksDisabled;
  final int numBikesElectric;
  final int numBikesMechanic;
  final DateTime lastReported;

  Station({
    required this.stationId,
    required this.name,
    required this.address,
    required this.capacity,
    required this.numBikesAvailable,
    required this.numBikesDisabled,
    required this.numDocksAvailable,
    required this.numDocksDisabled,
    required this.numBikesElectric,
    required this.numBikesMechanic,
    required this.lastReported,
  });

  // Combina datos de StationInfo y StationStatus
  factory Station.combine(StationInfo info, StationStatus status) {
    return Station(
      stationId: info.stationId,
      name: info.name,
      address: info.address,
      capacity: info.capacity,
      numBikesAvailable: status.numBikesAvailable,
      numBikesDisabled: status.numBikesDisabled,
      numDocksAvailable: status.numDocksAvailable,
      numDocksDisabled: status.numDocksDisabled,
      numBikesElectric: status.numBikesElectric,
      numBikesMechanic: status.numBikesMechanic,
      lastReported: status.lastReported,
    );
  }
}
