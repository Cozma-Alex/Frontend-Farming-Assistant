import '../models/location.dart';
import '../models/enums/location_type.dart';
import '../models/user.dart';

Future<List<Location>> getLocations(int page, {int limit = 4}) async {
  await Future.delayed(const Duration(seconds: 1));

  final user = User(id: '1', email: 'test@example.com', password: 'password', farmName: 'Test Farm', name: 'John Doe');

  final locations = List.generate(11, (index) =>
      Location(
          'loc_${index + 1}',
          LocationType.values[index % LocationType.values.length],
          user
      )
  );

  return locations;
}