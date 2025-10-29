import 'package:command_it/command_it.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../modules/destinations/destination_module.dart';
import '../../../modules/destinations/dto/destination_dto.dart';
import '../../view_model.dart';

class DestinationListViewModel extends ViewModel {
  DestinationListViewModel({
    required DestinationModule destinationModule,
    required bool favoritesOnly,
  }) : _destinationModule = destinationModule,
       _favoritesOnly = favoritesOnly {
    loadDestinationsCommand = Command.createAsyncNoParam(
      _loadDestinations,
      initialValue: null,
    );
  }

  final DestinationModule _destinationModule;
  final bool _favoritesOnly;

  late final Command<void, Result<List<DestinationDto>, String>?>
  loadDestinationsCommand;

  Future<Result<List<DestinationDto>, String>> _loadDestinations() async {
    try {
      final result = await _destinationModule.listDestinations();
      final (success: destinations, :error) = result.getBoth();

      if (error != null) {
        return Error("Ocorreu um erro ao carregar os destinos");
      }

      if (_favoritesOnly) {
        final favoriteDestinations = destinations!
            .where((destination) => destination.isFavorite)
            .toList();
        return Success(favoriteDestinations);
      }

      return Success(destinations!);
    } catch (e) {
      return Error('Ocorreu um erro ao carregar os destinos');
    }
  }

  Future<void> markFavorite(int destinationId, bool isFavorite) async {
    if (isFavorite) {
      await _destinationModule.markAsFavorite(destinationId);
    } else {
      await _destinationModule.unmarkAsFavorite(destinationId);
    }
  }

  @override
  void dispose() {
    loadDestinationsCommand.dispose();
  }
}
