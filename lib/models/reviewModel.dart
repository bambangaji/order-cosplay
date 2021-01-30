class Posts {
  final String id_outlet;
  final String nameOutlet;
  final String city;
  final String image;

  Posts({this.id_outlet, this.nameOutlet,this.city, this.image});

  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
       id_outlet: json['id_outlet'],
       nameOutlet: json['name_outlet'],
       city: json['city'],
       image: json['image_outlet'],
    );
  }
}