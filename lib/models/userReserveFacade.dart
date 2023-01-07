import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:restaurant_owner_app/models/user.dart';

import 'reservation.dart';
import 'http/API/apiKey.dart';

class UserReserveFacade {
  final Reservation reserve;
  final User user;
  final String id;
  UserReserveFacade({
    required this.id,
    required this.reserve,
    required this.user,
  });

  static Future<List<UserReserveFacade>> get reserveWithUser async {
    Map<String, dynamic>? reserveDataKeys = {};
    Map<String, dynamic>? userData = {};
    List<UserReserveFacade> reservesWithUser = [];
    List<String> reserveKeys = [];

    try {
      String api = await Apikey().getRestaurantReservations();
      Uri url = Uri.parse(api.toString());

      //# Fetch data from the server
      http.Response response = await http.get(url);

      reserveDataKeys = await json.decode(response.body);
      if (reserveDataKeys?.isEmpty ?? true) return [];
      //# To convert json data to list of reserves
      reserveDataKeys!.forEach((key, value) => reserveKeys.add(key));

      for (int i = 0; i < reserveKeys.length; i++) {
        Reservation? reserve =
            await Reservation.getReservedById(reserveKeys[i]);
        if (reserve != null) {
          // if( reserve.date< DateTime.now()){

          // }
          api = await Apikey().getUserReservation(userId: reserve.userId!);
          url = Uri.parse(api.toString());
          response = await http.get(url);
          userData = await json.decode(response.body);
          User user = User.fromJsonWithCustom(userData!);

          UserReserveFacade result =
              UserReserveFacade(reserve: reserve, user: user, id: reserve.id!);
          reservesWithUser.add(result);
        }
      }

      return reservesWithUser;
    } catch (e) {
      //! Connection error or NULL response
      log("something went wrong models-> RestaurantReserveFacade file-> get reserveWithRestaurant");
      log(e.toString());
      return [];
    }
  }
}
