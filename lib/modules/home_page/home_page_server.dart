import 'package:business_01/models/facilitis_follow.dart';
  import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/posts_of_following_facility.dart';


class HomePageServer{

  var GetFacilityFollowListRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFacilityFollowListURL);
  var GetFacilityPostsListRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFacilityPostsListURL);
  var GetAdminPostsListRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetAdminPostsListURL);
  String Message = '';
  bool IsLoaded = false;
  String NextPageUrl = '';
  int CurrentPage = 0;
  int CurrentPageFollowFacility= 0;
  int LastPageFollowFacility = 0;
  int LastPage = 0;
  Future<List<FacilityFollow>> GetNewFacilityFollowItems(String Token , String NextPage) async{
    IsLoaded = false;
    var PageUrl ;
    if(NextPage == '')
      PageUrl = GetFacilityFollowListRoute;
    else
      PageUrl = NextPage;
    // try{
      var jsonResponse = await http.get(PageUrl,
        headers: {
          'auth-token':'${Token}',
          'Accept': 'application/json',
        }
      );
      if(jsonResponse.statusCode == 200){
        FacilitisFollow response = facilitisFollowFromJson(jsonResponse.body);
        if(response.status == true){
          IsLoaded = true;
          if(response.data.nextPageUrl != null)
            NextPageUrl = response.data.nextPageUrl;
          else
            NextPageUrl = '';
          CurrentPageFollowFacility = response.data.currentPage;
          LastPageFollowFacility = response.data.lastPage;
          return response.data.data;
        }else{
          return [];
        }

      }else{
        return [];
      }
    // }catch(e){
    //   print(e);
    //   return [];
    // }
  }

  Future<List<FollowFacilityPost>> GetNewFacilityPostsItems(String Token , String NextPage) async{
    IsLoaded = false;
    CurrentPage = 0;
    LastPage = 0 ;
    var PageUrl ;
    if(NextPage == '')
      PageUrl = GetFacilityPostsListRoute;
    else
      PageUrl = Uri.parse(NextPage);
    try{
      var jsonResponse = await http.get(PageUrl,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          }
      );
      if(jsonResponse.statusCode == 200){

        PostsOfFollowingFacility response = postsOfFollowingFacilityFromJson(jsonResponse.body);
        if(response.status == true){
          IsLoaded = true;
          if(response.data.nextPageUrl != null)
            NextPageUrl = response.data.nextPageUrl;
          else
            NextPageUrl = '';
          CurrentPage = response.data.currentPage;
          LastPage = response.data.lastPage;
          return response.data.data;
        }else{
          return [];
        }

      }else{
        return [];
      }
    }catch(e){
      print(e);
      return [];
    }
  }

  Future<List<FollowFacilityPost>> GetNewAdminPostsItems(String Token , String NextPage) async{
    IsLoaded = false;
    CurrentPage = 0;
    LastPage = 0 ;
    var PageUrl ;
    if(NextPage == '')
      PageUrl = GetAdminPostsListRoute;
    else
      PageUrl = Uri.parse(NextPage);
    try{
      var jsonResponse = await http.get(PageUrl,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          }
      );
      if(jsonResponse.statusCode == 200){
        PostsOfFollowingFacility response = postsOfFollowingFacilityFromJson(jsonResponse.body);
        if(response.status == true){
          IsLoaded = true;
          if(response.data.nextPageUrl != null)
            NextPageUrl = response.data.nextPageUrl;
          else
            NextPageUrl = '';
          CurrentPage = response.data.currentPage;
          LastPage = response.data.lastPage;
          return response.data.data;
        }else{
          return [];
        }

      }else{
        return [];
      }
    }catch(e){
      print(e);
      return [];
    }
  }


}