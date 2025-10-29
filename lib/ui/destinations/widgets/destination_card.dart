import 'package:flutter/widgets.dart';
import 'package:hot_tourist_destinations/modules/destinations/dto/destination_dto.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    required this.destination,
    this.onTapEdit,
    this.onTapFavorite,
    super.key,
  });

  final DestinationDto destination;

  final VoidCallback? onTapEdit;

  final VoidCallback? onTapFavorite;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
