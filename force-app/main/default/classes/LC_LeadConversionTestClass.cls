@isTest
private class LC_LeadConversionTestClass {
    @TestSetup
    private static void makeData(){
        List<Lead> leadList = TestDataFactory.createSObjectList('Lead',10);
    }
    @isTest
    private static void testConvertLead(){
        List<Lead> leadList = [SELECT Id, LastName, Company, isConverted FROM Lead WHERE isConverted = False];
        List<Database.LeadConvertResult> leadConvertResultList = LC_LeadConversion.convertLead(leadList);
        for(Database.LeadConvertResult lcr : leadConvertResultList){
            System.debug('lcr result: ' + lcr);
        }
    }
}
