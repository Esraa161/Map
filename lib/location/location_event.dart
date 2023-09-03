
abstract class LocationEvent {}

class EnableLocationService extends LocationEvent {}

class RequestLocationPermission extends LocationEvent {}

class GetCurrentLocation extends LocationEvent {}
