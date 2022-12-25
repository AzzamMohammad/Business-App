import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/searsh_results.dart';


class AllFacilityForOwnerServer{
  bool IsLoaded = false;
  String NextPageUrl = '';
  int CurrentPage = 0;
  int LastPage = 0;

  var FacilityForOwnerRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.FacilityForOwnerURL);

  Future<List<SearchResult>> GetNewFacility(String Token , String NextPageURL)async{
    var NextUrl;
    IsLoaded = false;
    if(NextPageURL == '')
      NextUrl = FacilityForOwnerRoute;
    else
      NextUrl = Uri.parse(NextPageURL);
    try{
      var jsonResponse = await http.get(
          NextUrl,
          headers: {
            'Accept':'application/json',
            'auth-token' : '${Token}'
          },
      );
      if(jsonResponse.statusCode == 200){
        IsLoaded = true;
        var response = searchResultsFromJson(jsonResponse.body);
        print(response.status);
        if(response.status){
          CurrentPage = response.data.currentPage;
          LastPage = response.data.lastPage;
          if(response.data.nextPageUrl != null)
            NextPageUrl = response.data.nextPageUrl;
          else
            NextPageUrl = '';
          // IsLoaded = true;
          return response.data.data;
        }else{
          //ToDo : Delete IsLoaded from here and from line 40 and add ander "if(jsonResponse.statusCode == 200){" with value true
          // IsLoaded = false;
          return[];
        }
      }else{
        // IsLoaded = false;
        return[];
      }
    }catch(e){
      print(e);
      // IsLoaded = false;
      return [];
    }

  }
}