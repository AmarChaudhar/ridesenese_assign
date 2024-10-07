import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';
import 'map_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (e.g., City, Address)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_locationController.text.isNotEmpty) {
                  print('User entered location: ${_locationController.text}');

                  // Pass the user input to the FetchLocation event
                  BlocProvider.of<LocationBloc>(context)
                      .add(FetchLocation(_locationController.text));

                  print('Location event added to the Bloc');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a location')),
                  );
                }
              },
              child: const Text('Show on Map'),
            ),
            const SizedBox(height: 20),
            BlocConsumer<LocationBloc, LocationState>(
              listener: (context, state) {
                if (state is LocationLoaded) {
                  print(
                      'Location loaded with lat: ${state.latitude}, lng: ${state.longitude}');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                        latitude: state.latitude,
                        longitude: state.longitude,
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is LocationLoading) {
                  print('Loading location...');
                  return const CircularProgressIndicator();
                } else if (state is LocationError) {
                  print('Error: ${state.message}');
                  return Text(state.message);
                } else if (state is LocationInitial) {
                  print('Waiting for user input...');
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
