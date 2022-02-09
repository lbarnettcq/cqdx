@isTest
public with sharing class dao_ContractResourceTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOne_ParamsExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
         
        String employeeId = UserInfo.getUserId();
        List<Contract_Resource__c> contractResources = TEstDataFactory.getContractResourcesFromDb(employeeId);
        Contract_Resource__c contractResource = contractResources.get(0);
        
        Id expectContractResourceId = contractResource.Id;
        
        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c resultContractResource = daoContractResource.findOne(contractResource.Contract__c, employeeId);
        System.debug('@@@ FindOne_ParamsExistInDB_ReturnItem:result: ' + resultContractResource);

        System.assertEquals(expectExistItem, resultContractResource != null);
        System.assertEquals(expectContractResourceId, resultContractResource.Id);

        Test.stopTest();
    }

    @isTest static void FindOne_ParamsNull_ReturnNull() {
        Contract_Resource__c expectNotExistItem = null;
         
        String contractId = null;
        String employeeId = null;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c resultItem = daoContractResource.findOne(contractId, employeeId);
        System.debug('@@@ FindOne_ParamsNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOne_ParamsNotExistInDB_ReturnNull() {
        Contract_Resource__c expectNotExistItem = null;
         
        String contractId = TestDataFactory.getNotExistId();
        String employeeId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c resultItem = daoContractResource.findOne(contractId, employeeId);
        System.debug('@@@ FindOne_ParamsNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneById_IdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
         
        String employeeId = UserInfo.getUserId();
        List<Contract_Resource__c> contractResources = TestDataFactory.getContractResourcesFromDb(employeeId);
        Contract_Resource__c contractResource = contractResources.get(0);
        
        String expectContractResourceId = (String)contractResource.Id;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c resultContractResource = daoContractResource.findOneById(expectContractResourceId);
        System.debug('@@@ FindOneById_IdExistInDB_ReturnItem:result: ' + resultContractResource);

        System.assertEquals(expectExistItem, resultContractResource != null);
        System.assertEquals(expectContractResourceId, (String)resultContractResource.Id);

        Test.stopTest();
    }

    @isTest static void FindOneById_IdNotExistInDB_ReturnNull() {
        Contract_Resource__c expectNotExistItem = null;
         
        String id = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c resultItem = daoContractResource.findOneById(id);
        System.debug('@@@ FindOneById_IdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneById_IdNull_ReturnNull() {
        Contract_Resource__c expectNotExistItem = null;
         
        String id = null;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c resultItem = daoContractResource.findOneById(id);
        System.debug('@@@ FindOne_ParamsNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectNotEmptyList, resultListContractResources.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByIds_IdsExistInDB_ReturnNotEmptyList() {
        Set<String> ids = TestDataFactory.getContractResourcesIds(UserInfo.getUserId());
        Integer expectSizeList = ids.size();

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_IdsExistInDB_ReturnNotEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_IdsNotExistInDB_ReturnEmptyList() {
        Set<String> ids = TestDataFactory.getNotExistIds();
        Integer expectSizeList = 0;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_IdsNotExistInDB_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_IdsEmptyList_ReturnEmptyList() {
        Set<String> ids = new Set<String>();
        Integer expectSizeList = 0;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_IdsEmptyList_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllByAccount_AccountIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        String accountId = TestDataFactory.getAccountIdFromContractResource(UserInfo.getUserId());

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByAccount(accountId);
        System.debug('@@@ FindAllByAccount_AccountIdExistInDB_ReturnNotEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectNotEmptyList, resultListContractResources.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByAccount_AccountIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String accountId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByAccount(accountId);
        System.debug('@@@ FindAllByAccount_AccountIdNotExistInDB_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeEmptyList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllByAccount_AccountIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String accountId = null;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByAccount(accountId);
        System.debug('@@@ FindAllByAccount_AccountIdNull_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeEmptyList, resultListContractResources.size());

        Test.stopTest();
    }

     @isTest static void FindAllByContracts_ContractsIdsExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        List<String> ids = TestDataFactory.getContractsIdsFromContractResources(UserInfo.getUserId());
        Set<String> contractsIds = new Set<String>(ids);

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByContracts(contractsIds);
        System.debug('@@@ FindAllByContracts_ContractsIdsExistInDB_ReturnNotEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectNotEmptyList, resultListContractResources.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByContracts_ContractsIdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        Set<String> contractsIds = TestDataFactory.getNotExistIds();

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByContracts(contractsIds);
        System.debug('@@@ FindAllByContracts_ContractsIdsNotExistInDB_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeEmptyList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllByContracts_ContractsIdsEmpty_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        Set<String> contractsIds = new Set<String>();

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByContracts(contractsIds);
        System.debug('@@@ FindAllByContracts_ContractsIdsEmpty_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeEmptyList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllByContracts_ContractsIdsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        Set<String> contractsIds = null;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByContracts(contractsIds);
        System.debug('@@@ FindAllByContracts_ContractsIdsNull_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeEmptyList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllByUser_EmployeeIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
        
        List<Contract_Resource__c> contractResources = TestDataFactory.getContractResourcesFromDb();
        Contract_Resource__c cr = contractResources.get(0);
        String employeeId = cr.Employee__c;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByUser(employeeId);
        System.debug('@@@ FindAllByUser_EmployeeIdExistInDB_ReturnNotEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectNotEmptyList, resultListContractResources.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByUser_EmployeeIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String employeeId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByUser(employeeId);
        System.debug('@@@ FindAllByUser_EmployeeIdNotExistInDB_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeEmptyList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllByUser_EmployeeIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String employeeId = null;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByUser(employeeId);
        System.debug('@@@ FindAllByUser_EmployeeIdNull_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeEmptyList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllWithSubcontractor_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllWithSubcontractor();
        System.debug('@@@ FindAllWithSubcontractor_WithoutParams_ReturnNotEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectNotEmptyList, resultListContractResources.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByParams_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        String employeeId = UserInfo.getUserId();
        Set<String> contractsIds = new Set<String>(TestDataFactory.getContractsIdsFromContractResources(employeeId));

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByParams(contractsIds, employeeId);
        System.debug('@@@ FindAllByParams_ValidParams_ReturnNotEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectNotEmptyList, resultListContractResources.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByParams_EmployeeContractsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String employeeId = TestDataFactory.getNotExistId();
        Set<String> contractsIds = new Set<String>{TestDataFactory.getNotExistId()};

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByParams(contractsIds, employeeId);
        System.debug('@@@ FindAllByParams_EmployeeContractsNotExistInDB_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectSizeEmptyList, resultListContractResources.size());

        Test.stopTest();
    }

    @isTest static void FindAllByParams_ParamsNull_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        String employeeId = null;
        Set<String> contractsIds = null;

        Test.startTest();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> resultListContractResources = daoContractResource.findAllByParams(contractsIds, employeeId);
        System.debug('@@@ FindAllByParams_ParamsNull_ReturnEmptyList:result: ' + resultListContractResources);

        System.assertEquals(expectNotEmptyList, resultListContractResources.size() > sizeEmptyList);

        Test.stopTest();
    }
}