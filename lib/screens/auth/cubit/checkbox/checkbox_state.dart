
import 'package:equatable/equatable.dart';

class CheckBoxStates extends Equatable {

  final bool isSwitch ;

  const CheckBoxStates({
    this.isSwitch = false ,
  });


  CheckBoxStates copyWith({bool? isSwitch  }){
    return CheckBoxStates(
      isSwitch : isSwitch ?? this.isSwitch ,
    );
  }

  @override
  List<Object?> get props => [isSwitch, ];
}