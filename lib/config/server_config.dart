class ServerConfig{
  static const ServerDomain = 'http://upkeepplus.tech';
  // static const ServerDomain = 'http://10.0.2.2:8000';
  // static const ServerDomain = 'http://192.168.114.230:8000';


  static const RegisterURL = '/api/register';
  static const LoginURL = '/api/login';
  static const CheckPinURL = '/api/email/verify';
  static const ResendPINURL = '/api/resend/email/token';
  static const InputEmailToSendPINURL = '/api/forgot-password';
  static const AllCountriesAndCitiesAndTownsURL = '/api/getAllCountry';
  static const ForgetPasswordURL = '/api/verify/pin';

  // facility
  static const GetFacilityInfoURL = '/api/showFoundation';
  static const GetFacilityImagesURL = '/api/showPhotos';
  static const GetFacilityJobsURL = '/api/showJobs';
  static const GetFacilityOffersURL = '/api/showAds';
  static const FollowFacilityURL = '/api/addFollow';
  static const UnFollowFacilityURL = '/api/deleteFollow';
  static const AddChatWithFacilityURL = '/api/addChat';


  // facility images
  static const GetFacilityImagesListURL = '/api/showPhotos';
  static const AddNewFacilityImageURL = '/api/addPhoto';
  static const EditFacilityImageURL = '/api/editPhoto';
  static const DeleteFacilityImageURL = '/api/deletePhoto';

  // facility jop
  static const AddNewFacilityJopURL = '/api/addJob';
  static const EditFacilityJopURL = '/api/editJob';
  static const DeleteFacilityJopURL = '/api/deleteJob';

  // facility offer
    static const AddNewFacilityOfferURL = '/api/addAd';
  static const EditFacilityOfferURL = '/api/editAd';
  static const DeleteFacilityOfferURL = '/api/deleteAd';

  // facility Members
  static const GetFacilityMembersURL = '/api/showCaders';
  static const AddNewFacilityMemberUrl = '/api/addCader';
  static const EditFacilityMemberUrl = '/api/editCader';
  static const DeleteFacilityMemberUrl = '/api/deleteCader';

  // HomePage
  static const GetFacilityFollowListURL = '/api/getFoundationFollow';
  static const GetFacilityPostsListURL = '/api/getJobsAndAdsFollow';
  static const GetAdminPostsListURL = '/api/getAdsAndJobsSliders';

  // Chat
  static const GetNewChatsURL = '/api/getChat';
  static const BlockTheChatURL = '/api/block';
  static const UnBlockTheChatURL = '/api/unblock';
  static const DeleteTheChatURL = '/api/deleteChatForAll';

  // ChatMessages
  static const GetChatMessagesURL = '/api/getMessageOnClickChat';
  static const SendMessagesURL = '/api/sendMessageOnChat';
  static const DeleteMessagesURL = '/api/deleteMessageForAll';

  // search
  static const FilteringTypesURL = '/api/getJobClass';
  static const GetNewSearchingResultsURL = '/api/filter';

  //logout
  static const LogoutURL = '/api/logout';

  //Complaint
  static const ComplaintURL = '/api/addComplaint';

  // Facility For Owner
  static const FacilityForOwnerURL = '/api/getAllFoundationForOwner';






}