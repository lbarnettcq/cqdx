/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_Timesheet extends sql_Dao {
      public dao_Timesheet() {
            setSObject(Timesheet__c.sObjectType);

            addField(Timesheet__c.Id);
            addField(Timesheet__c.Name);
            addField(Timesheet__c.StartDate__c);
            addField(Timesheet__c.EndDate__c);
            addField(Timesheet__c.Status__c);
            addField(Timesheet__c.Approved__c);
            addField(Timesheet__c.ApprovedBy__c);
            addField(Timesheet__c.LastModifiedDate__c);
            addField(Timesheet__c.CreatedDate__c);
            addField(Timesheet__c.Contract_Resource__c);
      }

      public Timesheet__c findOne(String timesheetId) {
            List<Timesheet__c> timesheets = [
                  SELECT 
                        Id,
                        Name,
                        StartDate__c,
                        EndDate__c,
                        Status__c,
                        Approved__c,
                        ApprovedBy__c,
                        LastModifiedDate__c,
                        CreatedDate__c,
                        Contract_Resource__c,
                        Contract_Resource__r.Contract__c,
                        Contract_Resource__r.Employee__c,
                        Contract_Resource__r.Rate__c,
                        Contract_Resource__r.Contract__r.Client_Manager__c,
                        Contract_Resource__r.Contract__r.ContractNumber
                  FROM 
                        Timesheet__c
                  WHERE 
                        Id =: timesheetId      
            ];

            return timesheets[0];
      }

      public List<Timesheet__c> findAll() {
            List<Timesheet__c> timesheets = [
                  SELECT 
                        Id,
                        Name,
                        StartDate__c,
                        EndDate__c,
                        Status__c,
                        Approved__c,
                        ApprovedBy__c,
                        LastModifiedDate__c,
                        CreatedDate__c,
                        Contract_Resource__c,
                        Contract_Resource__r.Contract__c,
                        Contract_Resource__r.Employee__c
                  FROM 
                        Timesheet__c
            ];

            return timesheets;
      }

      public List<Timesheet__c> findAllByIds(Set<String> ids) {
            if(ids == null || ids.isEmpty()) {
                  return new List<Timesheet__c>();
            }

            return (List<Timesheet__c>)getWhere(sql_Criteria.ValueIn(Timesheet__c.Id, ids));
      }

      //TODO: Rename: not for invoice.
   /*   public List<Timesheet__c> findAllForInvoice(Set<String> timesheetsIds, Date startDate, Date endDate) {//TODO:review and refactor. Duplicate. findAll
            return [
                  SELECT
                        Id,
                        StartDate__c,
                        EndDate__c,
                        Status__c
                  FROM 
                        Timesheet__c
                  WHERE 
                        Id IN :timesheetsIds
                  AND
                        StartDate__c >= :startDate
                  AND
                        EndDate__c <= :endDate
                  AND 
                        Status__c = 'Approved'  
            ];
      }*/

      public List<Timesheet__c> findAllByContractResources(Set<String> contractResources) {//TODO:review and refactor. Duplicate. findAll
            return [
                  SELECT
                        Id,
                        StartDate__c,
                        EndDate__c,
                        Status__c,
                        Contract_Resource__c
                  FROM 
                        Timesheet__c
                  WHERE 
                        Contract_Resource__c IN :contractResources
            ];
      }


      public List<Timesheet__c> findAllForInvoice(Set<String> contractResources, Date startDate, Date endDate) {//TODO:review and refactor. Duplicate. findAll
            return [
                  SELECT
                        Id,
                        StartDate__c,
                        EndDate__c,
                        Status__c,
                        Contract_Resource__c,
                        Contract_Resource__r.Rate__c
                  FROM 
                        Timesheet__c
                  WHERE 
                        Contract_Resource__c IN :contractResources
                  AND
                        StartDate__c >= :startDate
                  AND
                        EndDate__c <= :endDate
                  AND 
                        Status__c = 'Approved'  
            ];
      }
}