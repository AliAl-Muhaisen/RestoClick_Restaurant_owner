import 'dart:io';

class Restaurant {
  String? _restaurantName;
  File? _workLicense;
  File? _commercialRegistry;
  String? _address;
  Restaurant();

  String? get address => _address;

  String? get restaurantName => _restaurantName;

  File? get workLicense => _workLicense;

  File? get commercialRegistry => _commercialRegistry;

  void setAddress(String address) {
    _address = address;
  }

  void setRestaurantName(String restaurantName) {
    _restaurantName = restaurantName;
  }

  void setWorkLicense(File workLicense) {
    _workLicense = workLicense;
  }

  void setCommercialRegistry(File commercialRegistry) {
    _commercialRegistry = commercialRegistry;
  }
}
