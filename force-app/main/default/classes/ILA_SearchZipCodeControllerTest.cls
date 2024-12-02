/**
* @File Name : ILA_SearchZipCodeControllerTest.cls
* @Description : Test class for ILA_SearchZipCodeController
* @Author : ARUN
* @Last Modified By :
* @Last Modified On : November 30, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 30, 2024 |   | Initial Version
**/

@IsTest
public class ILA_SearchZipCodeControllerTest {
    @IsTest
    static void testSaveData() {
        
        // Create test data 
       String json = '{"post code":"12345","country":"United States","country abbreviation":"US","places":[{"place name":"Schenectady","longitude":"-74.058","state":"New York","state abbreviation":"NY","latitude":"42.8333"}]}';   
            
       Test.startTest();
       ILA_SearchZipCodeController.saveData(json);
       Test.stopTest();
      
    }
     @IsTest
    static void testRequest() {
        // Set up mock response for the HTTP callout
        HttpCalloutMock mock = new ZippopotamusCalloutMock(200, '{"post code":"12345","country":"United States","country abbreviation":"US","places":[{"place name":"Schenectady","longitude":"-74.058","state":"New York","state abbreviation":"NY","latitude":"42.8333"}]}');
        Test.setMock(HttpCalloutMock.class, mock);
        
        list<ILA_SearchZipCodeController.RequestParams> reqlst = new list<ILA_SearchZipCodeController.RequestParams>(); 
        ILA_SearchZipCodeController.RequestParams req = new  ILA_SearchZipCodeController.RequestParams();
        req.country = 'us';
        req.zipCode = '12345';
        reqlst.add(req);
        
       Test.startTest();
        List<String> responses = ILA_SearchZipCodeController.makeHttpRequest(reqlst);
       Test.stopTest();
     
        // Assertions
        System.assertEquals(1, responses.size(), 'Response list should contain one item.');
    }
    
    
     @IsTest
    static void testMakeHttpRequestError() {
        // Set up mock response for an error
        HttpCalloutMock mock = new ZippopotamusCalloutMock(404, '{"error":"Not Found"}');
        Test.setMock(HttpCalloutMock.class, mock);

        ILA_SearchZipCodeController.RequestParams params = new ILA_SearchZipCodeController.RequestParams();
        params.country = 'US';
        params.zipCode = '99999'; // invalid data
        List<ILA_SearchZipCodeController.RequestParams> inputParams = new List<ILA_SearchZipCodeController.RequestParams>{ params };
        
        // Test the method
        Test.startTest();
        List<String> responses = ILA_SearchZipCodeController.makeHttpRequest(inputParams);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, responses.size(), 'Response list should contain one item.');
    }
    
    
     // Mock class for HTTP callouts
    private class ZippopotamusCalloutMock implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;
        
        public ZippopotamusCalloutMock(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }
}