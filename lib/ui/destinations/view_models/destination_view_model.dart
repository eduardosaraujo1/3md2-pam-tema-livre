import 'package:command_it/command_it.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../modules/destinations/destination_module.dart';
import '../../../modules/destinations/dto/destination_dto.dart';
import '../../view_model.dart';

class DestinationViewModel extends ViewModel {
  DestinationViewModel({
    required DestinationModule destinationModule,
    required int id,
  }) : _destinationModule = destinationModule,
       _id = id {
    loadDestinationCommand = Command.createAsyncNoParam(
      _loadDestination,
      initialValue: null,
    );
    saveDestinationInfoCommand = Command.createAsync(
      _saveDestination,
      initialValue: null,
    );
  }

  final DestinationModule _destinationModule;
  final int _id;

  late final Command<void, Result<DestinationDto, String>?>
  loadDestinationCommand;

  late final Command<String, Result<void, String>?> saveDestinationInfoCommand;

  Future<Result<DestinationDto, String>> _loadDestination() async {
    try {
      final result = await _destinationModule.getDestination(_id);
      final (success: destination, :error) = result.getBoth();

      if (error != null) {
        return Error("Ocorreu um erro ao carregar o destino");
      }

      return Success(destination!);
    } catch (e) {
      return Error('Ocorreu um erro ao carregar o destino');
    }
  }

  Future<Result<void, String>> _saveDestination(String userNotes) async {
    try {
      final result = await _destinationModule.writeDestinationObservation(
        _id,
        userNotes,
      );
      final (success: _, :error) = result.getBoth();

      if (error != null) {
        return Error("Ocorreu um erro ao salvar as informações do destino");
      }

      return Success(null);
    } catch (e) {
      return Error('Ocorreu um erro ao salvar as informações do destino');
    }
  }

  @override
  void dispose() {
    loadDestinationCommand.dispose();
  }
}
