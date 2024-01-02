import 'package:async_redux/async_redux.dart';
import 'package:business/redux/app_state.dart';
import 'package:business/redux/bme280_measurements/actions/retrieve_bme280_measurements_action.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ui/pages/home_page.dart';

class HomePageConnector extends StatelessWidget {
  const HomePageConnector({
    super.key,
  });

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _Vm>(
        debug: this,
        vm: () => _Factory(this),
        onInit: (store) async => store.dispatchAsync(
          RetrieveBme280MeasurementsAction(),
        ),
        builder: (context, vm) => HomePage(
          isWaiting: vm.isWaiting,
        ),
      );
}

/// Factory that creates a view-model for the StoreConnector.
class _Factory extends BaseFactory<HomePageConnector, _Vm> {
  _Factory(super.connector);

  @override
  _Vm fromStore() => _Vm(
        isWaiting: false,
      );
}

/// The view-model holds the part of the Store state the dumb-widget needs.
class _Vm extends Vm with EquatableMixin {
  _Vm({
    required this.isWaiting,
  });

  final bool isWaiting;

  @override
  List<Object?> get props => [isWaiting];
}
