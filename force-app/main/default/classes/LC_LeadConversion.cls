public without sharing class LC_LeadConversion {
    public static List<Database.LeadConvertResult> convertLead(List<Lead> leadList){
        List<Database.LeadConvert> leadConvertList = new List<Database.LeadConvert>();
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
        return leadConvertResultList;
    }
}
