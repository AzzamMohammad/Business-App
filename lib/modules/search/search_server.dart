import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../models/Facility_filtering_types.dart';
import '../../models/searsh_results.dart';

class SearchServer{
  bool State = false;
  int CurrentPage = 0;
  int LastPage = 0;
  String NextPageUrl = '';
  bool IsLoaded = false;
  var FilteringTypesUrl = Uri.parse(ServerConfig.ServerDomain + ServerConfig.FilteringTypesURL);
  var GetNewResultsUrl = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetNewSearchingResultsURL);
  Future<List<FilteringTypes>> GetFacilityFilteringTypes(String Token)async{
    try{
      var jsonResponse = await http.get(FilteringTypesUrl,headers: {
        'Accept':'application/json',
        'auth-token':'${Token}'
      });
      if(jsonResponse.statusCode == 200){
        var response = facilityFilteringTypesFromJson(jsonResponse.body);
        print(response.msg);
        if(response.status == true){

          State = true;
          return response.data;
        }
        State = false;
        return [];
      }else{
        State = false;
        return [];
      }

    }catch(e){
      print(e);
      State = false;
      return [];
    }
  }

  Future<List<SearchResult>> GetNewSearchingResults(String Token , String? TextSearching  ,String NextPageURL,int?Country, int?City , int? Town)async{
    var NextUrl;
    IsLoaded = false;
    if(NextPageURL == '')
      NextUrl = GetNewResultsUrl;
    else
      NextUrl = Uri.parse(NextPageURL);
    try{
      var jsonResponse = await http.post(
        NextUrl,
        headers: {
          'Accept':'application/json',
          'auth-token' : '${Token}'
        },
        body: {
          if(TextSearching!=null)
          'name':'${TextSearching}',
          if(Country!=null)
          'countries_id':'${Country}',
          if(City!=null)
          'cities_id':'${City}',
          if(Town!=null)
          'regions_id':'${Town}',
        }
      );
      if(jsonResponse.statusCode == 200){
        var response = searchResultsFromJson(jsonResponse.body);
        if(response.status){
          CurrentPage = response.data.currentPage;
          LastPage = response.data.lastPage;
          if(response.data.nextPageUrl != null)
            NextPageUrl = response.data.nextPageUrl;
          else
            NextPageUrl = '';
          IsLoaded = true;
          return response.data.data;
        }else{
          IsLoaded = false;
          return[];
        }
      }else{
        IsLoaded = false;
        return[];
      }
    }catch(e){
      print(e);
      IsLoaded = false;
      return [];
    }

  }



}

