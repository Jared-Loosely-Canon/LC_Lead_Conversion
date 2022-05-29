@isTest
private class LC_LeadConversionTestClass {
    @TestSetup
    private static void makeData(){
        List<Lead> leadList = TestDataFactory.createSObjectList('Lead',10);
    }
    @isTest
    private static void testConvertLead(){
        Map<Id,Lead> leadMap = new Map<Id,Lead>([SELECT Id FROM Lead WHERE isConverted = False]);
        List<Id> idList = new List<id>(leadMap.keySet());
        List<Lead> leadConvertResultList = LC_LeadConversion.convertLead(idList);
        for(Lead l : leadConvertResultList){
            System.debug('lcr result: ' + l);
        }
    }
}
