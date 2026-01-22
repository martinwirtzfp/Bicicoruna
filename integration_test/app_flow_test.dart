import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bicicoruna/main.dart' as app;

// Test de Sistema (End-to-End)
// Simula el flujo completo de un usuario real usando la aplicación
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Flujo completo: Usuario busca estación y ve detalle',
      (WidgetTester tester) async {

    // PASO 1: Usuario abre la aplicación
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Validación: Debe cargar y mostrar el título
    expect(find.text('BiciCoruña'), findsOneWidget);

    // Validación: Debe cargar estaciones desde la API GBFS real
    expect(find.byType(Card), findsWidgets,
        reason: 'Debe mostrar tarjetas de estaciones cargadas de la API');

    // PASO 2: Usuario busca una estación específica
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget,
        reason: 'Debe existir campo de búsqueda');

    await tester.enterText(searchField, 'Torre');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Validación: El filtro debe funcionar (solo estaciones con "Torre")
    final cardsFiltrados = find.byType(Card);
    expect(cardsFiltrados, findsWidgets,
        reason: 'Debe mostrar estaciones que contienen "Torre"');

    // Validación: Verificar que muestra resultados de Torre
    expect(find.textContaining('Torre', findRichText: true), findsWidgets,
        reason: 'Los resultados deben contener "Torre"');

    // PASO 3: Usuario limpia búsqueda para ver todas
    await tester.enterText(searchField, '');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Validación: Debe mostrar todas las estaciones de nuevo
    expect(find.byType(Card), findsWidgets,
        reason: 'Búsqueda vacía debe restaurar lista completa');

    // PASO 4: Usuario selecciona primera estación
    final primeraEstacion = find.byType(Card).first;
    await tester.tap(primeraEstacion);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Validación: Debe navegar a pantalla de detalle
    expect(find.byType(BackButton), findsOneWidget,
        reason: 'Detalle debe tener botón de retroceso');

    // Validación: Debe mostrar métricas completas (pueden aparecer múltiples veces)
    expect(find.text('Puestos totales'), findsWidgets,
        reason: 'Debe mostrar información de capacidad total');
    expect(find.text('Bicis disponibles'), findsWidgets,
        reason: 'Debe mostrar bicis disponibles');
    expect(find.text('Anclajes libres'), findsWidgets,
        reason: 'Debe mostrar anclajes disponibles');
    expect(find.text('Mecánicas'), findsWidgets,
        reason: 'Debe mostrar desglose por tipo de bici');

    // PASO 5: Usuario vuelve a la lista
    final backButton = find.byType(BackButton);
    await tester.tap(backButton);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Validación: Debe volver a la lista principal
    expect(find.text('BiciCoruña'), findsOneWidget,
        reason: 'Debe mostrar título de la pantalla principal');
    expect(find.byType(Card), findsWidgets,
        reason: 'Debe restaurar lista completa de estaciones');

    print('Test de sistema completado: E2E con API real → Búsqueda → Detalle → Retorno');
  });
}
