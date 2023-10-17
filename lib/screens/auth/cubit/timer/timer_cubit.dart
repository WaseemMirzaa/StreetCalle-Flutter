import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class TimerCubit extends Cubit<int> {
  late Timer _timer;
  int initialDuration;

  TimerCubit(this.initialDuration) : super(initialDuration);

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state - 1);
      if (state == 0) {
        _timer.cancel();
      }
    });
  }

  void stop() {
    _timer.cancel();
    emit(initialDuration);
  }

  void resetAndStartTimer(int duration) {
    _timer.cancel();
    emit(duration);
    start();
  }

  bool isTimerActive(){
    return _timer.isActive;
  }

  @override
  Future<void> close() {
    stop();
    return super.close();
  }
}
