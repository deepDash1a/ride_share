class PlacesSuggestion {
  late String placeId;
  late String description;
  late String name;

  PlacesSuggestion.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    description = json['formatted_address'];
    name = json['name'];
  }
}
