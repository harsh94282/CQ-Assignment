@isTest
public class CQPartIntegrationTest {
    @TestSetup
    static void makeData(){
        CQ_Parts__c cqPartCreds = new CQ_Parts__c();
        cqPartCreds.Name = 'CQ Parts';
        cqPartCreds.API_Key__c = 'abcdefgh';
        cqPartCreds.Base_URL__c = 'https://cqparts-3d06.restdb.io/';
        insert cqPartCreds;
        
        List<Account> lstAccounts = new List<Account>();
        
        Account act1 = new Account();
        act1.Name = 'Low Volume';
        lstAccounts.add(act1);
        
        Account act2 = new Account();
        act2.Name = 'High Volume';
        lstAccounts.add(act2);
        
        insert lstAccounts;
    }
    
    public static testmethod void method1() {
        Test.setMock(HttpCalloutMock.Class, new MockHttpResponseGenerator());
        Test.startTest();
        String res = CQPartIntegration.makeCalloutToGetPartData();
        CQPartIntegration.response resObj = (CQPartIntegration.response)JSON.deserialize(res, CQPartIntegration.response.class);
        System.assertEquals(true, resObj.isSuccess);
        Test.stopTest();
    }
}