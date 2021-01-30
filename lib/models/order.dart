class OrderModel {
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
  final String nameUser;
  final String imageUser;
  final String rangePrice;
  final String isStatus;
  final String pengiriman;
  final String noResi;

  OrderModel(
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
      this.nameUser,
      this.imageUser,
      this.rangePrice,
      this.isStatus,
      this.pengiriman,
      this.noResi);
}
