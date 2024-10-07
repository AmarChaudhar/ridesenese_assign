import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as location;
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<FetchLocation, LocationState> {
  final location.Location _location = location.Location();

  LocationBloc() : super(LocationInitial()) {
    on<FetchLocation>((event, emit) async {
      try {
        emit(LocationLoading());

        // Check for permission to access location
        location.PermissionStatus permissionStatus =
            await _location.requestPermission();

        if (permissionStatus != location.PermissionStatus.granted) {
          emit(const LocationError('Location permission denied'));
          return;
        }

        // get the current location
        location.LocationData currentLocation = await _location.getLocation();

        // Check if the user provided a specific location
        if (event.location.isNotEmpty) {
          // Geocode the user-entered location
          List<geocoding.Location> locations =
              await geocoding.locationFromAddress(event.location);
          final double latitude = locations.first.latitude;
          final double longitude = locations.first.longitude;
          emit(LocationLoaded(latitude, longitude));
        } else {
          // Use current location
          final double latitude = currentLocation.latitude!;
          final double longitude = currentLocation.longitude!;
          emit(LocationLoaded(latitude, longitude));
        }
      } catch (e) {
        emit(LocationError('Failed to fetch location: ${e.toString()}'));
      }
    });
  }
}
