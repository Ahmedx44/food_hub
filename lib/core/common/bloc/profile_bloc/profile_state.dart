abstract class ProfileState {}

class ProfileStateInitial extends ProfileState {}

class ProfileStateLoading extends ProfileState {}

class ProfileStateLoaded extends ProfileState {
  final String profileImageUrl; // URL for profile image

  ProfileStateLoaded({required this.profileImageUrl});
}

class ProfileStateError extends ProfileState {
  final String message;

  ProfileStateError({required this.message});
}
