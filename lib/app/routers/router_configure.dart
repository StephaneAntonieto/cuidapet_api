import 'package:cuidapet_api/modules/user/user_router.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cuidapet_api/app/routers/i_router.dart';

class RouterConfigure {
  final Router _router;
  final List<IRouter> _routers = [
    UserRouter(),
  ];

  RouterConfigure(this._router);

  // void configure() => _routers.forEach((r) => r.configure(_router));

  void configure() {
    for (var r in _routers) {
      r.configure(_router);
    }
  }
}
