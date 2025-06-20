import '../../domain/entities/parcel.dart';
import '../../domain/repositories/parcel_repository.dart';

class CreateParcelUseCase {
  final ParcelRepository _parcelRepository;

  CreateParcelUseCase(this._parcelRepository);

  Future<void> execute(Parcel parcel) async {
    await _parcelRepository.createParcel(parcel);
  }
}
