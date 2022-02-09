/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_ExpenseEntry extends sql_Dao {
    public dao_ExpenseEntry() {
        setSObject(Expense_Entry__c.sObjectType);

        addField(Expense_Entry__c.Id);
        addField(Expense_Entry__c.Amount__c);
        addField(Expense_Entry__c.Invoiced_Amount__c);
        addField(Expense_Entry__c.InternalApproval__c);
        addField(Expense_Entry__c.InternalApprovalBy__c);
        addField(Expense_Entry__c.Contract_Resource__c);
        addField(Expense_Entry__c.Date__c);
        addField(Expense_Entry__c.Submittal_Date__c);
        addField(Expense_Entry__c.Description__c);
        addField(Expense_Entry__c.Name);
        addField(Expense_Entry__c.Is_Approved__c);
        addField(Expense_Entry__c.Is_Billable__c);
        addField(Expense_Entry__c.Type__c);
    }

    public Expense_Entry__c findOne(String id) {
        List<Expense_Entry__c> expenseEntry = getWhere(sql_Criteria.Equals(Expense_Entry__c.Id, id));

        if(expenseEntry == null || expenseEntry.isEmpty()) {
            return null;
        }

        return expenseEntry[0];
    }

    //TODO: CHECK IF NEED THIS METHOD
    public List<Expense_Entry__c> findByDates(Map<String, Object> conditions) {
        List<Expense_Entry__c> expenseEntriesList = new List<Expense_Entry__c>();
        List<Date> dateList = (List<Date>)conditions.get('dateList');
        Date startDate = (Date)conditions.get('startDate');
        Date endDate = (Date)conditions.get('endDate');
        Set<String> contractResourcesIds = (Set<String>)conditions.get('listContractResourcesIds');
        Boolean approved = (Boolean)conditions.get('approved');
        Boolean billabled = (Boolean)conditions.get('biliabled');
  
        if(dateList != null) {
               // DAO do not have functionality for Set<Date> in sql_Criteria.ValueIn
                expenseEntriesList = [
                    SELECT 
                            Id,
                            Invoiced_Amount__c,
                            Amount__c,
                            InternalApproval__c,
                            InternalApprovalBy__c,
                            Contract_Resource__c,
                            Submittal_Date__c,
                            Date__c,
                            Description__c,
                            Name,
                            Is_Approved__c,
                            Is_Billable__c,
                            Type__c
                    FROM
                            Expense_Entry__c  
                    WHERE  
                            Submittal_Date__c IN :dateList                 
                    AND  
                            Contract_Resource__c IN :contractResourcesIds
                ];     
        } else {
                if(startDate != null && endDate != null) {
                        List<String> andCriteria = new List<String>();

                        String startDateCriteria = sql_Criteria.GreaterThanEquals(Expense_Entry__c.Submittal_Date__c, startDate);
                        andCriteria.add(startDateCriteria);

                        String endDateCriteria = sql_Criteria.LessThanEquals(Expense_Entry__c.Submittal_Date__c, endDate);
                        andCriteria.add(endDateCriteria);

                        if(contractResourcesIds != null && !contractResourcesIds.isEmpty()) {
                                String contractResourceCriteria = sql_Criteria.ValueIn(Expense_Entry__c.Contract_Resource__c, contractResourcesIds); 
                                andCriteria.add(contractResourceCriteria);
                        }

                        if(approved != null) {
                                String approveCriteria = sql_Criteria.Equals(Expense_Entry__c.Is_Approved__c, approved);
                                andCriteria.add(approveCriteria);
                        }              

                        if(billabled != null) {
                                String billableCriteria = sql_Criteria.Equals(Expense_Entry__c.Is_Billable__c, billabled);
                                andCriteria.add(billableCriteria);
                        }

                        addOrderBy(sql_Order.Ascending(Expense_Entry__c.Submittal_Date__c));
                        expenseEntriesList = (List<Expense_Entry__c>)getWhere(sql_Criteria.AndCriterias(andCriteria));
                }
                
        }

        return expenseEntriesList;
    }

    //TODO: ADD UNIT TEST    
    public List<Expense_Entry__c> findByTimesheets(Set<String> timesheetsIds) {
        if(timesheetsIds == null || timesheetsIds.isEmpty()) {
            return new List<Expense_Entry__c>();
        }

        List<String> criterias = new List<String>();

        criterias.add(sql_Criteria.Equals(Expense_Entry__c.Is_Billable__c, true));
        criterias.add(sql_Criteria.ValueIn(Expense_Entry__c.TimesheetId__c, timesheetsIds));

        String criteria = sql_Criteria.AndCriterias(criterias);

        return (List<Expense_Entry__c>)getWhere(criteria);                           
    }

    //TODO: iF EXIST conditions need add or get all expenses entry
    public List<Expense_Entry__c> findAll(Map<String, Object> conditions) {
        List<String> criterias = new List<String>();

        Set<String> contractResourcesIds = (Set<String>)conditions.get('listContractResourcesIds');
        if(contractResourcesIds != null && !contractResourcesIds.isEmpty()) {
                criterias.add(sql_Criteria.ValueIn('Contract_Resource__c', contractResourcesIds));
        }

        Schema.SObjectField fieldDate = Expense_Entry__c.Submittal_Date__c;

        String fieldNameForDate = (String)conditions.get('fieldDate');
        if(fieldNameForDate == 'date') {
                fieldDate = Expense_Entry__c.Date__c;
        }

        String startDateCriteria = '';
        String endDateCriteria = '';

        Date startDate = (Date)conditions.get('startDate');
        if(startDate != null) {
                startDateCriteria  = sql_Criteria.GreaterThanEquals(fieldDate, startDate);
                criterias.add(startDateCriteria);
        }

        Date endDate = (Date)conditions.get('endDate');
        if(endDate != null) {
                endDateCriteria = sql_Criteria.LessThanEquals(fieldDate, endDate);
                criterias.add(endDateCriteria);
        }

        Boolean billiable = (Boolean)conditions.get('billiable');
        if(billiable != null) {             
                criterias.add(sql_Criteria.Equals('Is_Billable__c', billiable));
        }

        String criteria = '';

        if(criterias.size() > 0) {
                criteria = sql_Criteria.AndCriterias(criterias);
        }

        return (List<Expense_Entry__c>)getWhere(criteria);//TODO: refactor framework!!!!! AndCriterias retur () when list are empty
    }
    
  /*  public Decimal getTotalAmount(Map<String, Object> conditions) {
        Set<String> contractResourcesIds = (Set<String>)conditions.get('listContractResourcesIds');

        Decimal amount = null;

        if(contractResourcesIds != null && !contractResourcesIds.isEmpty()) {
                Date startDate = (Date)conditions.get('startDate');
                Date endDate = (Date)conditions.get('endDate');
                Boolean isApproved = (Boolean)conditions.get('isApproved');
                Boolean isBillable = (Boolean)conditions.get('isBillable');

                AggregateResult resultTotalAmount = [
                        SELECT 
                                SUM(Invoiced_Amount__c) amount 
                        FROM   
                                Expense_Entry__c  
                        WHERE  
                                Submittal_Date__c >= :startDate 
                                AND  
                                Submittal_Date__c <= :endDate
                                AND
                                Is_Billable__c = :isBillable
                                AND
                                Is_Approved__c = :isApproved                
                                AND  
                                Contract_Resource__c IN :contractResourcesIds
                ];

                if(resultTotalAmount != null) {
                        amount =  (Decimal)resultTotalAmount.get('amount');
                }
        } 

        amount = (amount != null) ? amount : 0;

        return amount;
    }*/

    public List<AggregateResult> getTotalAmount(Map<String, Object> conditions) {
        Set<String> timesheetIds = (Set<String>)conditions.get('timesheetIds');
        List<AggregateResult> resultTotalAmount = new List<AggregateResult>();

        if(timesheetIds != null && !timesheetIds.isEmpty()) {
                Boolean isApproved = (Boolean)conditions.get('isApproved');
                Boolean isBillable = (Boolean)conditions.get('isBillable');

                resultTotalAmount = [
                        SELECT  
                                TimesheetId__c,
                                SUM(Invoiced_Amount__c) amount 
                        FROM   
                                Expense_Entry__c  
                        WHERE  
                                Is_Billable__c = :isBillable
                                AND
                                Is_Approved__c = :isApproved                
                                AND  
                                TimesheetId__c IN :timesheetIds
                        GROUP BY 
                                TimesheetId__c
                ];
        } 

        return resultTotalAmount;
    }

    public List<AggregateResult> getTotalAmountByDates(Map<String, Object> conditions) {
        Date startDate = (Date)conditions.get('startDate');
        Date endDate = (Date)conditions.get('endDate');
        Set<String> contractResourcesIds = (Set<String>)conditions.get('listContractResourcesIds');
        String status = (String)conditions.get('status');
        Boolean isApproved = false;
        
        if(status != null && status == 'approved') {
            isApproved = true;  
        }

        if(contractResourcesIds == null || contractResourcesIds.isEmpty()) {
                return new List<AggregateResult>();
        }

        List<AggregateResult> aggregateResults = [
                    SELECT 
                             Submittal_Date__c,
                             SUM(Amount__c) amount 
                    FROM   
                             Expense_Entry__c  
                    WHERE  
                             Submittal_Date__c >= :startDate 
                    AND  
                             Submittal_Date__c <= :endDate       
                    AND  
                             Contract_Resource__c IN :contractResourcesIds
                    AND 
                             Is_Approved__c = :isApproved           
                    GROUP BY  
                             Submittal_Date__c
                    ORDER BY          
                             Submittal_Date__c
        ]; 

        return aggregateResults;//TODO:replace to map with date => total
    }

    public Decimal getAmount(Map<String, Object> conditions) {
        Set<String> contractResourcesIds = (Set<String>)conditions.get('listContractResourcesIds');

        Decimal amount = null;

        if(contractResourcesIds != null && !contractResourcesIds.isEmpty()) {
                Date startDate = (Date)conditions.get('startDate');
                Date endDate = (Date)conditions.get('endDate');

                AggregateResult resultTotalAmount = [
                        SELECT 
                                SUM(Amount__c) amount 
                        FROM   
                                Expense_Entry__c  
                        WHERE  
                                Date__c >= :startDate 
                        AND  
                                Date__c <= :endDate            
                        AND  
                                Contract_Resource__c IN :contractResourcesIds
                ]; 

                if(resultTotalAmount != null) {
                        amount = (Decimal)resultTotalAmount.get('amount');
                }
        }

        amount = (amount != null) ? amount : 0;

        return amount;
    }
    
    public List<Expense_Entry__c> getExpenseEntryByTimesheet(Id timesheetId)
    {
        return (List<Expense_Entry__c>) getWhere(sql_Criteria.Equals(Expense_Entry__c.TimesheetId__c, timesheetId));  
    }
}