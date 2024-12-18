import 'package:cuidapet_api/app/helpers/request_mapping.dart';

class SupplierUpdateInputModel extends RequestMapping {
  int supplierId;
  late String name;
  late String logo;
  late String phone;
  late String address;
  late double lat;
  late double lng;
  late int categoryId;

  SupplierUpdateInputModel({
    required this.supplierId,
    required String dataRequest,
  }) : super(dataRequest);

  @override
  void map() {
    name = data['name'];
    logo = data['logo'];
    phone = data['phone'];
    address = data['address'];
    lat = data['lat'];
    lng = data['lng'];
    categoryId = data['category_id'];
  }
}
