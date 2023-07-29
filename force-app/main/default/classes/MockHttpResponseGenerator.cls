@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req){
        try{
            if(req.getEndpoint() == 'https://cqparts-3d06.restdb.io/rest/cqpart'  && req.getMethod() == 'GET'){
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type','application/json');
                res.setBody('[' +
                            '    {' +
                            '        "_id": "619683d69402c24f000237e9",' +
                            '        "Part Name": "Population Sensor",' +
                            '        "Total Quantity Shipped": 350000' +
                            '    },' +
                            '    {' +
                            '        "_id": "619643769402c24f000229ec",' +
                            '        "Part Name": "Drill Gauge",' +
                            '        "Total Quantity Shipped": 125000' +
                            '    },' +
                            '    {' +
                            '        "_id": "629989816a50f02a0000b83e",' +
                            '        "Part Name": "Pressure Adapt",' +
                            '        "Total Quantity Shipped": 12' +
                            '    },' +
                            '    {' +
                            '        "_id": "619643919402c24f000229ef",' +
                            '        "Part Name": "Population Sensor",' +
                            '        "Total Quantity Shipped": 125000' +
                            '    },' +
                            '    {' +
                            '        "_id": "62998ecc6a50f02a0000b87d",' +
                            '        "Part Name": "Pressure Sensor",' +
                            '        "Total Quantity Shipped": 100' +
                            '    }' +
                            ']');
                res.setStatusCode(200);
                return res;
            }
        }catch(Exception ex){
            System.debug('ERROR Message>>>'+ex.getMessage()+' Error Line Number>>> '+ex.getLineNumber());
        }
        return null;
    }
}