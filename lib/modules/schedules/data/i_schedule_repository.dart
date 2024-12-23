import 'package:cuidapet_api/entities/schedule.dart';

abstract interface class IScheduleRepository {
  Future<void> save(Schedule schedule);
}
