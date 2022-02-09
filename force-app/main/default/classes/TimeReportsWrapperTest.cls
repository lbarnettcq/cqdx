@isTest
public with sharing class TimeReportsWrapperTest {
    @isTest static void CompareTo_TwoDates_ReturnsPositiveNumber() {
        Integer expectNumber = 1;

        Map<String, Object> timeReportFirst = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Map<String, Object> timeReportSecond = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_END)
        };

        Test.startTest();

        TimeReportsWrapper timeReportWrapperFirst = new TimeReportsWrapper(timeReportFirst);
        TimeReportsWrapper timeReportWrapperSecond = new TimeReportsWrapper(timeReportSecond);
        Integer resultNumber = timeReportWrapperFirst.compareTo(timeReportWrapperSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }

    @isTest static void CompareTo_TwoDates_ReturnsNegativeNumber() {
        Integer expectNumber = -1;

        Map<String, Object> timeReportFirst = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_END)
        };

        Map<String, Object> timeReportSecond = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Test.startTest();

        TimeReportsWrapper timeReportWrapperFirst = new TimeReportsWrapper(timeReportFirst);
        TimeReportsWrapper timeReportWrapperSecond = new TimeReportsWrapper(timeReportSecond);
        Integer resultNumber = timeReportWrapperFirst.compareTo(timeReportWrapperSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }

    @isTest static void CompareTo_TwoDates_ReturnsZero() {
        Integer expectNumber = 0;

        Map<String, Object> timeReportFirst = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Map<String, Object> timeReportSecond = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Test.startTest();

        TimeReportsWrapper timeReportWrapperFirst = new TimeReportsWrapper(timeReportFirst);
        TimeReportsWrapper timeReportWrapperSecond = new TimeReportsWrapper(timeReportSecond);
        Integer resultNumber = timeReportWrapperFirst.compareTo(timeReportWrapperSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }
}