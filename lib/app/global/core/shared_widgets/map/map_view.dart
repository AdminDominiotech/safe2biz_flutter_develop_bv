import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_safe2bizapp_background_location/mobile_safe2bizapp_background_location.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

import 'cubit/map_view_cubit.dart';

class MapView extends StatefulWidget {
  const MapView({
    Key? key,
    this.maxHeight = 350,
    this.minHeight = 350,
    this.onChangePlace,
    this.onMapCreated,
    this.initPosition,
    this.onExpanded,
  }) : super(key: key);

  final void Function(LatLng latLng)? onChangePlace;
  final VoidCallback? onMapCreated;
  final LatLng? initPosition;
  final double maxHeight;
  final double minHeight;
  final Function(bool isExpanded)? onExpanded;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();

  late Animation<double> animation;

  late AnimationController _animateController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(
      -15.46836908316897,
      -71.90962872447304,
    ),

    zoom: 15.4746,
  );

  bool _init = true;

  LatLng? _currentPosition;

  StreamSubscription<Position>? _positionSubscription;

  final _changedIcon = ValueNotifier<bool>(false);
  final iconExpand = Icon(FontAwesomeIcons.expand);
  final iconCompress = Icon(FontAwesomeIcons.compress);
  @override
  void initState() {
    _animateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animateController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onExpanded!.call(true);
        }
        if (status == AnimationStatus.dismissed) {
          widget.onExpanded!.call(false);
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTracking();
    });
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    _animateController.dispose();
    if (_controller.isCompleted) {
      final controller = await _controller.future;
      controller.dispose();
    }
    stopTracking();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    return BlocProvider(
      create: (context) => MapViewCubit(),
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, child) {
          final percent = widget.maxHeight * animation.value;

          final newHeight = percent.clamp(widget.minHeight, widget.maxHeight);

          return LayoutBuilder(
            builder: (ctxt, box) {
              return SizedBox(
                width: box.maxWidth,
                height: newHeight,
                child: child,
              );
            },
          );
        },
        child: Builder(
          builder: (ctxt) {
            final cubit = ctxt.read<MapViewCubit>();
            return Stack(
              alignment: Alignment.topCenter,
              fit: StackFit.expand,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  mapToolbarEnabled: true,
                  compassEnabled: false,
                  zoomControlsEnabled: true,
                  gestureRecognizers: _gestureRecognizersMap().toSet(),
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: _onMapCreated,
                  onCameraMove: cubit.onMapCameraMove,
                  onCameraIdle: cubit.onMapCameraIdle,
                ),
                BlocConsumer<MapViewCubit, MapViewState>(
                  listener: (context, state) {
                    if (state is MapViewLoaded) {
                      widget.onChangePlace!.call(state.position);
                    }
                  },
                  builder: (context, state) {
                    return state is MapViewLoading
                        ? const Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              backgroundColor: S2BColors.orange,
                              minHeight: 2,
                              color: Color(0XFF4B82B9),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FloatingActionButton(
                    heroTag: 'btn1',
                    onPressed: () {
                      _goCurrentPosition();
                    },
                    mini: true,
                    backgroundColor: Color(0XFF4B82B9),
                    child: const Icon(Icons.gps_fixed),
                  ),
                ),
                if (widget.onExpanded != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: FloatingActionButton(
                      heroTag: 'btn2',
                      onPressed: () {
                        _changedIcon.value = !_changedIcon.value;

                        if (_animateController.isCompleted) {
                          _animateController.reverse();
                        } else {
                          _animateController.forward();
                        }
                      },
                      mini: true,
                      backgroundColor: Color(0XFF4B82B9),
                      child: ValueListenableBuilder<bool>(
                          valueListenable: _changedIcon,
                          builder: (_, isExpanded, __) {
                            if (isExpanded) {
                              return iconCompress;
                            }
                            return iconExpand;
                          }),
                    ),
                  ),
                Align(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 50,
                    ),
                    height: 50,
                    child: Image.asset(
                      UiValues.markerIconPng,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  List<Factory<OneSequenceGestureRecognizer>> _gestureRecognizersMap() {
    return List<Factory<OneSequenceGestureRecognizer>>.from([
      Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
      Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
      Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
      Factory<VerticalDragGestureRecognizer>(
        () => VerticalDragGestureRecognizer(),
      )
    ]);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    if (_controller.isCompleted) {
      _controller = Completer();
    }
    _controller.complete(controller);

    if (widget.onMapCreated != null) {
      widget.onMapCreated!.call();
    }
  }

  void stopTracking() async {
    await _positionSubscription?.cancel();
  }

  void startTracking() {
    _positionSubscription = AppPosition.startTracking.listen(
      (Position location) {
        _currentPosition = LatLng(location.latitude, location.longitude);

        if (_init) {
          if (widget.onChangePlace != null) {
            widget.onChangePlace!(_currentPosition!);
            if (widget.initPosition != null) {
              _moveCamera(widget.initPosition!);
            } else {
              _goCurrentPosition();
            }
          }
        }
        _init = false;
      },
    );
  }

  Future<void> _goCurrentPosition() async {
    if (_currentPosition != null) {
      final CameraPosition _kLake = CameraPosition(
          // bearing: 192.8334901395799,
          target:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          // tilt: 59.440717697143555,
          zoom: 16.151926040649414);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    }
  }

  Future<void>? _moveCamera(LatLng location) async {
    final controller = await _controller.future;

    return controller.animateCamera(CameraUpdate.newLatLng(location));
  }
}
