Map<Id,Lead> leadMapConvert = new Map<Id,Lead>([SELECT Id FROM Lead WHERE IsConverted = False]);

// Get all the fields unique to the Salesforce Org
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
for(Id i : leadMapConvert.keySet()){
    leadListConvertString += '\''+i+'\',';
}
leadListConvertString = leadListConvertString.left(leadListConvertString.length()-1) + ')';
System.debug('leadListConvertString = ' + leadListConvertString);

// Finalize the Query String
String queryString = 'SELECT ' + leadFieldString + ' FROM Lead WHERE IsConverted = False AND Id IN ' + leadListConvertString;

// Query the List
List<Lead> leadList = Database.query(queryString);
System.debug('leadList = ' + leadList);