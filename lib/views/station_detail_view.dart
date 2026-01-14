import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/station.dart';
import '../widgets/station_widgets.dart';

// Pantalla de detalle que muestra toda la información de una estación
class StationDetailView extends StatelessWidget {
  final Station station;

  const StationDetailView({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Estación'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la estación
              Text(
                station.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Dirección
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      station.address,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Última actualización
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Actualizado: ${_formatDate(station.lastReported)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tarjetas con métricas principales en una cuadrícula
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  // Total de puestos
                  MetricCard(
                    label: 'Puestos totales',
                    value: station.capacity,
                    icon: Icons.location_on,
                    color: Colors.indigo,
                  ),
                  // Bicis disponibles
                  MetricCard(
                    label: 'Bicis disponibles',
                    value: station.numBikesAvailable,
                    icon: Icons.directions_bike,
                    color: Colors.green,
                  ),
                  // Anclajes libres
                  MetricCard(
                    label: 'Anclajes libres',
                    value: station.numDocksAvailable,
                    icon: Icons.check_circle,
                    color: Colors.blue,
                  ),
                  // Bicis rotas
                  MetricCard(
                    label: 'Bicis rotas',
                    value: station.numBikesDisabled,
                    icon: Icons.build,
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tarjeta de tipos de bicicletas
              BikeTypeCard(
                electric: station.numBikesElectric,
                mechanic: station.numBikesMechanic,
              ),
              const SizedBox(height: 24),

              // Sección de información adicional
              const Text(
                'Estado de ocupación',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Barra de progreso de bicis
              ProgressIndicatorWidget(
                label: 'Bicis',
                current: station.numBikesAvailable,
                total: station.capacity,
                color: Colors.green,
              ),

              // Barra de progreso de anclajes libres
              ProgressIndicatorWidget(
                label: 'Anclajes libres',
                current: station.numDocksAvailable,
                total: station.capacity,
                color: Colors.blue,
              ),

              // Barra de progreso de puestos rotos
              if (station.numDocksDisabled > 0)
                ProgressIndicatorWidget(
                  label: 'Puestos inhabilitados',
                  current: station.numDocksDisabled,
                  total: station.capacity,
                  color: Colors.red,
                ),

              const SizedBox(height: 24),

              // Indicador visual del estado general
              _buildStatusIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget que muestra un indicador del estado general de la estación
  Widget _buildStatusIndicator() {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    // Determinamos el estado según la disponibilidad
    if (station.numBikesAvailable == 0) {
      statusText = 'Sin bicicletas disponibles';
      statusColor = Colors.red;
      statusIcon = Icons.error;
    } else if (station.numDocksAvailable == 0) {
      statusText = 'Sin anclajes libres';
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
    } else if (station.numBikesAvailable < 3) {
      statusText = 'Pocas bicicletas disponibles';
      statusColor = Colors.orange;
      statusIcon = Icons.info;
    } else {
      statusText = 'Estación operativa';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Formatea la fecha para mostrarla de forma legible
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    // Si fue hace menos de 1 minuto
    if (difference.inMinutes < 1) {
      return 'Hace unos segundos';
    }
    // Si fue hace menos de 1 hora
    else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    }
    // Si fue hoy
    else if (difference.inHours < 24 && date.day == now.day) {
      return 'Hoy a las ${DateFormat('HH:mm').format(date)}';
    }
    // Fecha completa
    else {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }
}
