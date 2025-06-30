import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/constants/app_constants.dart';
import '../utils/helpers/connectivity_helper/connectivity_checker_helper.dart';

class CustomBlocConsumer<B extends BlocBase<S>, S> extends StatefulWidget {
  final B bloc;
  final BlocWidgetBuilder<S> builder;
  final BlocWidgetListener<S> listener;
  final BlocBuilderCondition<S>? buildWhen;
  final BlocListenerCondition<S>? listenWhen;
  final void Function(B bloc)? onInitState;

  const CustomBlocConsumer({
    super.key,
    required this.bloc,
    required this.builder,
    required this.listener,
    this.buildWhen,
    this.listenWhen,
    this.onInitState,
  });

  @override
  State<CustomBlocConsumer> createState() => _CustomBlocConsumerState<B, S>();
}

class _CustomBlocConsumerState<B extends BlocBase<S>, S> extends State<CustomBlocConsumer<B, S>> {
  @override
  void initState() {
    super.initState();
    checkInternetAvailability();
    if (widget.onInitState != null) {
      widget.onInitState!(widget.bloc);
    }
  }

  void checkInternetAvailability() {
    ConnectivityCheckerHelper.listenToConnectivityChanged().listen(
      (connectivityResult) {
        if (connectivityResult.first == ConnectivityResult.none) {
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(commonConnectionFailedMessage),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      bloc: widget.bloc,
      listener: widget.listener,
      buildWhen: widget.buildWhen,
      listenWhen: widget.listenWhen,
      builder: (BuildContext context, S state) {
        return widget.builder(context, state);
      },
    );
  }
}
