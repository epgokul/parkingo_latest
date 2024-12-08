import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Navigation event for changing the tab
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
}

class TabChanged extends NavigationEvent {
  final int index;
  const TabChanged(this.index);
  @override
  List<Object?> get props => [index];
}

///State for the navigation
class NavigationState extends Equatable {
  final int selectedIndex;
  const NavigationState(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

//bloc for the navigation
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(0)) {
    on<TabChanged>(
      (event, emit) {
        emit(NavigationState(event.index));
      },
    );
  }
}
