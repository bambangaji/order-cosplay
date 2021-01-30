class OrderUserModel {
  final String id_order;
  final String id_user;
  final String id_outlet;
  final String nameCharacter;
  final String series;
  final String material;
  final String description;
  final String phone;
  final String address;
  final String date_product;
  final String created_date;
  final String imageProduct;
  final String rangePrice;
  final String isStatus;
  final String addressOutlet;
  final String phoneNumberOutlet;
  final String name_outlet;
  final String pengiriman;
  final String noResi;
  OrderUserModel(
      this.id_order,
      this.id_user,
      this.id_outlet,
      this.nameCharacter,
      this.series,
      this.material,
      this.description,
      this.phone,
      this.address,
      this.date_product,
      this.created_date,
      this.imageProduct,
      this.rangePrice,
      this.isStatus,
      this.addressOutlet,
      this.phoneNumberOutlet,
      this.name_outlet,
      this.pengiriman,
      this.noResi
      );
}
