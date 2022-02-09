/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_TimesheetEntry extends sql_Dao {
    private Map<String, String> parameters = new Map<String, String>{
        'startDate' => 'Date__c',
        'endDate' => 'Date__c',
        'date' => 'Date__c',
        'contractResourceId' => 'Contract_Resource__c',
        'employeeId' => 'Employee__c',
        'timesheetId' => 'TimesheetId__c',
        'ids' => 'Id'
    };

    public dao_TimesheetEntry() {
        setSObject(Timesheet_Entry__c.sObjectType);

        addField(Timesheet_Entry__c.Id);
        addField(Timesheet_Entry__c.Product__c);
        addField(Timesheet_Entry__c.Date__c);
        addField(Timesheet_Entry__c.Minutes__c);
        addField(Timesheet_Entry__c.Contract_Resource__c);
        addField(Timesheet_Entry__c.Employee__c);
        addField(Timesheet_Entry__c.TimesheetId__c);
        addField(Timesheet_Entry__c.Is_Approved__c);
        addField(Timesheet_Entry__c.InternalApproval__c);
        addField(Timesheet_Entry__c.InternalApprovalBy__c);
        addField(Timesheet_Entry__c.lastModifiedDate);
    }

    public Timesheet_Entry__c findOne(String id) {
        List<Timesheet_Entry__c> timesheetEntries = (List<Timesheet_Entry__c>)getWhere(sql_Criteria.Equals(Timesheet_Entry__c.Id, id)); 

        if(timesheetEntries.isEmpty()) {
            return null;
        }

        return timesheetEntries[0];
    }    

    //TODO: IF EXIST condition need add or get all timesheet entry
    public List<Timesheet_Entry__c> findAll(Map<String, Object> conditions) {
        if(conditions == null) {
            conditions = new Map<String, Object>();
        }

        List<String> andCriteria = new List<String>();

        for(String key : conditions.keySet()) {
            Object value = conditions.get(key);

            String criteria = null;

            switch on key {
                when 'startDate' {
                    criteria = sql_Criteria.GreaterThanEquals(parameters.get(key), (Date)value);
                }
                when 'endDate' {
                   criteria = sql_Criteria.LessThanEquals(parameters.get(key), (Date)value);
                }
                when 'ids' {
                   criteria = sql_Criteria.ValueIn(parameters.get(key), (Set<Id>)value);
                }
                when else {
                    criteria = sql_Criteria.Equals(parameters.get(key), (String)value);
                }
            }

            andCriteria.add(criteria);
        }

        String criteria = '';

        if(andCriteria.size() > 0) {
            criteria = sql_Criteria.AndCriterias(andCriteria);
        }

        return (List<Timesheet_Entry__c>)getWhere(criteria);
    }

    public List<Timesheet_Entry__c> findByDates(Map<String, Object> conditions) {//TODO: Duplicate. Refactor with create one method findAll and condition
        List<Timesheet_Entry__c> timesheetEntries = new List<Timesheet_Entry__c>();

        if(conditions == null || conditions.isEmpty()) {
            return timesheetEntries;
        }
        
        List<Date> dates = (List<Date>)conditions.get('dateList');//TODO:rename to listDates
        
        if(dates == null || dates.isEmpty()) {
            return timesheetEntries;
        }

        String employeeId = (String)conditions.get('employeeId');
        String timesheetId = (String)conditions.get('timesheetId');

        //TODO: Duplicate SQL. Extract with dynamic add condition
        if(timesheetId != null) {
            timesheetEntries = [
                SELECT 
                    Id,
                    Is_Approved__c,
                    Contract_Resource__c,
                    TimesheetId__c
                FROM
                    Timesheet_entry__c 
                WHERE
                    Date__c IN :dates
                AND
                    Employee__c = :employeeId
                AND
                    TimesheetId__c = :timesheetId        
            ];
        } else {
            timesheetEntries = [
                SELECT 
                    Id,
                    Is_Approved__c,
                    Contract_Resource__c,
                    TimesheetId__c
                FROM 
                    Timesheet_entry__c 
                WHERE
                    Date__c IN :dates
                AND
                    Employee__c = :employeeId
            ];
        }

        return timesheetEntries;
    }

    //TODO:Diplicate code. Refactor and extract to one method findAll with cndition
    public List<Timesheet_Entry__c> findByDateRange(Map<String, Object> conditions) {
        if(conditions == null || conditions.isEmpty()) {
            return new List<Timesheet_Entry__c>();
        }
        
        Date startDate = (Date)conditions.get('startDate');
        Date endDate = (Date)conditions.get('endDate');
        String employeeId = (String)conditions.get('employeeId');
  
        List<Timesheet_Entry__c> timesheetEntries = [
            SELECT 
                Contract_Resource__c,
                TimesheetId__c,
                TimesheetId__r.Status__c
            FROM 
                Timesheet_Entry__c 
            WHERE
                Date__c >= :startDate 
            AND  
                Date__c <= :endDate 
            AND  
                Employee__c = :employeeId   
        ];
        
        return timesheetEntries;                                         
    }

    public Timesheet_Entry__c findOneByTimesheet(String timesheetId) {
        List<Timesheet_Entry__c> timesheetEntries = [
                SELECT 
                    Contract_Resource__c,
                    Contract_Resource__r.Rate__c,
                    Contract_Resource__r.Product__c,
                    Contract_Resource__r.Subcontractor_Account__c,
                    Contract_Resource__r.Contract__r.Client_Manager__c
                FROM 
                    Timesheet_entry__c 
                WHERE  
                    TimesheetId__c = :timesheetId
                LIMIT 1                  
            ];

        if(timesheetEntries.isEmpty()) {
            return null;  
        }

        return timesheetEntries[0];                               
    }

    //TODO:UNIT TESTS: ADD UNIT TEST
    public List<Timesheet_Entry__c> findByTimesheets(Set<Id> timesheetsIds) {
        if(timesheetsIds == null || timesheetsIds.isEmpty()) {
            return new List<Timesheet_Entry__c>();
        }

        return (List<Timesheet_Entry__c>)getWhere(sql_Criteria.ValueIn(Timesheet_Entry__c.TimesheetId__c, timesheetsIds));                                    
    }

    //TODO: refactor:extract to one method findAll
    public List<Timesheet_Entry__c> findByTimesheet(String timesheetId) {
        return (List<Timesheet_Entry__c>)getWhere(sql_Criteria.Equals(Timesheet_Entry__c.TimesheetId__c, timesheetId));                                    
    }

    //TODO: review List<AggregateResult> and name method
    public List<AggregateResult> findTimesheetsByContractResources(Set<String> contractResourcesIds, Date startDate, Date endDate) {
        if(contractResourcesIds == null || contractResourcesIds.isEmpty()) {
            return new List<AggregateResult>();
        }

        List<AggregateResult> aggregateResults = [
            SELECT  
                TimesheetId__c
            FROM
                Timesheet_entry__c
            WHERE
                Contract_Resource__c IN :contractResourcesIds
            AND
                TimesheetId__c != null
            AND
                Date__c  >= :startDate
            AND
                Date__c  <= :endDate            
            GROUP BY
                TimesheetId__c                  
        ];

        return aggregateResults;                          
    }

    public List<AggregateResult> findByContractResources(Set<String> contractResourcesIds, Set<Date> dates) {
        if(contractResourcesIds == null || contractResourcesIds.isEmpty() ||
            dates == null || dates.isEmpty()) {
            return new List<AggregateResult>();
        }

        List<AggregateResult> timesheetEntries = [
                SELECT  
                        SUM(Minutes__c) total,
                        Contract_Resource__c,
                        Employee__c
                FROM
                        Timesheet_entry__c
                WHERE
                        Contract_Resource__c IN :contractResourcesIds
                AND
                        Is_Approved__c = true//TODO:Extract to params
                AND
                        Date__c  IN :dates         
                GROUP BY
                        Contract_Resource__c,
                        Employee__c
        ];

        return timesheetEntries;
    }

    //TODO:Duplicate findByContractResources: Extract to one t=method
    public List<AggregateResult> findByTimesheets(Set<String> timesheetIds, Date startDate, Date endDate) {
        if(timesheetIds == null || timesheetIds.isEmpty()) {
            return new List<AggregateResult>();
        }

        List<AggregateResult> timesheets = [
                SELECT  
                        SUM(Minutes__c) total,
                        TimesheetId__c,
                        Contract_Resource__c
                FROM
                        Timesheet_entry__c
                WHERE
                        TimesheetId__c IN :timesheetIds
                AND
                        TimesheetId__c != null
                AND
                        Date__c  >= :startDate
                AND
                        Date__c  <= :endDate            
                GROUP BY
                        TimesheetId__c,
                        Contract_Resource__c
        ];

        return timesheets;                          
    }

    public Timesheet_Entry__c findEmployeeByTimesheet(String timesheetId) {//TODO: review with refactor. Duplicate
        List<Timesheet_Entry__c> timesheetEntries = [
            SELECT 
                Employee__c,
                Contract_Resource__c
            FROM 
                Timesheet_entry__c 
            WHERE  
                TimesheetId__c = :timesheetId
            LIMIT 1             
        ];

        if(timesheetEntries.isEmpty()) {
            return null;
        }

        return timesheetEntries.get(0);                             
    }

    public List<AggregateResult> findByReport(Map<String, Object> conditions) {
        List<AggregateResult> timesheetEntries = new List<AggregateResult>();

        if(conditions == null) {
            return timesheetEntries;
        }
        
        Date startDate = (Date)conditions.get('startDate');
        Date endDate = (Date)conditions.get('endDate');
        String employeeId = (String)conditions.get('employeeId');
        String status = (String)conditions.get('status');
        String timesheetId = (String)conditions.get('timesheetId');
        Set<String> countractresourceIds = (Set<String>)conditions.get('listContractResourcesIds');
 
        if(status != null || timesheetId != null) {
            if(status != null && timesheetId != null) {//TODO: review code
                timesheetEntries = [
                    SELECT 
                        Date__c,
                        Is_Approved__c,
                        SUM(Minutes__c) totalMinutes
                    FROM   
                        Timesheet_Entry__c 
                    WHERE  
                        Date__c >= :startDate 
                    AND  
                        Date__c <= :endDate 
                    AND  
                        Employee__c = :employeeId
                    AND
                        TimesheetId__c = :timesheetId     
                    AND
                        Is_Approved__c = :('approved'.equalsIgnoreCase(status))        
                    GROUP BY  
                        Date__c,
                        Is_Approved__c
                    ORDER BY          
                        Date__c
                ]; 
            } else if(status != null && timesheetId == null) {
                timesheetEntries = [
                    SELECT 
                        Date__c,
                        Is_Approved__c,
                        SUM(Minutes__c) totalMinutes
                    FROM   
                        Timesheet_Entry__c 
                    WHERE  
                        Date__c >= :startDate 
                    AND  
                        Date__c <= :endDate 
                    AND  
                        Employee__c = :employeeId
                    AND 
                        Contract_Resource__c IN : countractresourceIds
                    AND
                        Is_Approved__c = :('approved'.equalsIgnoreCase(status))        
                    GROUP BY  
                        Date__c,
                        Is_Approved__c
                    ORDER BY          
                        Date__c
                ];
            } else {
                timesheetEntries = [
                    SELECT 
                        Date__c,
                        Is_Approved__c,
                        SUM(Minutes__c) totalMinutes
                    FROM   
                        Timesheet_Entry__c 
                    WHERE  
                        Date__c >= :startDate 
                    AND  
                        Date__c <= :endDate 
                    AND  
                        Employee__c = :employeeId
                    AND
                        TimesheetId__c = :timesheetId       
                    GROUP BY  
                        Date__c,
                        Is_Approved__c
                    ORDER BY          
                        Date__c
                ];    
            }
        } else {
                timesheetEntries = [
                    SELECT 
                        Date__c,
                        Is_Approved__c,
                        SUM(Minutes__c) totalMinutes
                    FROM   
                        Timesheet_Entry__c 
                    WHERE  
                        Date__c >= :startDate 
                    AND  
                        Date__c <= :endDate 
                    AND  
                        Employee__c = :employeeId
                    GROUP BY  
                        Date__c,
                        Is_Approved__c
                    ORDER BY          
                        Date__c
                ]; 
        }
        
        return timesheetEntries;
    }

    //TODO: Review result: neew return total time only
    public Map<String, String> getTotalTime(String timesheetId) {
        Map<String, String> result = new Map<String, String>();

        List<AggregateResult> aggregateResults = [
            SELECT
                SUM(Minutes__c) total,
                Employee__c,
                Contract_Resource__c                     
            FROM
                Timesheet_Entry__c 
            WHERE
                TimesheetId__c = :timesheetId
            GROUP BY
                Employee__c,
                Contract_Resource__c
            LIMIT 1
        ];

        if(!aggregateResults.isEmpty()) {
            AggregateResult entry = aggregateResults.get(0);
            String employeeId = String.valueof(entry.get('Employee__c'));
            String contractResourceId = String.valueof(entry.get('Contract_Resource__c'));
            String totalMinutes = String.valueof(entry.get('total'));

            result.put('employeeId', employeeId);
            result.put('contractResourceId', contractResourceId);
            result.put('totalMinutes', totalMinutes);
        }

        return result; 
    }

    public List<AggregateResult> getTotalTimeForTimesheets() {
        List<AggregateResult> entries = [
            SELECT
                SUM(Minutes__c) total,
                TimesheetId__c,
                Employee__c,
                Contract_Resource__c               
            FROM
                Timesheet_Entry__c 
            WHERE
                TimesheetId__c != null
            GROUP BY
                Employee__c,
                Contract_Resource__c,
                TimesheetId__c    
        ];

        return entries;                      
    }

    //TODO: JOIN WITH getTotalTimeForTimesheets
    public List<AggregateResult> getTotalTimeForTimesheetsByIds(Set<String> timesheetIds) {
        if(timesheetIds == null || timesheetIds.isEmpty()) {
            return new List<AggregateResult>();
        }

        List<AggregateResult> entries = [
            SELECT
                SUM(Minutes__c) total,
                TimesheetId__c,
                Employee__c,
                Contract_Resource__c               
            FROM
                Timesheet_Entry__c 
            WHERE
                TimesheetId__c IN :timesheetIds
            GROUP BY
                Employee__c,
                Contract_Resource__c,
                TimesheetId__c    
        ];

        return entries;               
    }

    //TODO: MOVE TO SERVICE TIMESHEET ENTRY AND DAO WITH JOIN AND refactor
    public List<Timesheet_Entry__c> getTimesheetsEntriesBySalesperson(Set<String> timesheetsIds, String receiverId, Date startDate, Date endDate) {
        if(timesheetsIds == null || timesheetsIds.isEmpty()) {
            return new List<Timesheet_Entry__c>();
        }
        
        return [
            SELECT 
                Id,
                Is_Approved__c,
                Minutes__c,
                Product__c,
                TimesheetId__c,
                Employee__c,
                Date__c,
                Contract_Resource__c,        
                Contract_Resource__r.Contract__r.Id,        
                Contract_Resource__r.Contract__r.AccountId,
                Contract_Resource__r.Contract__r.Referral_Rate__c,
                Contract_Resource__r.Contract__r.Commission_Rate__c,
                Contract_Resource__r.Employee__c,
                Contract_Resource__r.Subcontractor_Account__c,
                InternalApproval__c,
                InternalApprovalBy__c,
                Employee__r.Subcontractor_Rate__c
            FROM 
                Timesheet_Entry__c
            WHERE 
                TimesheetId__c IN :timesheetsIds
                AND
                Contract_Resource__r.Contract__r.Salesperson__c = :receiverId
                AND
                Date__c >= :startDate
                AND
                Date__c <= :endDate
        ];
    }

    //TODO: MOVE TO SERVICE TIMESHEET ENTRY AND DAO WITH JOIN
    public List<Timesheet_Entry__c> getTimesheetsEntriesByRefferal(Set<String> timesheetsIds, String receiverId, Date startDate, Date endDate) {
        return [
            SELECT 
                Id,
                Is_Approved__c,
                Minutes__c,
                Product__c,
                TimesheetId__c,
                Employee__c,
                Date__c,
                Contract_Resource__c,        
                Contract_Resource__r.Contract__r.Id,        
                Contract_Resource__r.Contract__r.AccountId,
                Contract_Resource__r.Contract__r.Referral_Rate__c,
                Contract_Resource__r.Contract__r.Commission_Rate__c,
                Contract_Resource__r.Employee__c,
                Contract_Resource__r.Subcontractor_Account__c,
                InternalApproval__c,
                InternalApprovalBy__c,
                Employee__r.Subcontractor_Rate__c
            FROM 
                Timesheet_Entry__c
            WHERE 
                TimesheetId__c IN :timesheetsIds
                AND
                Contract_Resource__r.Contract__r.Referred_By__c = :receiverId
                AND
                Date__c >= :startDate
                AND
                Date__c <= :endDate
        ];
    }

    //TODO: MOVE TO SERVICE TIMESHEET ENTRY AND DAO WITH JOIN
    public List<Timesheet_Entry__c> getTimesheetsEntriesBySubcontractor(Set<String> timesheetsIds, String receiverId, Date startDate, Date endDate) {
        return [
            SELECT 
                Id,
                Is_Approved__c,
                Minutes__c,
                Product__c,
                TimesheetId__c,
                Employee__c,
                Date__c,
                Contract_Resource__c,        
                Contract_Resource__r.Contract__r.Id,        
                Contract_Resource__r.Contract__r.AccountId,
                Contract_Resource__r.Employee__c,
                Contract_Resource__r.Subcontractor_Account__c,
                InternalApproval__c,
                InternalApprovalBy__c,
                Employee__r.Subcontractor_Rate__c
            FROM 
                Timesheet_Entry__c
            WHERE 
                TimesheetId__c IN :timesheetsIds
                AND
                Contract_Resource__r.Subcontractor_Account__c = :receiverId
                AND
                Date__c >= :startDate
                AND
                Date__c <= :endDate
        ];
    }
    public List<Timesheet_Entry__c> getTimesheetEntryByTimesheet(Id timesheetId)
    {
        return (List<Timesheet_Entry__c>) getWhere(sql_Criteria.Equals(Timesheet_Entry__c.TimesheetId__c, timesheetId));  
    }
}