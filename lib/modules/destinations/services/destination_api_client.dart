// Interfaces with destination api (actually, just a mock json file for now)
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../config/assets.dart';
import '../dto/destination_dto.dart';

class DestinationApiClient {
  Future<Result<List<DestinationDto>, Exception>> listDestinations() async {
    try {
      final destinations = await rootBundle.loadString(Assets.destinations);

      final Map<String, dynamic> decoded = json.decode(destinations);

      // should be in format { data: [ ... ] }
      final data = (decoded['data'] as List).cast<Map<String, dynamic>>();
      final destinationList = data
          .map((e) => DestinationDto.fromJson(e))
          .toList();

      return Success(destinationList);
    } on Exception catch (e) {
      return Error(e);
    }
  }
}
