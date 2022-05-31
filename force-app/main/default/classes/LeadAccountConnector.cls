global without sharing class LeadAccountConnector {
    @InvocableMethod(label = 'Lead Account Connector' Description = 'Matches Leads to Accounts based on the email or website domain of the lead and existing Accounts')
    global static List<List<Lead>> leadAccountConnector(){
        List<Lead> leadList = [SELECT Id, Name, email_domain__c, website_domain__c, Connect_Account__c, Account__c FROM Lead WHERE IsConverted = False AND Connect_Account__c = True AND Account__c = null];

        Set<String> domainSet = new Set<String>();
        Map<String, lead> leadDomainMap = new Map<String, Lead>();
        Map<Id, Lead> leadUpdateMap = new Map<Id, Lead>();
        
        for(Lead l : leadList){
            if(l.email_domain__c != null && domainSet.contains(l.email_domain__c) != true){
                domainSet.add(l.email_domain__c);
                leadDomainMap.put(l.email_domain__c, l);
                leadUpdateMap.put(l.id, l);
            }
            if(l.website_domain__c != null && domainSet.contains(l.website_domain__c) != true){
                domainSet.add(l.website_domain__c);
                leadDomainMap.put(l.website_domain__c, l);
                leadUpdateMap.put(l.id, l);
            }
        }
        Account[] accList = [SELECT Id, Name, domain__c FROM Account WHERE domain__c IN :domainSet];
        
        for(Account acc : accList){
            if(leadDomainMap.get(acc.domain__c) != null){
                Lead l = leadDomainMap.get(acc.domain__c);
                l.Account__c = acc.id;
                l.Connect_Account__c = false;
                leadUpdateMap.put(l.id, l);
            }
        }
        List<List<Lead>> returnList = new List<List<Lead>>();
        returnList.add(leadUpdateMap.values());
        return returnList;
    }
}
