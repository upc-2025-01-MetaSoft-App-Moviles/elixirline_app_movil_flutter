import '../entities/parcel.dart';

abstract class ParcelRepository {
  Future<List<Parcel>> getParcels();
  Future<void> createParcel(Parcel parcel);
}
