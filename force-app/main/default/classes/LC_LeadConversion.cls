global without sharing class LC_LeadConversion {
    @InvocableMethod(label = 'Convert Lead' description='Returns the List of Converted Leads')
    global static List<Lead> convertLead(List<List<Lead>> leadIdList){
        // Get all the fields unique to the Salesforce Org
        Lead[] leadFlowList = leadIdList.get(0);
        String leadFieldString = '';
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get('Lead');
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();

        for(String fieldName : MapofField.keySet()) {
            Schema.SObjectField field = MapofField.get(fieldName);
            Schema.DescribeFieldResult F = field.getDescribe();
            leadFieldString += String.valueOf(field) + ', ';
        }
        leadFieldString = leadFieldString.left(leadFieldString.length()-2) + '';

        // Map out the parameter IN for the Query
        String leadListConvertString =  '(';
        for(Lead i : leadFlowList){
            leadListConvertString += '\''+i.Id+'\',';
        }
        leadListConvertString = leadListConvertString.left(leadListConvertString.length()-1) + ')';

        // Finalize the Query String
        String queryString = 'SELECT ' + leadFieldString + ' FROM Lead WHERE IsConverted = False AND Id IN ' + leadListConvertString;

        // Query the List
        List<Lead> leadList = Database.query(queryString);

        List<Database.LeadConvert> leadConvertList = new List<Database.LeadConvert>();
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        for (Lead l : leadList) {
            if(l.IsConverted == False){
                Database.LeadConvert leadConvert = new Database.LeadConvert();
                leadConvert.setLeadId(l.Id);
                leadConvert.setConvertedStatus(convertStatus.MasterLabel);
                // Add account if related
                if(l.Account__c != null){
                    leadConvert.setAccountId(l.Account__c);
                }
                leadConvertList.add(leadConvert);
            }
        }
        List<Database.LeadConvertResult> leadConvertResultList = Database.convertLead(leadConvertList);
        return leadList;
    }
    global class LC_ConvertLeadResult{
        @InvocableVariable
        global ID accountId;

        @InvocableVariable
        global ID contactId;

        @InvocableVariable
        global ID opportunityId;

        @InvocableVariable
        global Account[] accountList;

        @InvocableVariable
        global Contact[] contactList;

        @InvocableVariable
        global Opportunity[] opportunityList;
    }
}
