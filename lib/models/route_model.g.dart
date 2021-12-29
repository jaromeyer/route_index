// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteModelAdapter extends TypeAdapter<RouteModel> {
  @override
  final int typeId = 0;

  @override
  RouteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteModel()
      ..name = fields[0] as String
      ..grade = fields[1] as int
      ..sector = fields[2] as String
      ..setter = fields[3] as String
      ..date = fields[4] as DateTime
      ..userGrades = (fields[5] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, RouteModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.grade)
      ..writeByte(2)
      ..write(obj.sector)
      ..writeByte(3)
      ..write(obj.setter)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.userGrades);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
