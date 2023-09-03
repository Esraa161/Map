class LocationStatus {}

class LoadingLocation extends LocationStatus {}
class InitLocation extends LocationStatus {}

class PermissionRequestedSuccessfully extends LocationStatus {}
class PermissionRequestedFailed extends LocationStatus {}

class LocationServiceEnabledSuccessfully extends LocationStatus {}
class LocationServiceEnabledFailed extends LocationStatus {}

class LocationGetSuccessfully extends LocationStatus {
  late String address ;
  late double longitude , latitude ;
  LocationGetSuccessfully({required this.longitude , required this.latitude , required this.address});
}
class LocationGetFailed extends LocationStatus {}