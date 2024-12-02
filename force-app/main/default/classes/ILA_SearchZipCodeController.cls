/**
* @File Name : ILA_SearchZipCodeController.cls
* @Description : Controller class for Zip code search functionality
* @Author : ARUN
* @Last Modified By :
* @Last Modified On : November 28, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 28, 2024 |   | Initial Version
**/

public class ILA_SearchZipCodeController {
    @AuraEnabled 
    Public static void saveData(string data){  
        try{        
            String dataWrap =	data.replaceAll('post code','post_code').replaceAll('country abbreviation','country_abbreviation').replaceAll('place name','place_name').replaceAll('state abbreviation','state_abbreviation');
            ILA_SearchZipCodeWrapper wrap = (ILA_SearchZipCodeWrapper)JSON.deserialize(dataWrap, ILA_SearchZipCodeWrapper.class);
            // system.debug('wrap'+wrap);
            if(wrap != null){
                ILA_Zipcode__c zip = new ILA_Zipcode__c();
                zip.Name = wrap.country_abbreviation +' ' +wrap.places[0].state_abbreviation +' '+wrap.post_code;
                zip.ILA_Country__c = wrap.country;
                zip.ILA_Country_code__c = wrap.country_abbreviation;
                zip.ILA_Country_abbreviation__c=wrap.country_abbreviation;
                zip.ILA_Post_code__c = wrap.post_code;
                zip.ILA_Lat_Long__Latitude__s = decimal.ValueOf(wrap.places[0].latitude);
                zip.ILA_Lat_Long__Longitude__s = decimal.ValueOf(wrap.places[0].longitude);
                zip.ILA_State__c =wrap.places[0].state;
                zip.ILA_State_abbreviation__c =wrap.places[0].state_abbreviation;
                zip.ILA_Place_Name__c = wrap.places[0].place_name;       
                insert zip;
            }
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
    }
    
    @InvocableMethod
    public static List<String> makeHttpRequest(List<RequestParams> request) {
        List<String> responses = new List<String>();      
        try {
            if(!request.isEmpty()){
                String country = request.get(0).country;
                String zipCode = request.get(0).zipCode;
               // String url = 'http://api.zippopotam.us/'+country+'/'+zipCode;
                String url = 'callout:ILA_zippopotamus/'+country+'/'+zipCode;
                // Create HTTP request
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url); 
                req.setMethod('GET'); 
                req.setHeader('Content-Type', 'application/json');
                
                // Send HTTP request
                HttpResponse res = http.send(req);                
                // Check the response status and add to the result list
                if (res.getStatusCode() == 200) {
                    responses.add(res.getBody());
                    if(country != null &&  country != 'US'){
                        saveData(responses[0]); // for saving non US data on Salesforce 
                    }
                } else {
                    responses.add('Error: ' + res.getStatus());
                }              
            }
        } catch (Exception e) {
            responses.add('Error: ' + e.getMessage());
        }    
        return responses; // Pass the response(s) back to the Flow        
    }   
    
    public class RequestParams{        
        @InvocableVariable
        public String country;
        @InvocableVariable
        public String zipCode;  
    }
    
    
}