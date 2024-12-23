import 'package:cuidapet_api/modules/schedules/view_models/schedule_save_input_model.dart';

abstract interface class IScheduleService {
  Future<void> scheduleService(ScheduleSaveInputModel model);

  Future<void> changeStatus(String status, int scheduleId);
}
