class PlacesNearbySearchResponse {
  final List<String> htmlAttributions;
  final String status;
  final List<Place> results;
  final String? errorMessage;
  final String? infoMessage;
  final String? nextPageToken;

  PlacesNearbySearchResponse(
      {required this.htmlAttributions,
      required this.status,
      required this.results,
      this.errorMessage,
      this.infoMessage,
      this.nextPageToken});

  factory PlacesNearbySearchResponse.fromJson(Map<String, dynamic> json) {
    return PlacesNearbySearchResponse(
        htmlAttributions: List<String>.from(json['html_attributions']),
        status: json['status'],
        results:
            (json['results'] as List).map((e) => Place.fromJson(e)).toList(),
        errorMessage: json['error_message'],
        infoMessage: json['info_message'],
        nextPageToken: json['next_page_token']);
  }
}

class Place {
  final String? adrAddress;
  final String? businessStatus;
  final String? formattedAddress;
  final String? icon;
  final String? name;
  final String? placeId;
  final String? reference;
  final String? vicinity;
  final List<String>? types;
  final Geometry? geometry;
  final List<Photo>? photos;

  Place(
      {this.adrAddress,
      this.businessStatus,
      this.formattedAddress,
      this.icon,
      this.name,
      this.placeId,
      this.reference,
      this.vicinity,
      this.types,
      this.geometry,
      this.photos});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        adrAddress: json['adr_address'],
        businessStatus: json['business_status'],
        formattedAddress: json['formatted_address'],
        icon: json['icon'],
        name: json['name'],
        placeId: json['place_id'],
        reference: json['reference'],
        vicinity: json['vicinity'],
        types: List<String>.from(json['types']),
        geometry: Geometry.fromJson(json['geometry']),
        photos: json['photos'] != null
            ? (json['photos'] as List).map((e) => Photo.fromJson(e)).toList()
            : null);
  }
}

class Geometry {
  final Location location;
  final Viewport viewport;

  Geometry({required this.location, required this.viewport});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
        location: Location.fromJson(json['location']),
        viewport: Viewport.fromJson(json['viewport']));
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(lat: json['lat'], lng: json['lng']);
  }
}

class Viewport {
  final Location northeast;
  final Location southwest;

  Viewport({required this.northeast, required this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
        northeast: Location.fromJson(json['northeast']),
        southwest: Location.fromJson(json['southwest']));
  }
}

class Photo {
  final int height;
  final List<String> htmlAttributions;
  final String photoReference;
  final int width;

  Photo(
      {required this.height,
      required this.htmlAttributions,
      required this.photoReference,
      required this.width});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        height: json['height'],
        htmlAttributions: List<String>.from(json['html_attributions']),
        photoReference: json['photo_reference'],
        width: json['width']);
  }
}
