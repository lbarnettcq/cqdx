/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_FileUpload extends service_Base {
      public override void process(service_Request request, service_Response response) {
            switch on (String)request.Parameters.get('action') {
                  when 'getList' {
                        getList(request, response);
                  }
                  when 'saveFiles' {
                        saveFiles(request, response);
                  }
                  when 'deleteEntry' {
                        deleteEntry(request, response);
                  }
            }
      }

      public void getList(service_Request request, service_Response response) {
            String recordId = (String)request.Parameters.get('recordId');

            List<Map<String, String>> listFiles = new List<Map<String, String>>();

            if(recordId != null) {
                  dao_ContentDocumentLink daoContentDocumentLink = new dao_ContentDocumentLink();
                  List<ContentDocumentLink> listCdl = daoContentDocumentLink.findOneByRecordId(recordId);
            
                  if(!listCdl.isEmpty()) {
                        Set<String> documentIds = new Set<String>();
                        for(ContentDocumentLink cdLink : listCdl) {  
                              documentIds.add(cdLink.ContentDocumentId);
                        }  

                        dao_ContentDocument daoContentDocument = new dao_ContentDocument();
                        List<ContentDocument> listDocuments = daoContentDocument.findAllByDocumentsIds(documentIds);

                        if(!listDocuments.isEmpty()) {
                              for(ContentDocument cd : listDocuments) {
                                    Map<String, String> item = new Map<String, String> {
                                          'id' => cd.Id,
                                          'name' => cd.Title,
                                          'type' => cd.FileType
                                    };

                                    listFiles.add(item);
                              } 
                        }
                  }
            }

            response.Parameters.put('list', listFiles);
      }

      public void saveFiles(service_Request request, service_Response response) {   
            List<Map<String, String>> resultFiles = new List<Map<String, String>>();

            //Id parentId, String fileName, String base64Data, String contentType, String fileId
            List<Map<String, String>> listFiles  = (List<Map<String, String>>) request.Parameters.get('listFiles');

            if(listFiles != null && !listFiles.isEmpty()) {
                  List<Map<String, String>> filesInsert = new List<Map<String, String>>();
                  List<Map<String, String>> filesAppend = new List<Map<String, String>>();

                  for(Map<String, String> file : listFiles) {
                        Map<String, String> item = new Map<String, String> {
                              '_id' => file.get('_id'),
                              'content' => file.get('content')
                        };

                        if(String.isBlank(file.get('id'))) {
                              item.put('name', file.get('name'));
                              item.put('recordId', file.get('recordId'));
                              filesInsert.add(item);
                              //fileId = uploadFile(base64Data, fileName, parentId);
                        } else {
                              item.put('name', file.get('id'));
                              filesAppend.add(item);
                              //appendToFile(fileId, base64Data);
                        }
                  }

                  if(!filesInsert.isEmpty()) {
                        resultFiles.addAll(uploadFiles(filesInsert));
                  }

                  if(!filesAppend.isEmpty()) {
                        resultFiles.addAll(appendToFiles(filesAppend));
                  }
            }    

            response.Parameters.put('list', resultFiles);
      }

      public void deleteEntry(service_Request request, service_Response response) {//TODO: delete one or set?   
            String documentId = (String)request.Parameters.get('documentId');

            if(existDocument(documentId)) {
                  String status  = AppConfig.STATUS.get('error');   

                  Set<String> documentIds = new Set<String>{documentId};

                  dao_ContentDocument daoContentDocument = new dao_ContentDocument();
                  List<ContentDocument> documents = daoContentDocument.findAllByDocumentsIds(documentIds);

                  if(!documents.isEmpty()) {
                        delete documents;
                        status = AppConfig.STATUS.get('success'); 
                  }

                  response.Parameters.put('status', status);
            } else {
                  generateNoDataFoundError('Document ' + documentId + ' not found');
            }     
      }

      /*
      * @method uploadFile() 
      * @desc Creates a content version from a given file's base64 and name
      * 
      * @param {List<Map<String, String>>} listFiles - list of files
      * 
      * @return {ContentVersion} - returns the created ContentDocumentLink Id if the
      *   upload was successful, otherwise returns null
      */
      private static List<Map<String, String>> uploadFiles(List<Map<String, String>> listFiles) {
          List<Map<String, String>> filesUploaded = new List<Map<String, String>>();

          for(Map<String, String> file : listFiles) {
                //String base64, String filename, String recordId
                ContentVersion cv = createContentVersion(file.get('content'), file.get('name'));
                ContentDocumentLink cdl = createContentLink(cv.Id, file.get('recordId'));
                
                if (cv == null || cdl == null) {
                      continue;
                } else {
                      filesUploaded.add(new Map<String, String> {
                            'id' => cdl.Id,
                            '_id' => file.get('_id')
                      });
                }
          }
          
          return filesUploaded;
      }

      private static List<Map<String, String>> appendToFiles(List<Map<String, String>> listFiles) {
            List<Map<String, String>> filesAppended = new List<Map<String, String>>();
            List<ContentVersion> listContentVersion = new List<ContentVersion>();
            
            for(Map<String, String> file : listFiles) {
                  String ContentDocumentLinkId = (String)file.get('name');
                  String ContentDocumentId = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE Id = :ContentDocumentLinkId].ContentDocumentId;
                  if(ContentDocumentId == null) {
                        generateNoDataFoundError('ContentDocumentId not found');
                  }

                  ContentVersion cv = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :ContentDocumentId];
                  String content = EncodingUtil.base64Encode(cv.VersionData);
                  cv.VersionData = EncodingUtil.base64Decode(content + (String)file.get('content'));

                  listContentVersion.add(cv);

                  filesAppended.add(new Map<String, String> {
                        'id' => ContentDocumentLinkId,
                        '_id' => file.get('_id')
                  });
            }

            update listContentVersion;
            
            return filesAppended;
      }

      /*
      * @method createContentVersion() [private]
      * @desc Creates a content version from a given file's base64 and name
      * 
      * @param {String} base64 - base64 string that represents the file
      * @param {String} filename - full file name with extension, i.e. 'Invoice.pdf'
      * 
      * @return {ContentVersion} - returns the newly created ContentVersion, or null
      *   if there was an error inserting the record
      */
      private static ContentVersion createContentVersion(String base64Content, String filename) {
          ContentVersion cv = new ContentVersion();
          cv.VersionData = EncodingUtil.base64Decode(base64Content);
          cv.Title = filename;
          cv.PathOnClient = filename;
          cv.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
          //cv.Origin = 'H';//C-Content Origin. H-Chatter Origin.
          
          try {
                insert cv;
                return cv;
          } catch(DMLException e) {
                System.debug(e);
                return null;
          }
      }

      /*
      * @method createContentLink() [private]
      * @desc Creates a content link for a given ContentVersion and record
      * 
      * @param {String} contentVersionId - Id of the ContentVersion of the file
      * @param {String} recordId - Id of the record you want to attach this file to
      * 
      * @return {ContentDocumentLink} - returns the newly created ContentDocumentLink, 
      *   or null if there was an error inserting the record
      */
      private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
            if (contentVersionId == null || recordId == null) { return null; }

            ContentDocumentLink cdl = new ContentDocumentLink();

            cdl.ContentDocumentId = [
                  SELECT ContentDocumentId
                  FROM ContentVersion 
                  WHERE Id =: contentVersionId
            ].ContentDocumentId;

            cdl.LinkedEntityId = recordId;
            // ShareType is either 'V', 'C', or 'I'
            // V = Viewer, C = Collaborator, I = Inferred
            cdl.ShareType = 'V';
            //cdl.Visibility = 'InternalUsers';

            try {
                  insert cdl;
                  return cdl;
            } catch(DMLException e) {
                  System.debug(e);
                  return null;
            }
      }

      private static Boolean existDocument(String documentId) {
            List<ContentVersion> contents = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :documentId AND IsLatest = true];

            return (!contents.isEmpty());
      }

      private static void generateNoDataFoundError(String message) {
        NoDataFoundException ex = new NoDataFoundException();
        ex.setMessage(message);
        throw ex; 
    }
}