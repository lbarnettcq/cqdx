/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_User extends sql_Dao {
    public dao_User() {
        setSObject(User.sObjectType);

        addField(User.Id);
        addField(User.Name);
        addField(User.Subcontractor_Rate__c	);
    }

    public User findOne(String id) {
          List<User> users = getWhere(sql_Criteria.Equals(User.Id, id));

          if(users.isEmpty()) {
               return null;
          }

          return users[0];
    }

    public User findOneByTimesheet(String timesheetId) {
        List<Timesheet_entry__c> timesheetEntries = [SELECT Employee__c FROM Timesheet_entry__c WHERE TimesheetId__c = :timesheetId LIMIT 1];

        if(timesheetEntries.isEmpty()) {
            return null;
        }

        List<User> users = [SELECT Name FROM User WHERE Id = :timesheetEntries.get(0).Employee__c LIMIT 1];

        if(users.isEmpty()) {
            return null;
        }
        
        return users.get(0);
    }

    public List<User> findAll() {
       Set<String> standardUsers = new Set<String> {//TODO:review standart | all?
           'Automated Process',
           'Data.com Clean',
           'Integration User',
           'Security User',
           'Chatter Expert'
       };

       return (List<User>)getWhere(sql_Criteria.ValueNotIn(User.Name, standardUsers));
    }

    public List<User> findAllByIds(Set<String> ids) {
        if(ids == null || ids.isEmpty()) {
            return new List<User>();
        }

        return (List<User>)getWhere(sql_Criteria.ValueIn(User.Id, ids));
    }


    public List<User> findAllWithTimesheetEntries() {
        sql_Query timesheetEntriesQuery = new sql_Query();

        timesheetEntriesQuery.setSObject('Timesheet_Entries__r');
        
        timesheetEntriesQuery.addField('Id');
        timesheetEntriesQuery.addField('Date__c');
        timesheetEntriesQuery.addField('Minutes__c');
        timesheetEntriesQuery.addField('Employee__c');
        timesheetEntriesQuery.addField('Is_Approved__c');
        timesheetEntriesQuery.addField('LastModifiedDate');

        addChild(timesheetEntriesQuery);

        List<User> users = findAll();

        query.children.clear();

        return users;
    }

    public List<User> findAllWithExpenseEntries() {
        List<AggregateResult> expenses = [
            SELECT 
                    Contract_resource__r.Employee__c  employeeId
            FROM 
                    Expense_entry__c 
            GROUP BY 
                    Contract_resource__r.Employee__c                    
        ];

        Set<String> userIds = new Set<String>();

        for(AggregateResult expense : expenses) {
            String employeeId = (String)expense.get('employeeId');
            userIds.add(employeeId);
        }

        List<User> users = findAllByIds(userIds);

        return users;
    }
}