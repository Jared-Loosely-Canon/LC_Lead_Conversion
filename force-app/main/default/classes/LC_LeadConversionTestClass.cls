@isTest
private class LC_LeadConversionTestClass {
    @TestSetup
    private static void makeData(){
        List<Lead> leadList = TestDataFactory.createSObjectList('Lead', 100);
    }
    @isTest
    private static void testConvertLead(){
        Map<Id,Lead> leadMap = new Map<Id,Lead>([SELECT Id FROM Lead WHERE isConverted = False]);
        List<Id> idList = new List<id>(leadMap.keySet());
        List<List<Lead>> leadFlowList = new List<List<Lead>>();
        leadFlowList.add(leadMap.values());
        List<Lead> leadConvertResultList = LC_LeadConversion.convertLead(leadFlowList);
        List<Id> leadReturnIdList = new List<Id>();
        for(Lead l : leadConvertResultList){
            leadReturnIdList.add(l.id);
        }
        Lead[] updatedLeadList = [SELECT Id, isConverted FROM Lead WHERE Id IN : leadReturnIdList];
        for(Lead l : updatedLeadList){
            System.debug('updatedLeadList result: ' + l);
            Boolean expected = true;
            Boolean actual = l.IsConverted;
            String msg = 'The Lead was not converted';
            System.assertEquals(expected, actual, msg);
        }
    }
}
