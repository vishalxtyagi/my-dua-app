import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';

class MyCoordinates extends Coordinates with EquatableMixin {
  MyCoordinates(double latitude, double longitude) : super(latitude, longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}