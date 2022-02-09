@isTest
private class cqtest_SoqlHelper {
    @isTest
    private static void regressionCoverage() {
        Schema.SObjectField dateField = Contact.Birthdate;
        Schema.SObjectField dateTimeField = Contact.CreatedDate;
        Schema.SObjectField numberField = Account.NumberOfEmployees;
        Schema.SObjectField booleanField = Contact.DoNotCall;
        Schema.SObjectField stringField = Account.Name;

        Date testDate = System.Date.today();
        DateTime testDateTime = System.DateTime.now();
        Integer testNumber = 3;
        Boolean testBoolean = false;
        String testString = 'Yep, that just happened';

        List<SObject> getValuesSObjects = new List<SObject>{
                (SObject) new Account(Name = 'Peter'),
                (SObject) new Account(Name = 'Paul'),
                (SObject) new Account(Name = 'Mary')
        };

        String accountIdPrefix = Account.getSObjectType().getDescribe().getKeyPrefix();
        List<SObject> getIdsSObjects = new List<SObject>{
                (SObject) new Account(Id = cq_SchemaHelper.GenerateIdFor(Account.getSObjectType())),
                (SObject) new Account(Id = cq_SchemaHelper.GenerateIdFor(Account.getSObjectType()))
        };

        String NULL_VALUE = 'null';

        List<Object> stringsToConvert = new List<Object> {
                (Object) 'Peter',
                (Object) 'Paul',
                (Object) 'Mary'
        };

        Test.startTest();

        String dateResults = cq_SoqlHelper.FormatForSoql(dateField, (Object) testDate);
        String dateResults2 = cq_SoqlHelper.FormatForSoql(dateField, (Object) null);
        String dateTimeResults = cq_SoqlHelper.FormatForSoql(dateTimeField, (Object) testDateTime);
        String dateTimeResults2 = cq_SoqlHelper.FormatForSoql(dateTimeField, (Object) null);
        String numberResults = cq_SoqlHelper.FormatForSoql(numberField, (Object) testNumber);
        String numberResults2 = cq_SoqlHelper.FormatForSoql(numberField, (Object) null);
        String booleanResults = cq_SoqlHelper.FormatForSoql(booleanField, (Object) testBoolean);
        String booleanResults2 = cq_SoqlHelper.FormatForSoql(booleanField, (Object) null);
        String stringResults = cq_SoqlHelper.FormatForSoql(stringField, (Object) testString);
        String stringResults2 = cq_SoqlHelper.FormatForSoql(stringField, (Object) null);

        Set<String> getValuesResults = cq_SoqlHelper.GetValues(Account.Name, getValuesSObjects);
        Set<String> getValuesResultsEmpty = cq_SoqlHelper.GetValues(Account.Name, null);
        Set<Id> getIdsResults = cq_SoqlHelper.GetIds(Account.Id, getIdsSObjects);
        Set<Id> getIdsResultsEmpty = cq_SoqlHelper.GetIds(Account.Id, null);
        Set<Id> getIdsForResults = cq_SoqlHelper.GetIdsFor(Account.getSObjectType(), Account.Id, getIdsSObjects);
        Set<Id> getIdsForResultsEmpty = cq_SoqlHelper.GetIdsFor(Account.getSObjectType(), Account.Id, null);
        String padResults = cq_SoqlHelper.AddLeadingZeros(2, 6);
        String padResults2 = cq_SoqlHelper.AddLeadingZeros(1, 6);
        String padResults3 = cq_SoqlHelper.AddLeadingZeros(2, null);

        String listConversionResults = cq_SoqlHelper.FormatListForMatching(Account.Name, stringsToConvert);

        String formatResults1 = cq_SoqlHelper.FormattedValue((Object) testDate);
        String formatResults2 = cq_SoqlHelper.FormattedValue((Object) testDateTime);
        String formatResults3 = cq_SoqlHelper.FormattedValue((Object) testNumber);
        String formatResults4 = cq_SoqlHelper.FormattedValue((Object) testString);
        String formatResults5 = cq_SoqlHelper.FormattedValue((Object) testBoolean);
        String formatResults6 = cq_SoqlHelper.FormattedValue((Object) null);

        Test.stopTest();

        System.assertEquals(dateResults == NULL_VALUE, false);
        System.assertEquals(dateResults2, '');
        System.assertEquals(dateTimeResults == NULL_VALUE, false);
        System.assertEquals(dateTimeResults2, '');
        System.assertEquals(numberResults == NULL_VALUE, false);
        System.assertEquals(numberResults2, null);
        System.assertEquals(booleanResults == NULL_VALUE, false);
        System.assertEquals(booleanResults2, '');
        System.assertEquals(stringResults == NULL_VALUE, false);
        System.assertEquals(stringResults2, NULL_VALUE);

        System.assertEquals(getValuesResults.size(), 3);
        System.assertEquals(getValuesResultsEmpty.isEmpty(), true);
        System.assertEquals(getIdsResults.size(), 2);
        System.assertEquals(getIdsResultsEmpty.isEmpty(), true);
        System.assertEquals(getIdsForResults.size(), 2);
        System.assertEquals(getIdsForResultsEmpty.isEmpty(), true);
        System.assertEquals(padResults, '06');
        System.assertEquals(padResults2, '6');
        System.assertEquals(padResults3, '');

        System.assertEquals(cq_StringHelper.Contains(listConversionResults, 'Peter'), true);
        System.assertEquals(cq_StringHelper.Contains(listConversionResults, ','), true);

        System.assertEquals(formatResults1 == NULL_VALUE, false);
        System.assertEquals(formatResults2 == NULL_VALUE, false);
        System.assertEquals(formatResults3 == NULL_VALUE, false);
        System.assertEquals(formatResults4 == NULL_VALUE, false);
        System.assertEquals(formatResults5 == NULL_VALUE, false);
        System.assertEquals(formatResults6, '');
    }
}