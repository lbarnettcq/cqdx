@isTest
public with sharing class service_UserTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetUserById_UserIdExistInDB_ReturnUserInfo() {
        Map<String, String> notExistItem = null;

        String expectUserId = TestDataFactory.getUserId();
        
        service_Request request = new service_Request();
        request.Parameters.put('action', 'getUserById');
        request.Parameters.put('userId', expectUserId);

        service_Response response = new service_Response();

        Test.startTest();

        service_User serviceUser = new service_User();
        serviceUser.process(request, response);
        Map<String, String> resultItem = (Map<String, String>)response.Parameters.get('user');
        System.debug('@@@ GetUserById_UserIdExistInDB_ReturnUserInfo:result: ' + resultItem);

        System.assertNotEquals(notExistItem, resultItem);
        System.assertEquals(expectUserId, resultItem.get('id'));

        Test.stopTest();
    }

     @isTest static void GetUserById_UserIdNotExistInDB_ReturnNull() {
        Map<String, String> expectNotExistItem = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getUserById');
        request.Parameters.put('userId', TestDataFactory.getNotExistId());//TODO:rename to id

        service_Response response = new service_Response();

        Test.startTest();

        service_User serviceUser = new service_User();
        serviceUser.process(request, response);
        Map<String, String> resultItem = (Map<String, String>)response.Parameters.get('user');
        System.debug('@@@ GetUserById_UserIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

     @isTest static void GetUserById_UserIdNull_ReturnNull() {
        Map<String, String> expectNotExistItem = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getUserById');
        request.Parameters.put('userId', null);//TODO:rename to id

        service_Response response = new service_Response();

        Test.startTest();

        service_User serviceUser = new service_User();
        serviceUser.process(request, response);
        Map<String, String> resultItem = (Map<String, String>)response.Parameters.get('user');
        System.debug('@@@ GetUserById_UserIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void GetUsers_WithoutParams_ReturnNotEmptyList() {
        Integer expectSizeList = TestDataFactory.getStandartUsersFromDb().size();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getUsers');//TODO: rename method to getList

        service_Response response = new service_Response();

        Test.startTest();

        service_User serviceUser = new service_User();
        serviceUser.process(request, response);
        List<User> resultListItems = (List<User>)response.Parameters.get('list');
        System.debug('@@@ GetUsers_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size());

        Test.stopTest();
    }
}