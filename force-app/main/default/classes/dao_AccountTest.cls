@isTest
public with sharing class dao_AccountTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindAccountsByNames_ListNames_ReturnNotEmptyList() {
        Set<String> names = TestDataFactory.getAccountsNames();
        Integer expectSizeList = names.size();
         
        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAccountsByNames(names);
        System.debug('@@@ FindAccountsByNames_ListNames_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAccountsByNames_EmptyList_ReturnEmptyList() {
        Integer expectSizeList = 0;
         
        Test.startTest();

        Set<String> names = new Set<String>();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAccountsByNames(names);
        System.debug('@@@ FindAccountsByNames_EmptyList_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }


    @isTest static void FindAccountsByNames_ListNull_ReturnEmptyList() {
        Integer expectSizeList = 0;
         
        Test.startTest();

        Set<String> names = null;

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAccountsByNames(names);
        System.debug('@@@ FindAccountsByNames_ListNull_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }
    
    @isTest static void FindOne_AccountIdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
         
        String expectAccountId = TestDataFactory.getAccountId();

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        Account resultAccount = daoAccount.findOne(expectAccountId);
        System.debug('@@@ FindOne_AccountIdExistInDB_ReturnItem:result: ' + resultAccount);

        System.assertEquals(expectExistItem, resultAccount != null);
        System.assertEquals(expectAccountId, (String)resultAccount.Id);

        Test.stopTest();
    }

    @isTest static void FindOne_AccountIdNotExistInDB_ReturnNull() {
        Account expecNotExistAccount = null;
         
        String accountId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        Account resultAccount = daoAccount.findOne(accountId);
        System.debug('@@@ FindOne_AccountIdNotExistInDB_ReturnNull:result: ' + resultAccount);

        System.assertEquals(expecNotExistAccount, resultAccount);

        Test.stopTest();
    }

    @isTest static void FindOne_AccountIdNull_ReturnNull() {
        Account expectNotExistAccount = null;
         
        String accountId = null;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        Account resultAccount = daoAccount.findOne(accountId);
        System.debug('@@@ FindOne_AccountIdNull_ReturnNull:result: ' + resultAccount);

        System.assertEquals(expectNotExistAccount, resultAccount);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Integer expectSizeList = TestDataFactory.ACCOUNTS_COUNT;
         
        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_AccountsIdsExistInDB_ReturnNotEmptyList() {
        Set<String> ids = TestDataFactory.getAccountsIds();
        Integer expectSizeList = ids.size();

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_AccountsIdsExistInDB_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_AccountsIdsNotExistInDB_ReturnEmptyList() {
        Set<String> ids = TestDataFactory.getNotExistIds();
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_AccountsIdsNotExistInDB_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_AccountsIdsEmptyList_ReturnEmptyList() {
        Set<String> ids = new Set<String>();
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_AccountsIdsEmptyList_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_AccountsIdsNull_ReturnEmptyList() {
        Set<String> ids = null;
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_AccountsIdsNull_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByNames_NamesExistInDB_ReturnNotEmptyList() {
        Set<String> names = TestDataFactory.getAccountsNames();
        Integer expectSizeList = names.size();

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByNames(names);
        System.debug('@@@ FindAllByNames_NamesExistInDB_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByNames_NamesNotExistInDB_ReturnEmptyList() {
        Set<String> names = TestDataFactory.getNotExistNames();
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByNames(names);
        System.debug('@@@ FindAllByNames_NamesNotExistInDB_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }


    @isTest static void FindAllByNames_NamesEmptyList_ReturnEmptyList() {
        Set<String> names = new Set<String>();
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByNames(names);
        System.debug('@@@ FindAllByNames_NamesEmptyList_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByNames_NamesNull_ReturnEmptyList() {
        Set<String> names = null;
        Integer expectSizeList = 0;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllByNames(names);
        System.debug('@@@ FindAllByNames_NamesNull_ReturnEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllWithContracts_ParamsNull_ReturnNotEmptyList() {
        Integer expectSizeList = TestDataFactory.ACCOUNTS_COUNT;

        String status = null;
        String employeeId = null;
        String contractResourceId = null;
        Set<String> contractsIds = null;

        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllWithContracts(status, employeeId, contractResourceId, contractsIds);
        System.debug('@@@ FindAllWithContracts_ParamsNull_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectSizeList, resultListAccounts.size());

        Test.stopTest();
    }

    @isTest static void FindAllWithContracts_ValidParamsWithContractResource_ReturnNotEmptyList() {
        Boolean expectEmptyList = true;
        Integer sizeEmptyList = 0;        

        String status = TestDataFactory.CONTRACT_STATUS_ACTIVED;

        String employeeId = UserInfo.getUserId();
        Set<String> contractsIds = new Set<String>(TestDataFactory.getContractsIdsFromContractResources(employeeId));

        List<Contract_Resource__c> contractResources = TestDataFactory.getContractResourcesFromDb(employeeId);
        Contract_Resource__c contractResource = contractResources.get(0);
        
        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllWithContracts(status, employeeId, contractResource.Id, contractsIds);
        System.debug('@@@ FindAllWithContracts_ValidParamsWithContractResource_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectEmptyList, resultListAccounts.size() > sizeEmptyList);

        Test.stopTest();
    }

     @isTest static void FindAllWithContracts_ValidParamsWithoutContractResource_ReturnNotEmptyList() {
        Boolean expectEmptyList = true;
        Integer sizeEmptyList = 0;        

        String status = TestDataFactory.CONTRACT_STATUS_ACTIVED;

        String employeeId = UserInfo.getUserId();
        Set<String> contractsIds = new Set<String>(TestDataFactory.getContractsIdsFromContractResources(employeeId));

        String contractResourceId = null;
        
        Test.startTest();

        dao_Account daoAccount = new dao_Account();
        List<Account> resultListAccounts = daoAccount.findAllWithContracts(status, employeeId, contractResourceId, contractsIds);
        System.debug('@@@ FindAllWithContracts_ValidParamsWithoutContractResource_ReturnNotEmptyList:result: ' + resultListAccounts);

        System.assertEquals(expectEmptyList, resultListAccounts.size() > sizeEmptyList);

        Test.stopTest();
    }
}