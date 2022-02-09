/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_PricebookEntry extends sql_Dao {
        public dao_PricebookEntry() {
                setSObject(PricebookEntry.sObjectType);

                addField(PricebookEntry.Id);
                addField(PricebookEntry.IsActive);        
                addField(PricebookEntry.Pricebook2Id);      
                addField(PricebookEntry.Product2Id);
                addField(PricebookEntry.ProductCode);
                addField(PricebookEntry.UseStandardPrice);
                addField(PricebookEntry.UnitPrice);
        }

        public PricebookEntry findOne(String id) {
                List<PricebookEntry> pricebookEntries = getWhere(sql_Criteria.Equals(PricebookEntry.Id, id));
                
                if(pricebookEntries.isEmpty()) {
                        return null;
                }

                return pricebookEntries[0];
        }

        public List<PricebookEntry> findAll() {
                return (List<PricebookEntry>)getAll();
        }

        public List<PricebookEntry> findByIds(Set<String> ids) {
                if(ids == null || ids.isEmpty()) {
                        return new List<PricebookEntry>();
                }

                return (List<PricebookEntry>)getWhere(sql_Criteria.ValueIn(PricebookEntry.Id, ids));
        }

        //TODO:UNIT TEST:ADD UNIT TEST
        public List<PricebookEntry> getPricebookEntriesByPricebook(Set<Id> pricebookIds)
        {
                if(pricebookIds == null) {
                        return new List<PricebookEntry>();
                }

                List<String> criterias = new List<String> {                        
                        sql_Criteria.Equals(PricebookEntry.IsActive, true)
                };

                if(!pricebookIds.isEmpty()) {
                        criterias.add(sql_Criteria.ValueIn(PricebookEntry.Pricebook2Id, pricebookIds));
                }

                return (List<PricebookEntry>)getWhere(sql_Criteria.AndCriterias(criterias));
        }
}