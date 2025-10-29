import 'package:flutter/material.dart';

import '../../../config/assets.dart';
import '../../../modules/destinations/dto/destination_dto.dart';
import 'circular_flag.dart';

class DestinationCard extends StatefulWidget {
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
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  late bool isFavorite = widget.destination.isFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      child: Container(
        width: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
          color: colorScheme.surfaceBright,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with flag, name, location, and favorite button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Circular flag avatar
                  CircularFlag(code: widget.destination.countryCode),
                  const SizedBox(width: 16),
                  // Name and location
                  _headingInfo(theme, colorScheme),
                  // Favorite button
                  IconButton(
                    onPressed: () {
                      widget.onTapFavorite?.call();
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite
                          ? Colors.amber
                          : colorScheme.onSurfaceVariant,
                    ),
                    iconSize: 24,
                  ),
                ],
              ),
            ),

            // Image placeholder
            SizedBox(
              height: 200,
              child: Image.asset(
                Assets.destinationImage(widget.destination.id),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),

            // Description section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sobre',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.destination.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Observations button
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: widget.onTapEdit,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Observações'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _headingInfo(ThemeData theme, ColorScheme colorScheme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.destination.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            widget.destination.location,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
