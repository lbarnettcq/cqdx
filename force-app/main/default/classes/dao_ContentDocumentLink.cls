/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 */
public with sharing class dao_ContentDocumentLink extends sql_Dao {
    public dao_ContentDocumentLink() {
        setSObject(ContentDocumentLink.sObjectType);

        addField(ContentDocumentLink.Id);
        addField(ContentDocumentLink.LinkedEntityId);
        addField(ContentDocumentLink.ContentDocumentId);
    }

    public List<ContentDocumentLink> findOneByRecordId(String recordId) {
        if(recordId == null) {
            return new List<ContentDocumentLink>();
        }
        
        return (List<ContentDocumentLink>)getWhere(sql_Criteria.Equals(ContentDocumentLink.LinkedEntityId, recordId));
    }

    public List<ContentDocumentLink> findAllByParams(Set<String> recordsIds) {
        if(recordsIds == null || recordsIds.isEmpty()) {
            return new List<ContentDocumentLink>(); 
        }

        List<String> criterias = new List<String>();

        criterias.add(sql_Criteria.ValueIn(ContentDocumentLink.LinkedEntityId, recordsIds));
        
        return (List<ContentDocumentLink>)getWhere(sql_Criteria.AndCriterias(criterias));
    }
}