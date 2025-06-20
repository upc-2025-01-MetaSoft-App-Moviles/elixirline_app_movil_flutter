import '../../domain/entities/parcel.dart';
import '../../domain/repositories/parcel_repository.dart';

class GetParcelsUseCase {
  final ParcelRepository repository;
  GetParcelsUseCase(this.repository);

  Future<List<Parcel>> call() => repository.getParcels();
}