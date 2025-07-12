import '../../application/dtos/parcel_dto.dart';

abstract class ParcelRemoteDataSource {
  Future<List<ParcelDto>> getParcels();
  Future<void> createParcel(ParcelDto parcel);
}