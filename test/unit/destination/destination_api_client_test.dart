import 'package:flutter_test/flutter_test.dart';
import 'package:hot_tourist_destinations/modules/destinations/dto/destination_dto.dart';
import 'package:hot_tourist_destinations/modules/destinations/services/destination_api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  /** Requirements
   * - List all destinations
   */

  late DestinationApiClient apiClient;

  setUp(() {
    apiClient = DestinationApiClient();
  });

  test("it lists all destinations", () async {
    // Act
    final (:success, :error) = (await apiClient.listDestinations()).getBoth();

    // Assert
    expect(error, isNull);
    expect(success, isA<List<DestinationDto>>());
  });
}
