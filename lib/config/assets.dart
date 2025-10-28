abstract class Assets {
  static const String logo = "assets/brand/logo_light.svg";

  static const String destinations = "assets/tourist_api/destinations.json";

  static const String createDbScript = "assets/sql/create_db.sql";
  static String destinationImage(int id) {
    const min = 1;
    const max = 50;

    if (id < min || id > max) {
      throw ArgumentError("ID must be between $min and $max. $id given");
    }

    return "assets/tourist_api/images/$id.jpg";
  }
}
