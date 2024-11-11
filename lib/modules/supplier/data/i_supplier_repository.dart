import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';

abstract interface class ISupplierRepository {
  Future<List<SupplierNearbyMeDTO>> findNearByPosition(
      double lat, double lng, int distance);
}
