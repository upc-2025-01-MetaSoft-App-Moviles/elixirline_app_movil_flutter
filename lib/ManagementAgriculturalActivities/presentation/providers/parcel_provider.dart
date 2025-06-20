import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/usecases/get_parcels_usecase.dart';
import '../../infrastructure/repositories_impl/parcel_repository_impl.dart';
import '../../domain/entities/parcel.dart';

final parcelProvider = FutureProvider<List<Parcel>>((ref) async {
  final parcelRepository = ParcelRepositoryImpl();
  final getParcelsUseCase = GetParcelsUseCase(parcelRepository);
  return await getParcelsUseCase();
});
