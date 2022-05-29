public without sharing class LC_LeadConversion {
    @InvocableMethod(label = 'Convert Lead' description='Returns the List of Converted Leads')
    public static List<Lead> convertLead(List<Id> leadIdList){
        // Get All Lead Fields from the Org


        List<Database.LeadConvert> leadConvertList = new List<Database.LeadConvert>();
        Lead[] leadList = [SELECT Id, IsConverted FROM Lead WHERE Id IN : leadIdList];
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        for (Lead l : leadList) {
            if(l.IsConverted == False){
                Database.LeadConvert leadConvert = new Database.LeadConvert();
                leadConvert.setLeadId(l.Id);
                leadConvert.setConvertedStatus(convertStatus.MasterLabel);
                leadConvertList.add(leadConvert);
            }
        }
        List<Database.LeadConvertResult> leadConvertResultList = Database.convertLead(leadConvertList);
        return leadList;
    }
}
