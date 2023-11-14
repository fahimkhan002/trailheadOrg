public with sharing class LeadController {
    
    // Method to fetch Lead Source picklist values (previously provided)
    @AuraEnabled(cacheable=true)
    public static List<String> getLeadSourcePicklistValues() {
        List<String> picklistValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Lead.LeadSource.getDescribe();
        for (Schema.PicklistEntry picklistEntry : fieldResult.getPicklistValues()) {
            picklistValues.add(picklistEntry.getValue());
        }
        return picklistValues;
    }

    // Method to create a Lead record with provided data (previously provided)
    @AuraEnabled
    public static String createLead(Map<String, Object> leadData) {
        try {
            Lead newLead = new Lead(
                FirstName = (String)leadData.get('FirstName'),
                LastName = (String)leadData.get('LastName'),
                Email = (String)leadData.get('Email'),
                Phone = (String)leadData.get('MobilePhone'),
                LeadSource = (String)leadData.get('HowDidYouHear'), // Set Lead Source
                Description = (String)leadData.get('Comments')
                // Map other fields from leadData here
            );
            
            // Handle file attachment, if any
            if (leadData.get('RecordId') != null) {
                Attachment attachment = new Attachment(
                    ParentId = newLead.Id,
                    Name = (String)leadData.get('FileName'), // Set the file name
                    Body = EncodingUtil.base64Decode((String)leadData.get('FileData')) // Set the file data
                );
                insert attachment;
            }
            
            insert newLead;
            return 'success';
        } catch (Exception e) {
            return e.getMessage();
        }
    }
    
    // Method to handle file upload and association with Lead
    @AuraEnabled
    public static String uploadFile(String parentId, String fileName, String fileData) {
        try {
            Attachment attachment = new Attachment(
                ParentId = parentId,
                Name = fileName,
                Body = EncodingUtil.base64Decode(fileData)
            );
            insert attachment;
            return 'success';
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}
