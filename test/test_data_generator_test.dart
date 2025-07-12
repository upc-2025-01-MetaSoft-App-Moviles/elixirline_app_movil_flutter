import 'package:flutter_test/flutter_test.dart';
import 'package:elixirline_app_movil_flutter/core/shared/test_data_generator.dart';

void main() {
  group('TestDataGenerator Tests', () {
    test('should generate test data without errors', () async {
      // Este test simplemente verifica que el generador puede ejecutarse sin errores
      try {
        await TestDataGenerator.generateAndStoreTestData();
        print('✅ Test data generation completed successfully');
      } catch (e) {
        print('❌ Error during test data generation: $e');
        fail('Test data generation failed: $e');
      }
    });
  });
}
