@RestResource(urlMapping='/CampingItem/*')
global with sharing class restCampResource {

    @HttpGet
    global static Account doGet(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String sId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name  FROM Account WHERE Id= :sId];

        return result;

    }
    // 0012v00002R1k7qAAB
}