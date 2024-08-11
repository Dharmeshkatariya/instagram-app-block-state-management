abstract class FirestoreAddNewUserState {}

class CubitInitial extends FirestoreAddNewUserState {}

class CubitUserAdding extends FirestoreAddNewUserState {}

class CubitUserAdded extends FirestoreAddNewUserState {}

class CubitAddNewUserFailed extends FirestoreAddNewUserState {
  final String error;
  CubitAddNewUserFailed(this.error);
}
