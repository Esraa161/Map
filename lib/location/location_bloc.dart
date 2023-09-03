import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_event.dart';
import 'location_state.dart';
import 'package:location/location.dart';
class UserLocationBloc extends Bloc<LocationEvent , LocationStatus>{
  UserLocationBloc() : super(InitLocation()){
    on<LocationEvent>((event, emit) async {
      if(event is EnableLocationService){
        await Location().serviceEnabled().then((value){
          if(value == false){
            Location().requestService().then((value){
              if(value == true){
                emit(LocationServiceEnabledSuccessfully());
              }else{
                emit(LocationServiceEnabledFailed());
              }
            }).catchError((e){
              emit(LocationServiceEnabledFailed());
            });
          }else{
            emit(LocationServiceEnabledSuccessfully());
          }
        }).catchError((onError){
          emit(LocationServiceEnabledFailed());
        }).whenComplete((){
        });
      }
      else if(event is RequestLocationPermission){
        await Location().hasPermission().then((value) async {
          if(value == PermissionStatus.denied){
            await Location().requestPermission().then((value){
              if(value == true){
                emit(PermissionRequestedSuccessfully());
              }else{
                emit(PermissionRequestedFailed());
              }
            }).catchError((e){
              emit(PermissionRequestedFailed());
            });
          }
          else if(value == PermissionStatus.deniedForever ){
            await Location().requestPermission().then((value){
              if(value == true){
                emit(PermissionRequestedSuccessfully());
              }else{
                emit(PermissionRequestedFailed());
              }
            }).catchError((e){
              emit(PermissionRequestedFailed());
            });
          }
          else if(value == PermissionStatus.granted ){
            emit(PermissionRequestedSuccessfully());
          }
          else if(value == PermissionStatus.grantedLimited ){
            emit(PermissionRequestedSuccessfully());
          }
        }).
        catchError((e){
          emit(PermissionRequestedFailed());
        });
      }
      else if (event is GetCurrentLocation){
        await Location().getLocation().then((value) {
          emit(LocationGetSuccessfully(latitude: value.latitude! , longitude: value.longitude! , address: ""));
        }).catchError((e){
          emit(LocationGetFailed());
        });
      }
    });
  }
}