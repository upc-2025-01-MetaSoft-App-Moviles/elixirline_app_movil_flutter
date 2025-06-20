import '../../domain/entities/parcel.dart';
import '../../domain/repositories/parcel_repository.dart';

class ParcelRepositoryImpl implements ParcelRepository {
  @override
  Future<List<Parcel>> getParcels() async => [
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
  Future<void> createParcel(Parcel parcel) async {}
}