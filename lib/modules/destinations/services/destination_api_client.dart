// Interfaces with destination api (actually, just a mock json file for now)
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../config/assets.dart';
import 'models/destination/destination.dart';

class DestinationApiClient {
  Future<Result<List<Destination>, Exception>> listDestinations() async {
    try {
      final destinations = await rootBundle.loadString(Assets.destinations);

      final Map<String, dynamic> decoded = json.decode(destinations);

      // should be in format { data: [ ... ] }
      final data = (decoded['data'] as List).cast<Map<String, dynamic>>();
      final destinationList = data.map((e) => Destination.fromJson(e)).toList();

      return Success(destinationList);
    } on Exception catch (e) {
      return Error(e);
    }
  }

  Future<Result<Destination, Exception>> getDestination(
    int destinationId,
  ) async {
    try {
      final (success: destinations, error: apiError) =
          (await listDestinations()).getBoth();

      if (apiError != null) {
        return Error(apiError);
      }

      final destination = destinations!.firstWhere(
        (e) => e.id == destinationId,
        orElse: () => throw Exception('Destination not found'),
      );

      return Success(destination);
    } on Exception catch (e) {
      return Error(e);
    }
  }
}
