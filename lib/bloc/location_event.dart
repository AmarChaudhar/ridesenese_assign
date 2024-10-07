import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLocation extends LocationEvent {
  final String location;

  FetchLocation(this.location);

  @override
  List<Object?> get props => [location];
}
