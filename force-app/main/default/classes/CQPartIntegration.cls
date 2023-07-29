public class CQPartIntegration {
    public static String LOW_VOLUME = Label.Low_Volume_Account;
    public static String HIGH_VOLUME = Label.High_Volume_Account;
    
    @AuraEnabled
    public static String makeCalloutToGetPartData() {
        response resObj = new response();
        try{
            CQ_Parts__c cqPartCreds = CQ_Parts__c.getInstance('CQ Parts');
            String apiKey = cqPartCreds.API_Key__c;
            String BaseURL = cqPartCreds.Base_URL__c;
            
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-type', 'application/json');
            req.setHeader('x-api-key', apiKey);
            req.setEndpoint(BaseURL + 'rest/cqpart');
            req.setMethod('GET');
            
            http httpObj = new Http();
            
            HttpResponse res = httpObj.send(req);
            System.debug(res.getStatusCode());
            System.debug(res.getBody());
            if(res != null && res.getStatusCode() == 200) {
                List<Object> lstResponses = (List<Object>) JSON.deserializeUntyped(res.getBody());
                if(lstResponses != null && lstResponses.size() > 0) {
                    List<String> lstStringAcntName = new List<String>{LOW_VOLUME, HIGH_VOLUME};
                        
                        List<Account> lstAccounts = [Select Id, Name From Account where Name in: lstStringAcntName ];
                    Map<String, Id> mapAcntNameToId = new Map<String, Id>();
                    
                    for(Account act : lstAccounts) {
                        if(act.Name != null) {
                            if(act.Name.toLowercase() == HIGH_VOLUME.toLowercase()) {
                                mapAcntNameToId.put(act.Name.toLowercase(), act.Id);
                            } else if(act.Name.toLowercase() == LOW_VOLUME.toLowercase()) {
                                mapAcntNameToId.put(act.Name.toLowercase(), act.Id);
                            }
                        }   
                    }
                    
                    List<SQX_Part__c> lstParts = new List<SQX_Part__c>();
                    
                    
                    for(Object partObj : lstResponses) {
                        Map<String, Object> mapParts = (Map<String, Object>) partObj;
                        if(mapParts != null && mapParts.get('_id') != null && mapParts.get('Total Quantity Shipped') != null) {
                            String partId = (String)mapParts.get('_id');
                            SQX_Part__c sqPart = new SQX_Part__c(Part_Number__c=partId);
                            sqPart.Active__c = true;
                            sqPart.Name = (String)mapParts.get('Part Name');
                            Integer qty = (Integer)mapParts.get('Total Quantity Shipped');
                            if(qty < 99) {
                                sqPart.Related_Account__c = mapAcntNameToId.get(HIGH_VOLUME.toLowercase());
                            } else if(qty >= 99) {
                                sqPart.Related_Account__c = mapAcntNameToId.get(LOW_VOLUME.toLowercase());
                            }
                            lstParts.add(sqPart);
                        }
                    }
                    
                    if(lstParts != null && lstParts.size() > 0) {
                        Database.upsert(lstParts, SQX_Part__c.Part_Number__c, false);
                        resObj.isSuccess = true;
                        resObj.message = 'The part records are synced successfully';
                    }    
                }
                
                if(lstResponses == null || lstResponses.size() == 0) {
                    resObj.isSuccess = false;
                    resObj.message = 'No record found.';
                }
                
            }
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            resObj.isSuccess = false;
            resObj.message = ex.getMessage();
        }
        
        return JSON.serialize(resObj);
    }
    
    public class response {
        public String message {get;set;}
        public Boolean isSuccess {get;set;}
    }
}