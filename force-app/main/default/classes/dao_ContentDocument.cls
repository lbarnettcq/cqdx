/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 */
public with sharing class dao_ContentDocument extends sql_Dao {
    public dao_ContentDocument() {
        setSObject(ContentDocument.sObjectType);

        addField(ContentDocument.Id);
        addField(ContentDocument.Title);
        addField(ContentDocument.FileType);
        addField(ContentDocument.ContentSize);
        addField(ContentDocument.Description);
    }

    public List<ContentDocument> findAllByDocumentsIds(Set<String> documentsIds) {
        if(documentsIds == null || documentsIds.isEmpty()) {
            return new List<ContentDocument>();
        }
        
        return (List<ContentDocument>)getWhere(sql_Criteria.ValueIn(ContentDocument.Id, documentsIds));
    }
}