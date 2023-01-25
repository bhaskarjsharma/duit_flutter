// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartAdapter extends TypeAdapter<Cart> {
  @override
  final int typeId = 0;

  @override
  Cart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cart(
      ProductCode: fields[0] as String,
      ProductName: fields[1] as String,
      ProductPrice: fields[2] as int,
      ProductQuantity: fields[3] as int,
      ThumbnailURL: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Cart obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ProductCode)
      ..writeByte(1)
      ..write(obj.ProductName)
      ..writeByte(2)
      ..write(obj.ProductPrice)
      ..writeByte(3)
      ..write(obj.ProductQuantity)
      ..writeByte(4)
      ..write(obj.ThumbnailURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
