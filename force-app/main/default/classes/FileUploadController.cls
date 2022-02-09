/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class FileUploadController {
    @AuraEnabled
    public static Map<String, Object> getList(String recordId) { 
      Map<String, Object> params = new Map<String, Object> {
            'recordId' => recordId
      };

      Map<String, Object> request = new Map<String, Object> {
            'fields' => new List<Map<String, Object>> {
                new Map<String, Object> {
                      'name' => 'recordId',
                      'type' => 'string',
                      'required' => true,
                      'errors' => new Map<String, Object> {}
                }
            },
            'service' => Services.FileUpload,
            'action' => 'getList',
            'response' => new List<Map<String, Object>> {
                  new Map<String, Object>{                              
                        'name' => 'list',                              
                        'type' => 'list',
                        'required' => true,
                        'apiName' => 'list',
                        'errors' => new Map<String, Object> {}
                  }
            },
            'params' => params
      };

      Map<String, Object> response = new Map<String, Object>();

      service_Validation.proccessRequest(request, response);

      return response;            
    }

    @AuraEnabled
    public static Map<String, Object> saveFiles(List<Map<String, String>> listFiles) { 
      Map<String, Object> params = new Map<String, Object>{
            'listFiles' => listFiles
      };

      Map<String, Object> request = new Map<String, Object> {
            'fields' => new List<Map<String, Object>> {
                new Map<String, Object>{
                      'name' => 'listFiles',
                      'type' => 'list',
                      'required' => true,
                      'errors' => new Map<String, Object> {}
                }
            },
            'service' => Services.FileUpload,
            'action' => 'saveFiles',
            'response' => new List<Map<String, Object>> {
                  new Map<String, Object>{                              
                        'name' => 'list',                              
                        'type' => 'list',
                        'required' => true,
                        'apiName' => 'list',
                        'errors' => new Map<String, Object> {}
                  }
            },
            'params' => params
      };     

      Map<String, Object> response = new Map<String, Object>();

      service_Validation.proccessRequest(request, response);

      return response;   
    }



    @AuraEnabled
    public static Map<String, Object> deleteEntry(String documentId) { 
      Map<String, Object> params = new Map<String, Object> {
            'documentId' => documentId
      };

      Map<String, Object> request = new Map<String, Object> {
            'fields' => new List<Map<String, Object>> {
                new Map<String, Object> {
                      'name' => 'documentId',
                      'type' => 'string',
                      'required' => true,
                      'errors' => new Map<String, Object> {}
                }
            },
            'service' => Services.FileUpload,
            'action' => 'deleteEntry',
            'response' => new List<Map<String, Object>> {
                  new Map<String, Object>{                              
                        'name' => 'status',                              
                        'type' => 'status',
                        'required' => true,
                        'apiName' => 'status',
                        'errors' => new Map<String, Object> {}
                  }
            },
            'params' => params
      };

      Map<String, Object> response = new Map<String, Object>();

      service_Validation.proccessRequest(request, response);

      return response;          
    }

    /*@AuraEnabled  
    public static List<ContentDocument> UpdateFiles(string documentId,string title,string recordId){  
          system.debug('title: ' +title);  
          ContentDocument cd = [select id,title from ContentDocument where Id=:documentId]; // Getting files from Parent record 
          cd.Title = title;  // Changing file Title with user entered title
          try{  
                update cd;  // Update ContentDocument (File)
          }  
          catch(DMLException e){  
                system.debug('Exception has occurred! ' +e.getMessage());  
          }  
          List<ContentDocument> DocumentList = new List<ContentDocument>();  
          Set<Id> documentIds = new Set<Id>();  
          List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
          for(ContentDocumentLink cdLink:cdl){  
                documentIds.add(cdLink.ContentDocumentId);  
          }      
          DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds];  
          return DocumentList;  // Return list of files on parent record
    }  */
}