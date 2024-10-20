import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hub/core/common/bloc/profile_bloc/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileStateInitial());

  Future<void> getProfile() async {
    emit(ProfileStateLoading());
    try {
      // Fetch user profile data from Firestore
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(ProfileStateError(message: "User not authenticated"));
        return;
      }

      final userDoc =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        final profileUrl = userData?['imageUrl'] ?? '';
        print(profileUrl);
        print('hello');
        emit(ProfileStateLoaded(profileImageUrl: profileUrl));
      } else {
        emit(ProfileStateError(message: "User profile not found"));
      }
    } catch (e) {
      emit(ProfileStateError(message: e.toString()));
    }
  }
}
