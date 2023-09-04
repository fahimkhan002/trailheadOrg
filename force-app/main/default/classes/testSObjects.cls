public class testSObjects {
    public static Set<String> getSObjectFields(String SObjectName){
        Set<String> fieldNames = new Set<String>();

        Map<String,Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();

        Schema.SObjectType sObjectTypeInstance = sObjectMap.get(sObjectName);

        if(sObjectTypeInstance != null){
            Map<String, Schema.SObjectField> fieldMap =  sObjectTypeInstance.getDescribe().fields.getMap();


            for(Schema.SObjectField field : fieldMap.values()){
                Schema.DescribeFieldResult fieldResult = field.getDescribe();
                if(fieldResult.isAccessible()){
                    fieldNames.add(fieldResult.getName());
                }
            }
        }
            return fieldNames;

    }
}