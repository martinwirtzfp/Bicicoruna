import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/station_info.dart';
import '../models/station_status.dart';
import '../models/station.dart';

// Interfaz base para repositorios de estaciones
// Permite inyectar diferentes implementaciones (real o mock)
abstract class IStationRepository {
  Future<List<Station>> getAllStations();
}

// Repositorio que se encarga de obtener los datos de la API GBFS
class StationRepository implements IStationRepository {
  // URLs de los endpoints de la API
  static const String _baseUrl =
      'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl';
  static const String _stationInfoUrl = '$_baseUrl/station_information';
  static const String _stationStatusUrl = '$_baseUrl/station_status';

  // Obtiene la lista de información de todas las estaciones
  Future<List<StationInfo>> getStationInfo() async {
    try {
      final response = await http.get(Uri.parse(_stationInfoUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> stations = jsonData['data']['stations'];

        // Convierte cada elemento JSON en un objeto StationInfo
        return stations.map((json) => StationInfo.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al cargar información de estaciones: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('No se pudo conectar con el servidor: $e');
    }
  }

  // Obtiene el estado actual de todas las estaciones
  Future<List<StationStatus>> getStationStatus() async {
    try {
      final response = await http.get(Uri.parse(_stationStatusUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> stations = jsonData['data']['stations'];

        // Convierte cada elemento JSON en un objeto StationStatus
        return stations.map((json) => StationStatus.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al cargar estado de estaciones: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('No se pudo conectar con el servidor: $e');
    }
  }

  // Combina la información y el estado para obtener estaciones completas
  Future<List<Station>> getAllStations() async {
    try {
      // Hacemos ambas peticiones
      final stationInfoList = await getStationInfo();
      final stationStatusList = await getStationStatus();

      // Creamos un mapa para buscar rápidamente el estado por ID
      final statusMap = {
        for (var status in stationStatusList) status.stationId: status,
      };

      // Combinamos información y estado
      final stations = <Station>[];
      for (var info in stationInfoList) {
        final status = statusMap[info.stationId];
        if (status != null) {
          stations.add(Station.combine(info, status));
        }
      }

      return stations;
    } catch (e) {
      throw Exception('Error al obtener las estaciones: $e');
    }
  }
}
