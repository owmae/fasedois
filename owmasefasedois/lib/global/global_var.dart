import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
String userEmail = "";
String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;

String googleMapKey = "AIzaSyDuDxriw8CH8NbVLiXtKFQ2Nb64AoRSdyg";
String serverKeyFCM = "key=AAAAgCdAZ_Y:APA91bGzHO0syA7YydwcZeUTsev1GXcEFD8uugpu6Wh-FLqbGCpCc07nrRVg8TUPbvGf1oJNhurjqSHgeYD6Wr6gComZQmaj1GocYmNfdos9FnBS6S9DJYkLpmKIroYqDBQSE-SQffi3";

const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

