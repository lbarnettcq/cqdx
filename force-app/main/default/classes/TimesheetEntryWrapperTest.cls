@isTest
public with sharing class TimesheetEntryWrapperTest {
    @isTest static void CompareTo_TwoDates_ReturnsPositiveNumber() {
        Integer expectNumber = 1;

        Map<String, Object> timesheetEntryFirst = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Map<String, Object> timesheetEntrySecond = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_END)
        };

        Test.startTest();

        TimesheetEntryWrapper tewFirst = new TimesheetEntryWrapper(timesheetEntryFirst);
        TimesheetEntryWrapper tewSecond = new TimesheetEntryWrapper(timesheetEntrySecond);
        Integer resultNumber = tewFirst.compareTo(tewSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }

    @isTest static void CompareTo_TwoDates_ReturnsNegativeNumber() {
        Integer expectNumber = -1;

        Map<String, Object> timesheetEntryFirst = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_END)
        };

        Map<String, Object> timesheetEntrySecond = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Test.startTest();

        TimesheetEntryWrapper tewFirst = new TimesheetEntryWrapper(timesheetEntryFirst);
        TimesheetEntryWrapper tewSecond = new TimesheetEntryWrapper(timesheetEntrySecond);
        Integer resultNumber = tewFirst.compareTo(tewSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }

    @isTest static void CompareTo_TwoDates_ReturnsZero() {
        Integer expectNumber = 0;

        Map<String, Object> timesheetEntryFirst = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Map<String, Object> timesheetEntrySecond = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Test.startTest();

        TimesheetEntryWrapper tewFirst = new TimesheetEntryWrapper(timesheetEntryFirst);
        TimesheetEntryWrapper tewSecond = new TimesheetEntryWrapper(timesheetEntrySecond);
        Integer resultNumber = tewFirst.compareTo(tewSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }
}