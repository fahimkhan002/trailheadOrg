public with sharing class RecordCreatorController {

    @AuraEnabled(cacheable=true)
    public static List<ObjectInfo> getStandardObjects() {
        List<ObjectInfo> objectOptions = new List<ObjectInfo>();
        for (Schema.SObjectType objType : Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            if (objDescribe.isCreateable()) {
                objectOptions.add(new ObjectInfo(objDescribe.getName(), objDescribe.getLabel()));
            }
        }
        //objectOptions.sort();
        return objectOptions;
    }

    @AuraEnabled(cacheable=false)
    public static String createRecords(String objectApiName, Integer numRecords) {
        List<sObject> recordsToCreate = new List<sObject>();

        // Dynamically create records based on the selected object and number of records
        for (Integer i = 0; i < numRecords; i++) {
            sObject record = (sObject)Type.forName(objectApiName).newInstance();
            recordsToCreate.add(record);
        }

        try {
            insert recordsToCreate;
            return 'Records created successfully.';
        } catch (Exception e) {
            return 'Error creating records: ' + e.getMessage();
        }
    }

    public class ObjectInfo {
        @AuraEnabled
        public String value { get; set; }
        @AuraEnabled
        public String label { get; set; }

        public ObjectInfo(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
}
