// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:injectable/injectable.dart';

import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api/modules/supplier/data/i_supplier_repository.dart';

import './i_supplier_service.dart';

@LazySingleton(as: ISupplierService)
class SupplierService implements ISupplierService {
  final ISupplierRepository repository;
  // ignore: constant_identifier_names
  static const DISTANCE = 5;

  SupplierService({
    required this.repository,
  });

  @override
  Future<List<SupplierNearbyMeDTO>> findNearByMe(double lat, double lng) =>
      repository.findNearByPosition(lat, lng, DISTANCE);

  @override
  Future<Supplier?> findById(int id) => repository.findById(id);
}
