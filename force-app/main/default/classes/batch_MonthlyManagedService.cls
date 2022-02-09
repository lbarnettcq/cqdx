/**
 * Created by dcano on 10/7/19.
 */

global with sharing class batch_MonthlyManagedService implements Database.Batchable<sObject>
{
    global static final Integer BATCH_SIZE = 500;
    private String query;

    global Date currentDate { get; set; }

    private Date currentBeginDate;
    private Date currentEndDate;
    private Date previousDate;
    private Date previousBeginDate;
    private Date previousEndDate;

    global batch_MonthlyManagedService()
    {
        sql_Query sqlQuery = new sql_Query();
        sqlQuery.setSObject(Contract.sObjectType);
        sqlQuery.addField(Contract.Id);
        sqlQuery.addField(Contract.Name);
        sqlQuery.addField(Contract.AccountId);
        sqlQuery.addField(Contract.EndDate);
        sqlQuery.addField(Contract.StartDate);
        sqlQuery.addField(Contract.Is_Managed_Services__c);
        sqlQuery.addField(Contract.Monthly_Case_Allotment__c);
        sqlQuery.addField(Contract.Monthly_Case_Overage__c);
        sqlQuery.addField(Contract.Monthly_Cost__c);
        sqlQuery.addField(Contract.Monthly_Developer_Hour_Overage__c);
        sqlQuery.addField(Contract.Monthly_Developer_Hours__c);

        String criteria = sql_Criteria.AndCriterias(new List<String> {
            sql_Criteria.LessThanEquals(Contract.StartDate, Date.today()),
            sql_Criteria.GreaterThanEquals(Contract.EndDate, Date.today()),
            sql_Criteria.Equals(Contract.Is_Managed_Services__c, true)
        });

        sqlQuery.setCriteria(criteria);

        query = sqlQuery.buildQuery();
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        if (currentDate == null)
        {
            currentDate = Date.today();
        }

        previousDate = currentDate.addMonths(-1);

        Integer currentDaysInMonth = Date.daysInMonth(currentDate.year(), currentDate.month());
        Integer previousDaysInMonth = Date.daysInMonth(previousDate.year(), previousDate.month());

        currentBeginDate = currentDate.toStartOfMonth();
        currentEndDate = Date.newInstance(currentDate.year(), currentDate.month(), currentDaysInMonth);

        System.debug('#### Current Begin Date [' + currentBeginDate + '] End Date [' + currentEndDate + ']');

        previousBeginDate = previousDate.toStartOfMonth();
        previousEndDate = Date.newInstance(previousDate.year(), previousDate.month(), previousDaysInMonth);

        System.debug('#### Previous Begin Date [' + previousBeginDate + '] End Date [' + previousEndDate + ']');

        List<Contract> contracts = (List<Contract>) scope;

        Set<Id> acctIds = sql_Utility.getIds(Contract.AccountId, contracts);

        dao_MonthlyManagedService dao = new dao_MonthlyManagedService();
        List<Monthly_Managed_Service__c> mmsRecords = null;

        mmsRecords = dao.getMonthlyManagedServicesByAccountsAndDates(acctIds, currentBeginDate, currentEndDate);
        Map<String, Monthly_Managed_Service__c> currentMap = getMap(mmsRecords);

        System.debug('#### Current Map: ' + currentMap);

        mmsRecords = dao.getMonthlyManagedServicesByAccountsAndDates(acctIds, previousBeginDate, previousEndDate);
        Map<String, Monthly_Managed_Service__c> previousMap = getMap(mmsRecords);

        System.debug('#### Current Map: ' + previousMap);

        List<Monthly_Managed_Service__c> insertMMS = new List<Monthly_Managed_Service__c>();

        for (Contract cont : contracts)
        {
            Monthly_Managed_Service__c currentMMS = currentMap.get(cont.AccountId);
            Monthly_Managed_Service__c previousMMS = previousMap.get(cont.AccountId);

            if (currentMMS == null)
            {
                if (previousMMS != null)
                {
                    currentMMS = new Monthly_Managed_Service__c();
                    currentMMS.Account__c = cont.AccountId;
                    currentMMS.Begin_Date__c = currentBeginDate;
                    currentMMS.End_Date__c = currentEndDate;
                    currentMMS.Case_Allotment__c = previousMMS.Cases_to_Carryover__c;
                    currentMMS.Case_Overage_Cost__c = previousMMS.Case_Overage_Cost__c;
                    currentMMS.Developer_Hours__c = previousMMS.Developer_Hours__c;
                    currentMMS.Developer_Overage_Cost__c = previousMMS.Developer_Overage_Cost__c;
                    currentMMS.Monthly_Base_Cost__c = previousMMS.Monthly_Base_Cost__c;
                }
                else
                {
                    currentMMS = new Monthly_Managed_Service__c();
                    currentMMS.Account__c = cont.AccountId;
                    currentMMS.Begin_Date__c = currentBeginDate;
                    currentMMS.End_Date__c = currentEndDate;
                    currentMMS.Case_Allotment__c = cont.Monthly_Case_Allotment__c;
                    currentMMS.Case_Overage_Cost__c = cont.Monthly_Case_Overage__c;
                    currentMMS.Developer_Hours__c = cont.Monthly_Developer_Hours__c;
                    currentMMS.Developer_Overage_Cost__c = cont.Monthly_Developer_Hour_Overage__c;
                    currentMMS.Monthly_Base_Cost__c = cont.Monthly_Cost__c;
                }


                insertMMS.add(currentMMS);
            }
        }

        if (!insertMMS.isEmpty())
        {
            insert insertMMS;
        }
    }

    global void finish(Database.BatchableContext BC)
    {

    }

    global static void run()
    {
        run(batch_MonthlyManagedService.BATCH_SIZE);
    }

    global static void run(Integer batchSize)
    {
        batch_MonthlyManagedService batch = new batch_MonthlyManagedService();
        Database.executeBatch(batch, batchSize);
    }

    private Map<String, Monthly_Managed_Service__c> getMap(List<Monthly_Managed_Service__c> mmsRecords)
    {
        Map<String, Monthly_Managed_Service__c> theMap = new Map<String, Monthly_Managed_Service__c>();

        if (mmsRecords != null && !mmsRecords.isEmpty())
        {
            for (Monthly_Managed_Service__c mmsRecord : mmsRecords)
            {
                theMap.put(mmsRecord.Account__c, mmsRecord);
            }
        }

        return theMap;
    }
}