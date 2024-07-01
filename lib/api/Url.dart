class Url {
  String baseUrl = "http://192.168.2.24:3000/";

  // Authentication
  String sendOTP = "api/v1/auth/sendOTP";
  String verifyOTP = "api/v1/auth/verifyOTP";
  String registerUser = "api/v1/auth/registerUser";

  // Messages
  String sendMessage = "api/v1/message/send";
  String messagedProfiles = "api/v1/message/profiles";
  String conversation = "api/v1/message/conversation";

  // Profile
  String getMyProfile = "api/v1/profile";
  String getUser = "api/v1/profile/getProfile";
  String likeProfile = "api/v1/profile/like";
  String unlikeProfile = "api/v1/profile/unlike";
  String getLikedProfiles = "api/v1/profile/likedProfiles";
  String editProfile = "api/v1/profile/edit";
  String searchProfiles = "api/v1/profile/search";

  // Favourites
  String getFavouriteProfiles = "api/v1/profile/favourite";
  String addFavouriteProfile = "api/v1/profile/addFavourite";
  String removeFavouriteProfile = "api/v1/profile/removeFavourite";
}
