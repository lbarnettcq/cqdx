@isTest
public with sharing class dao_ContractTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOne_ContractIdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;         
        String expectContractId = TestDataFactory.getContractId();

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        Contract resultItem = daoContract.findOne(expectContractId);
        System.debug('@@@ FindOne_ContractIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);
        System.assertEquals(expectContractId, resultItem.Id);

        Test.stopTest();
    }

    @isTest static void FindOne_ContractIdNotExistInDB_ReturnNull() {
        Contract expectNotExistItem = null;         
        String contractId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        Contract resultItem = daoContract.findOne(contractId);
        System.debug('@@@ FindOne_ContractIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOne_ContractIdNull_ReturnNull() {
        Contract expectNotExistItem = null;         
        String contractId = null;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        Contract resultItem = daoContract.findOne(contractId);
        System.debug('@@@ FindOne_ContractIdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneByContractResource_ContractResourceIdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
         
        String employeeId = UserInfo.getUserId();       
        List<Contract_Resource__c> contractResources = TestDataFactory.getContractResourcesFromDb(employeeId);
        Contract_Resource__c contractResource = contractResources.get(0);
        String expectContractId = contractResource.Contract__c;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        Contract resultItem = daoContract.findOneByContractResource(contractResource.Id);
        System.debug('@@@ FindOneByContractResource_ContractResourceIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);
        System.assertEquals(expectContractId, resultItem.Id);

        Test.stopTest();
    }

    @isTest static void FindOneByContractResource_ContractResourceIdNotExistInDB_ReturnNull() {
        Contract expectNotExistItem = null;
         
        String contractResourceId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        Contract resultItem = daoContract.findOneByContractResource(contractResourceId);
        System.debug('@@@ FindOneByContractResource_ContractResourceIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneByContractResource_ContractResourceIdNull_ReturnNull() {
        Contract expectNotExistItem = null;
         
        String contractResourceId = null;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        Contract resultItem = daoContract.findOneByContractResource(contractResourceId);
        System.debug('@@@ FindOneByContractResource_ContractResourceIdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Integer expectSizeList = TestDataFactory.CONTRACTS_COUNT;
         
        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByAccount_AccountIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        List<Contract> contracts = TestDataFactory.getContractsFromDb();
        Contract cContract = contracts.get(0);

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllByAccount(cContract.AccountId);
        System.debug('@@@ FindAllByAccount_AccountIdExistInDB_ReturnNotEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectNotEmptyList, resultListContracts.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByAccount_AccountIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String accountId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllByAccount(accountId);
        System.debug('@@@ FindAllByAccount_AccountIdNotExistInDB_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByAccount_AccountIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String accountId = null;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllByAccount(accountId);
        System.debug('@@@ FindAllByAccount_AccountIdNull_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByStatus_StatusExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        String status = TestDataFactory.CONTRACT_STATUS_ACTIVED;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllByStatus(status);
        System.debug('@@@ FindAllByStatus_StatusExistInDB_ReturnNotEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectNotEmptyList, resultListContracts.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByStatus_StatusNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String status = TestDataFactory.STATUS_NOT_EXIST;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllByStatus(status);
        System.debug('@@@ FindAllByStatus_StatusNotExistInDB_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByStatus_StatusNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String status = null;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllByStatus(status);
        System.debug('@@@ FindAllByStatus_StatusNull_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void FindAllBySalesperson_EmployeeIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
        
        List<Contract> contracts = TestDataFactory.getContractsFromDb();
        Contract cContract = contracts.get(0);
        String employeeId = cContract.Salesperson__c;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllBySalesperson(employeeId);
        System.debug('@@@ FindAllBySalesperson_EmployeeIdExistInDB_ReturnNotEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectNotEmptyList, resultListContracts.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllBySalesperson_EmployeeIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String employeeId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllBySalesperson(employeeId);
        System.debug('@@@ FindAllBySalesperson_EmployeeIdNotExistInDB_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void FindAllBySalesperson_EmployeeIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String employeeId = null;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllBySalesperson(employeeId);
        System.debug('@@@ FindAllBySalesperson_EmployeeIdNull_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByReferral_AccountIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        List<Contract> contracts = TestDataFactory.getContractsFromDb();
        Contract cContract = contracts.get(0);
        String accountId = cContract.Referred_By__c;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllByReferral(accountId);
        System.debug('@@@ FindAllByReferral_AccountIdExistInDB_ReturnNotEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectNotEmptyList, resultListContracts.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByReferral_AccountIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String accountId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllByReferral(accountId);
        System.debug('@@@ FindAllByReferral_AccountIdNotExistInDB_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void FindAllByReferral_AccountIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String accountId = null;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.findAllByReferral(accountId);
        System.debug('@@@ FindAllByReferral_AccountIdNull_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void GetManagedServicesContractsByAccounts_AccountsIdsExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        Set<String> accountsIds = TestDataFactory.getAccountsIds();
        Set<Id> setAccountsIds = new Set<Id>();

        for(String accountId : accountsIds) {
            setAccountsIds.add((Id)accountId);
        }

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.getManagedServicesContractsByAccounts(setAccountsIds);
        System.debug('@@@ GetManagedServicesContractsByAccounts_AccountsIdsExistInDB_ReturnNotEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectNotEmptyList, resultListContracts.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetManagedServicesContractsByAccounts_AccountsIdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        Set<String> accountsIds = TestDataFactory.getNotExistIds();
        Set<Id> setAccountsIds = new Set<Id>();

        for(String accountId : accountsIds) {
            setAccountsIds.add((Id)accountId);
        }


        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.getManagedServicesContractsByAccounts(setAccountsIds);
        System.debug('@@@ GetManagedServicesContractsByAccounts_AccountsIdsNotExistInDB_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void GetManagedServicesContractsByAccounts_AccountsIdsEmpty_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        Set<Id> accountsIds = new Set<Id>();

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.getManagedServicesContractsByAccounts(accountsIds);
        System.debug('@@@ GetManagedServicesContractsByAccounts_AccountsIdsEmpty_ReturnEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectSizeEmptyList, resultListContracts.size());

        Test.stopTest();
    }

    @isTest static void GetContractsWithSalesperson_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.getContractsWithSalesperson();
        System.debug('@@@ GetContractsWithSalesperson_WithoutParams_ReturnNotEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectNotEmptyList, resultListContracts.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetContractsWithReferral_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        Test.startTest();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> resultListContracts = daoContract.getContractsWithReferral();
        System.debug('@@@ GetContractsWithReferral_WithoutParams_ReturnNotEmptyList:result: ' + resultListContracts);

        System.assertEquals(expectNotEmptyList, resultListContracts.size() > sizeEmptyList);

        Test.stopTest();
    }
}