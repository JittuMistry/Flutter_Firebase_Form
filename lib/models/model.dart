class DataModel {
  final String companyName;
  final String name;
  final String email;
  final String mobile;
  final String address;
  final String image;
  final String color;
  final String timestamp;

  DataModel({
    required this.companyName,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.image,
    required this.color,
    required this.timestamp,
  });

  factory DataModel.fromMap(Map<String, dynamic> userData) {
    return DataModel(
      companyName: userData['companyName'],
      name: userData['name'],
      email: userData['email'],
      mobile: userData['mobile'],
      address: userData['address'],
      image: userData['image'],
      color: userData['color'],
      timestamp: userData['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'image': image,
      'color': color,
      'timestamp': timestamp,
    };
  }

  factory DataModel.fromJson(Map<String, dynamic> userData) {
    return DataModel(
      companyName: userData['companyName'],
      name: userData['name'],
      email: userData['email'],
      mobile: userData['mobile'],
      address: userData['address'],
      image: userData['image'],
      color: userData['color'],
      timestamp: userData['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'image': image,
      'color': color,
      'timestamp': timestamp,
    };
  }
}
