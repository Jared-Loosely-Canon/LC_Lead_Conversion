global without sharing class LeadManagementSettings {
    @InvocableMethod(Label='Update Lead Management Settings' Description='Used to Update the Custom Meta Data since Flows can not')
    global static void updateLeadManagementSettings(){
        List<Lead_Management_Settings_mdt> lmsList = Lead_Management_Settings_mdt.getAll().values();
        Lead_Management_Settings_mdt lms = lmsList[0];
        lms.Auto_convert__c = false;
        lms.Relate_To_Account__c = false;
        update lms;
        return lms;
    }
}
