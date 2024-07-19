class Url {
  String baseUrl = "http://datingappbackend-env.eba-ux233cmv.ap-south-1.elasticbeanstalk.com/";

  // Authentication
  String sendOTP = "api/v1/auth/sendOTP";
  String verifyOTP = "api/v1/auth/verifyOTP";
  String registerUser = "api/v1/auth/registerUser";

  //upload Image
  String uploadImage = "api/v1/upload";

  // Messages
  String sendMessage = "api/v1/message/send";
  String messagedProfiles = "api/v1/message/profiles";
  String conversation = "api/v1/message/conversation";

  // Profile
  String getProfile = "api/v1/profile/getProfile";
  String likeProfile = "api/v1/profile/like";
  String unlikeProfile = "api/v1/profile/unlike";
  String getLikedProfiles = "api/v1/profile/likedProfiles";
  String editProfile = "api/v1/profile/edit";
  String searchProfiles = "api/v1/profile/search";
  String profilesLikedMe = 'api/v1/profile/profilelikedme';

  // Favourites
  String getFavouriteProfiles = "api/v1/profile/favourite";
  String addFavouriteProfile = "api/v1/profile/addFavourite";
  String removeFavouriteProfile = "api/v1/profile/removeFavourite";
}
