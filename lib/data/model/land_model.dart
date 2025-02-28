class LandModel {
  final String addedBy;
  final bool approved;
  final String contactNumber;
  final String description;
  final String district;
  final String place;
  final double latitude;
  final double longitude;
  final String ownerName;
  final Price price;
  LandModel(
      {required this.addedBy,
      required this.district,
      required this.place,
      required this.approved,
      required this.contactNumber,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.ownerName,
      required this.price});

  factory LandModel.fromjson(Map<String, dynamic> land) {
    return LandModel(
        addedBy: land['addedBy'],
        approved: land['approved'],
        contactNumber: land['contact_number'],
        description: land['description'],
        latitude: land['latitude'],
        longitude: land['longitude'],
        ownerName: land['owner_name'],
        price: Price.fromjson(land['price']),
        district: land['district'],
        place: land['place']);
  }
}

class Price {
  final String auto;
  final String bicycle;
  final String car;
  final String bike;
  final String heavy;

  Price(
      {required this.auto,
      required this.bike,
      required this.car,
      required this.bicycle,
      required this.heavy});

  factory Price.fromjson(Map<String, dynamic> price) {
    return Price(
        auto: price["auto"] ?? '',
        bike: price['bike'] ?? '',
        car: price['car'] ?? '',
        bicycle: price['bicycle'] ?? '',
        heavy: price['heavy'] ?? '');
  }
}
