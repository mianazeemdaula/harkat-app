class LocationResponse<T> {
  LSStatus status;
  T data;
  String message;

  LocationResponse.serviceDisabled(this.message)
      : status = LSStatus.ServiceDisabled;
  LocationResponse.permissionDenied(this.message)
      : status = LSStatus.PermissonDenied;
  LocationResponse.streamLocation(this.data) : status = LSStatus.StreamLocation;
  LocationResponse.error(this.message) : status = LSStatus.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum LSStatus { ServiceDisabled, PermissonDenied, StreamLocation, ERROR }
