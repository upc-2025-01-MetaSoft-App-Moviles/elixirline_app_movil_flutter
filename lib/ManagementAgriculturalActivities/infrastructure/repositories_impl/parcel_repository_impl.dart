import '../../domain/entities/parcel.dart';
import '../../domain/repositories/parcel_repository.dart';

class ParcelRepositoryImpl implements ParcelRepository {
  final List<Parcel> _parcels = [
    Parcel(
      id: '1',
      name: 'Lote A',
      cropType: 'Uva',
      growthStage: 'Floración',
      lastTask: 'Riego',
      yieldEstimate: '1000',
      location: 'Viñedo Norte',
      status: 'Saludable',
    ),
  ];

  @override
  Future<List<Parcel>> getParcels() async {
    return _parcels;
  }

  @override
  Future<void> createParcel(Parcel parcel) async {
    _parcels.add(parcel);
  }
}
