/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_Payments extends service_Base {
    private final String STATUS_NEW = 'New';
    private final String STATUS_PAID = 'Paid';

    private Map<String, String> chainStatuses = new Map<String,String> {
        STATUS_NEW => STATUS_PAID
    };

    private final String PAYMENT_TYPE_SUBCONTRACTOR = 'Subcontractor';
    private final String PAYMENT_TYPE_COMMISIONS = 'Commissions';
    private final String PAYMENT_TYPE_REFERRAL = 'Referral';
    private final String PAYMENT_TYPE_EXPENSES_REIMBURSEMENT = 'Expenses Reimbursement';

    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getTypes' {
                getTypes(request, response);
            }
            when 'getList' {
                getList(request, response);
            }
            when 'getTotalCount' {
                getTotalCount(request, response);
            }
            when 'getListItems' {
                getListItems(request, response);
            }
            when 'getTotalItemsCount' {
                getTotalItemsCount(request, response);
            }
            when 'getReceivers' {
                getReceivers(request, response);
            }
            when 'getInformation' {
                getInformation(request, response);
            }
            when 'insertEntry' {
                insertEntry(request, response);
            }
            when 'updateEntry' {
                updateEntry(request, response);
            }
            when 'refreshPayments' {
                refreshPayments(request, response);
            }
            when 'deleteEntry' {
                deleteEntry(request, response);
            }
            when 'updateStatus' {
                updateStatus(request, response);
            }
            when 'availableEntity' {
                availableEntity(request, response);
            }
        }
    }

    public void getTypes(service_Request request, service_Response response) {
        List<Map<String, String>> types = new List<Map<String, String>>();

        Schema.DescribeFieldResult fieldResult = Payment__c.Payment_type__c.getDescribe();//TODO: move to Dao
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pe : ple) {
            Map<String, String> type = new Map<String, String> {
                'id' => pe.getValue(),
                'label' => pe.getLabel()
            };   
             
            types.add(type);
        }     

        response.Parameters.put('list', types);
    }

    public void getList(service_Request request, service_Response response) {
        Integer limits = (Integer)request.Parameters.get('limits');
        Integer offset = (Integer)request.Parameters.get('offset');

        List<PaymentWrapper> payments = getPayments();

        List<Map<String, Object>> filteredPayments = filter(payments, limits, offset);

        response.Parameters.put('list', filteredPayments);
    }

    public void getTotalCount(service_Request request, service_Response response) {
        response.Parameters.put('count', getPayments().size());
    }

    public void getListItems(service_Request request, service_Response response) {
        Integer limits = (Integer)request.Parameters.get('limits');
        Integer offset = (Integer)request.Parameters.get('offset');
        String paymentId = (String)request.Parameters.get('paymentId');

        Payment__c payment = getPayment(paymentId);

        List<PaymentWrapper> paymentLineItems = getPaymentItems(payment.Id);

        paymentLineItems.sort();

        List<Map<String,Object>> filteredPaymentLineItems = filter(paymentLineItems, limits, offset);

        response.Parameters.put('list', filteredPaymentLineItems);
    }

    public void getTotalItemsCount(service_Request request, service_Response response) {
        String paymentId = (String)request.Parameters.get('paymentId');
        Payment__c payment = getPayment(paymentId);

        dao_PaymentsLineItem daoPaymentsLineItem = new dao_PaymentsLineItem();
        List<Payment_Line_Item__c> paymentLineItems = daoPaymentsLineItem.findByPayment(payment.Id);

        response.Parameters.put('count', paymentLineItems.size());
    }

    public void getReceivers(service_Request request, service_Response response) {
        String paymentType = (String)request.Parameters.get('paymentType');
        List<Map<String, String>> receivers = new List<Map<String, String>>();

        switch on paymentType {
            when 'Subcontractor' {
                receivers = getReceiversBySubcontractor();
            }
            when 'Referral' {
                receivers = getReceiversByReferral();
            }
            when 'Commissions' {
                receivers = getReceiversByCommissions();
            }   
            when 'Expenses Reimbursement' {
                receivers = getReceiversByExpenses();
            }
        }

        response.Parameters.put('list', receivers);
    }
    
    public void getInformation(service_Request request, service_Response response) {
        Map<String, Object> paymentInfo = new Map<String,Object>();

        String paymentId = (String)request.Parameters.get('paymentId');

        Payment__c payment = getPayment(paymentId);

        String receiverName = null;
        String receiverUrl = null;

        if(payment.Payment_type__c == 'Subcontractor' || payment.Payment_type__c == 'Referral') {
            dao_Account daoAccount = new dao_Account();
            Account account = daoAccount.findOne(payment.ReceiverId__c);
            receiverName = (account != null) ? account.Name : null;
            receiverUrl = AppConfig.getAccountUrl(payment.ReceiverId__c);
        } else {
            dao_User daoUser = new dao_User();
            User user = daoUser.findOne(payment.ReceiverId__c);
            receiverName = (user != null) ? user.Name : null;
            receiverUrl = AppConfig.getUserUrl(payment.ReceiverId__c);
        }

        paymentInfo = new Map<String, Object> {
            'paymentId' => paymentId,
            'paymentNumber' => payment.Name,
            'paymentType' => payment.Payment_type__c,
            'lastModifiedDate'=> payment.Last_updated__c,
            'status' => payment.Status__c,
            'receiverId' => payment.ReceiverId__c,
            'receiverName' => receiverName,
            'receiverUrl' => receiverUrl,
            'startDate' => payment.startDate__c,
            'endDate' => payment.endDate__c,
            'paidInvoices' => payment.Is_Paid_Invoices__c,
            'pendingInvoices' => payment.Is_Pending_invoices__c,
            'pendingInvoicesStartDate' => payment.Pending_invoices_startDate__c,
            'totalMinutes' => payment.Total_Minutes__c,
            'totalAmount' => payment.Total_Amount__c,
            'isPaid' => payment.is_Paid__c,
            'paymentDate' => payment.paymentDate__c
        };

        response.Parameters.put('item', paymentInfo);
    }

    public void insertEntry(service_Request request, service_Response response) {
        String paymentType = String.valueof(request.Parameters.get('paymentType'));
        String receiverId = String.valueof(request.Parameters.get('receiverId'));
        Date startDate = Date.valueof(request.Parameters.get('startDate'));
        Date endDate = Date.valueof(request.Parameters.get('endDate'));
        Boolean paidInvoices = Boolean.valueof(request.Parameters.get('paidInvoices'));
        Boolean pendingInvoices = Boolean.valueof(request.Parameters.get('pendingInvoices'));
        Date pendingInvoicesStartDate = Date.valueof(request.Parameters.get('pendingInvoicesStartDate'));

        if(!validType(paymentType)) {
            generateNoDataFoundError('Payment type ' + paymentType + ' not found');
        }   

        if(!validReceiver(paymentType, receiverId)) {
            generateNoDataFoundError('Reseiver ' + receiverId + ' not found');
        }

        Map<String, Object> conditions = new Map<String, Object> {
            'paymentId' => null,
            'paymentType' => paymentType,
            'receiverId' => receiverId,
            'startDate' => startDate,
            'endDate' => endDate
        };

        dao_Payments daoPayments = new dao_Payments();
        Boolean existPaymentsInPeriod = daoPayments.existPaymentsInPeriod(conditions);
        
        if(existPaymentsInPeriod) {
            generateNoAccessError('You already have payments for these dates');
        }

        Payment__c payment = new Payment__c();
        payment.Payment_type__c = paymentType;
        payment.StartDate__c = startDate;
        payment.EndDate__c = endDate;
        payment.Status__c = STATUS_NEW;
        payment.Last_updated__c = Datetime.now();       
        payment.ReceiverId__c = receiverId;
        payment.Total_Amount__c = 0;
        payment.Total_Minutes__c = 0;
        
        if(paidInvoices != null) {
             payment.Is_Paid_Invoices__c = paidInvoices;
        }

        if(pendingInvoices == true && pendingInvoicesStartDate != null) {
            payment.Is_Pending_invoices__c = pendingInvoices;
            payment.Pending_invoices_startDate__c = pendingInvoicesStartDate;  
        }

        Map<String, Payment_Line_Item__c> mapPaymentLineItems = processingPayment(payment);

        insert payment;

        List<Payment_Line_Item__c> paymentListItems = new List<Payment_Line_Item__c>();
        for(String key :  mapPaymentLineItems.keySet()) {
            Payment_Line_Item__c paymentListItem = mapPaymentLineItems.get(key);
            paymentListItem.Payment__c = payment.Id;
            paymentListItems.add(paymentListItem);
        }

        insert paymentListItems;  

        response.Parameters.put('item', payment);     
    }
    
    public void updateEntry(service_Request request, service_Response response) {
        String paymentId = String.valueof(request.Parameters.get('paymentId'));
        String paymentType = String.valueof(request.Parameters.get('paymentType'));
        String receiverId = String.valueof(request.Parameters.get('receiverId'));
        Date startDate = Date.valueof(request.Parameters.get('startDate'));
        Date endDate = Date.valueof(request.Parameters.get('endDate'));
        Boolean paidInvoices = Boolean.valueof(request.Parameters.get('paidInvoices'));
        Boolean pendingInvoices = Boolean.valueof(request.Parameters.get('pendingInvoices'));
        Date pendingInvoicesStartDate = Date.valueof(request.Parameters.get('pendingInvoicesStartDate'));
        
        Payment__c payment = getPayment(paymentId);
        
        Boolean useCheckExistPayment = false;

        if((paymentType != null && payment.Payment_type__c != paymentType)) {
            payment.Payment_type__c = paymentType;
            useCheckExistPayment = true;
        }
        
        if(receiverId != null && payment.ReceiverId__c != receiverId) {
            payment.ReceiverId__c = receiverId;
            useCheckExistPayment = true;        
        }

        if(startDate != null && payment.StartDate__c != startDate) {
            payment.StartDate__c = startDate;
            useCheckExistPayment = true; 
        }


        if(endDate != null && payment.EndDate__c != endDate) {
            payment.EndDate__c = endDate;
            useCheckExistPayment = true; 
        }

        if(useCheckExistPayment) {
            Map<String, Object> conditions = new Map<String, Object> {
                'paymentType' => paymentType,
                'receiverId' => receiverId,
                'startDate' => startDate,
                'endDate' => endDate,
                'paymentId' => paymentId
            };
            
            dao_Payments daoPayments = new dao_Payments();
            Boolean existPaymentsInPeriod = daoPayments.existPaymentsInPeriod(conditions);
            if(existPaymentsInPeriod) {
                generateNoAccessError('You already have payments for these dates');
            }
        }

        dao_PaymentsLineItem daoPaymentsLineItem = new dao_PaymentsLineItem();
        List<Payment_Line_Item__c> paymentLineItems = daoPaymentsLineItem.findByPayment(paymentId);
        delete paymentLineItems;

        if(paidInvoices != null) {
            payment.Is_Paid_Invoices__c = paidInvoices;
        }

        if(pendingInvoices != null) {
            payment.Is_Pending_invoices__c = pendingInvoices;
        }

        if(pendingInvoices == true && pendingInvoicesStartDate != null) {
            payment.Pending_invoices_startDate__c = pendingInvoicesStartDate;  
        }

        payment.Last_updated__c = Datetime.now();
        
        payment.Total_Amount__c = 0;
        payment.Total_Minutes__c = 0;

        Map<String, Payment_Line_Item__c> mapPaymentLineItems = processingPayment(payment);

        update payment;

        List<Payment_Line_Item__c> paymentListItems = new List<Payment_Line_Item__c>();
        for(String key :  mapPaymentLineItems.keySet()) {
            Payment_Line_Item__c paymentListItem = mapPaymentLineItems.get(key);
            paymentListItem.Payment__c = payment.Id;
            paymentListItems.add(paymentListItem);
        }

        insert paymentListItems;

        response.Parameters.put('item', payment);
    }    

    public void deleteEntry(service_Request request, service_Response response) {
        String paymentId = String.valueof(request.Parameters.get('paymentId'));

        Payment__c payment = getPayment(paymentId);

        if(payment.Status__c != 'New') {
            generateNoAccessError('You can not delete payment with "' + payment.Status__c + '" status'); 
        }

        delete payment;

        response.Parameters.put('status', AppConfig.STATUS.get('success'));
    }

    public void updateStatus(service_Request request, service_Response response) {
        String paymentId = (String)request.Parameters.get('paymentId');
        Date paymentDate = (Date)request.Parameters.get('paymentDate');

        Payment__c payment = getPayment(paymentId);

        if(payment.Status__c == STATUS_PAID) {
            generateNoAccessError('You can not update status for paid payment');
        }

        String newPaymentStatus = getStatus(payment.Status__c);

        if(newPaymentStatus != null) {
            payment.Status__c = newPaymentStatus;
            
            if(newPaymentStatus == STATUS_PAID) {
                payment.is_Paid__c = true;

                if(paymentDate == null) {
                    Map<String, Object> error = new Map<String, Object> {
                        'code' => 400,
                        'message' => 'Invalid parameters',
                        'list' => new List<Map<String, String>>{
                            new Map<String, String>{
                                'type' => 'ValidationError',
                                'field' => 'paymentDate',
                                'message' => 'Payment date is not valid'
                            }
                        }
                    };

                    response.Parameters.put('status', error);

                    return;
                }

                payment.paymentDate__c = paymentDate;                               
            }

            payment.Last_updated__c = Datetime.now();

            update payment;
        }

        response.Parameters.put('status', payment.Status__c );
    }

    public void availableEntity(service_Request request, service_Response response) {
        String paymentId = String.valueof(request.Parameters.get('paymentId'));

        //TODO:replace by getPayment and refactor error
        dao_Payments daoPayments = new dao_Payments();
        Payment__c payment = daoPayments.findOne(paymentId);
        
        if(payment != null) {
            response.Parameters.put('status', 'available');
            response.Parameters.put('message', 'This record is available.');
        } else {
            response.Parameters.put('status', 'unavailable');
            response.Parameters.put('message', 'This record is no longer available. Ask your administrator for help.');
        }
    }

    public void refreshPayments(service_Request request, service_Response response) {
        List<Invoice__c> invoices = (List<Invoice__c>)request.Parameters.get('invoices');
        List<Payment__c> listPayments = new List<Payment__c>();

        if(invoices.isEmpty()) {
            generateNoDataFoundError('Invoices are empty');
        }

        Invoice__c invoice = invoices[0];

        String invoiceId = invoice.Id;
        Date startDate = invoice.StartDate__c;
        Date endDate = invoice.EndDate__c;

        if(invoiceId != null && startDate != null && endDate != null) {
            dao_Payments daoPayments = new dao_Payments();
            List<Payment__c> listAllPayments = daoPayments.findAll();

            for(Payment__c payment : listAllPayments) {
                if(payment.Status__c != 'Paid' && startDate >= payment.StartDate__c && endDate <= payment.EndDate__c) {
                    listPayments.add(payment);
                }
            }

            if(!listPayments.isEmpty()) {
                for(Payment__c payment : listPayments) {
                    request = new service_Request();
	                request.Parameters.put('paymentId', payment.Id);
                    request.Parameters.put('paymentType', payment.Payment_type__c);
                    request.Parameters.put('receiverId', payment.ReceiverId__c);
                    request.Parameters.put('startDate', payment.startDate__c);
                    request.Parameters.put('endDate', payment.endDate__c);
                    request.Parameters.put('paidInvoices', payment.Is_Paid_Invoices__c);
                    request.Parameters.put('pendingInvoices', payment.Is_Pending_invoices__c);
                    request.Parameters.put('pendingInvoicesStartDate', payment.Pending_invoices_startDate__c);
                    request.Parameters.put('action', 'updateEntry');

	                service_Controller.process(Services.Payments, request);
                }
            }
        }

        response.Parameters.put('items', listPayments);
    }

    private List<PaymentWrapper> getPayments() {
        List<PaymentWrapper> listPayments = new List<PaymentWrapper>();
        PaymentWrapper paymentRecord = null;
       
        dao_Account daoAccount = new dao_Account();
        List<Account> listAccounts = daoAccount.findAll();
        Map<String, String> mapAccounts = new Map<String, String>();

        for(Account account : listAccounts) {
            mapAccounts.put(account.Id,account.Name);
        }

        dao_User daoUser = new dao_User();
        List<User> listUsers = daoUser.getAll();
        Map<String, String> mapUsers = new Map<String, String>();

        for(User user : listUsers) {
            mapUsers.put(user.Id,user.Name);
        }        

        dao_Payments daoPayments = new dao_Payments();
        List<Payment__c> payments = daoPayments.findAll();

        for (Payment__c payment : payments) {
            String receiverName = null;
            String receiverUrl = null;

            if(payment.Payment_type__c == 'Subcontractor' || payment.Payment_type__c == 'Referral') {
                receiverName = mapAccounts.get(payment.ReceiverId__c);
                receiverUrl = AppConfig.getAccountUrl(payment.ReceiverId__c);
            } else {
                receiverName = mapUsers.get(payment.ReceiverId__c);
                receiverUrl = AppConfig.getUserUrl(payment.ReceiverId__c);
            }
            
            Decimal totalAmount = 0;
            if(payment.Total_Amount__c > 0) {
                totalAmount = (payment.Total_Amount__c).setScale(2);
            }

            paymentRecord = new PaymentWrapper(new Map<String, Object> {
                'paymentId' => payment.Id,
                'paymentNumber' => payment.Name,    
                'paymentType' => payment.Payment_type__c,            
                'receiverName' => receiverName,
                'receiverId' => payment.ReceiverId__c,
                'receiverUrl' => receiverUrl,
                'startDate' => payment.startDate__c,
                'endDate' => payment.endDate__c,
                'paidInvoices' => payment.Is_Paid_Invoices__c,
                'pendingInvoices' => payment.Is_Pending_invoices__c,
                'pendingInvoicesStartDate' => payment.Pending_invoices_startDate__c,
                'totalAmount' => totalAmount,
                'status' => payment.Status__c,
                'paymentDate' => payment.paymentDate__c,
                'lastUpdatedDate' => payment.Last_updated__c           
            });

            listPayments.add(paymentRecord);
        }

        return listPayments;
    } 

    private List<PaymentWrapper> getPaymentItems(String paymentId) {
        List<PaymentWrapper> listPaymentItems = new List<PaymentWrapper>();

        Map<String, Object> mapContracts = new Map<String, Object>();
        dao_Contract daoContract = new dao_Contract();
        List<Contract> listContracts = daoContract.findAll();
        for(Contract contract : listContracts) {
            mapContracts.put(contract.Id, contract.ContractNumber);
        }

        Map<String, Object> mapUsers = new Map<String, Object>();
        dao_User daoUser = new dao_User();
        List<User> listUsers = daoUser.getAll();
        for(User user : listUsers) {
            mapUsers.put(user.Id, user.Name);
        }

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> listContractResources = daoContractResource.findAll();
        Map<String,Object> mapContractResources = new Map<String,Object>();
        for(Contract_Resource__c contractResource : listContractResources){
            mapContractResources.put(contractResource.Id, contractResource);
        } 

        dao_PaymentsLineItem daoPaymentsLineItem = new dao_PaymentsLineItem();
        List<Payment_Line_Item__c> listPaymentLineItems =  daoPaymentsLineItem.findByPayment(paymentId);

        if(listPaymentLineItems.isEmpty()) {
            return listPaymentItems;
        }

        PaymentWrapper paymentRecord = null;

        for(Payment_Line_Item__c paymentLineItem : listPaymentLineItems) {
            String contractResourceId = paymentLineItem.Contract_Resource__c;
            Contract_Resource__c contractResource = (Contract_Resource__c) mapContractResources.get(contractResourceId);
            String contractId = contractResource.Contract__c;
            String employeeId = contractResource.Employee__c;

            paymentRecord = new PaymentWrapper(new Map<String, Object> {
                'contractId' => contractId,
                'contractNumber' => mapContracts.get(contractId),
                'contractUrl' => AppConfig.getContractUrl(contractId),
                'contractResourceId' => contractResourceId,
                'totalAmount' => paymentLineItem.Amount__c,
                'totalMinutes' => paymentLineItem.Minutes__c,
                'employeeId' => employeeId,
                'employeeName' => mapUsers.get(employeeId),
                'employeeUrl' => AppConfig.getUserUrl(employeeId),
                'rate' => paymentLineItem.Rate__c
            });

            listPaymentItems.add(paymentRecord);
        }

        return listPaymentItems;
    }

    private Decimal getExpensesReimbursement(String employeeId, Date startDate, Date endDate) {
        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> contractResources = daoContractResource.findAllByUser(employeeId);

        if(contractResources.isEmpty()) {
            return 0;
        }

        Set<String> contractResourcesIds = new Set<String>();

        for(Contract_Resource__c contractResource : contractResources) {
            contractResourcesIds.add(contractResource.Id);
        }

        Map<String, Object> conditions = new Map<String, Object> {
            'startDate' => startDate,
            'endDate' => endDate,
            'listContractResourcesIds' => contractResourcesIds,
            'isApproved' => true, 
            'isBillable' => true     
        };

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Decimal totalAmount = daoExpenseEntry.getAmount(conditions);

        return totalAmount;
    }

    private String getStatus(String status) {
       return chainStatuses.get(status);
    }

    private List<Map<String, Object>> filter(List<PaymentWrapper> payments, Integer limits, Integer offset) {
        List<Map<String,Object>> result = new List<Map<String,Object>>();

        if(offset == null) {
            offset = 0;
        }

        Integer paymentsSize = payments.size();

        if(limits == null || limits > paymentsSize) {
            limits = payments.size();
        }

        Integer countPayments = offset + limits;

        if(countPayments > paymentsSize) {
            countPayments = paymentsSize;
        }

        for(Integer i = offset; i < countPayments; i++) {
            result.add(((PaymentWrapper)payments.get(i)).payment);
        }

        return result;
    }

    private void generateNoDataFoundError(String message) {
        NoDataFoundException ex = new NoDataFoundException();
        ex.setMessage(message);
        throw ex; 
    }

    private void generateNoAccessError(String message) {
        NoAccessException ex = new NoAccessException();
        ex.setMessage(message);
        throw ex; 
    }

    private List<Invoice__c> getInvoices(Payment__c payment) {
        List<String> statuses = new List<String>();
        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByParams');

        request.Parameters.put('startDate', payment.StartDate__c);
        request.Parameters.put('endDate', payment.EndDate__c);

        if(payment.Is_Paid_Invoices__c == true) {
            statuses.add('Paid');//TODO: Extract to Config
        }

        if(payment.Is_Pending_invoices__c == true && payment.Pending_invoices_startDate__c != null) {
            statuses.add('Pending');
            request.Parameters.put('pendingInvoicesStartDate', payment.Pending_invoices_startDate__c);
        }

        request.Parameters.put('statuses', statuses);

        service_Response result = service_Controller.process(Services.Invoices, request);

        List<Invoice__c> invoices = new List<Invoice__c>();

        if(result.Errors.size() == 0) {
            invoices = (List<Invoice__c>)result.Parameters.get('list');
        }

        return invoices;
    }

    //TODO: MOVE TO SERVICE PRICEBOOK AND DAO
    private Decimal getEmployeeRate(String contractResourceId) {
        Decimal employeeRate = 0;

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c contractResource = daoContractResource.findOneById(contractResourceId);

        if(contractResource != null) {
            employeeRate = contractResource.Rate__c;
        }

        return employeeRate;
    }

    private Payment__c getPayment(String paymentId) {
        dao_Payments daoPayments = new dao_Payments();
        Payment__c payment = daoPayments.findOne(paymentId);

        if(payment == null) {
            generateNoDataFoundError('Payment ' + paymentId + ' no found'); 
        }

        return payment;
    }

    //TODO: add relation
    private List<Map<String, String>> getReceiversBySubcontractor() {
        List<Map<String, String>> receivers = new List<Map<String, String>>();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> contractResources = daoContractResource.findAllWithSubcontractor();

        Set<String> accountsIds = new Set<String>();

        for(Contract_Resource__c contractResource : contractResources) {
            accountsIds.add(contractResource.Subcontractor_Account__c);
        }

        dao_Account daoAccount = new dao_Account();
        List<Account> accounts = daoAccount.findAllByIds(accountsIds);

        for(Account account : accounts) {
            Map<String, String> receiver = new Map<String, String> {
                'id' => account.id,
                'name' => account.Name
            };
            receivers.add(receiver);
        }

        return receivers;
    }

    private List<Map<String, String>> getReceiversByReferral() {
        List<Map<String, String>> receivers = new List<Map<String, String>>();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> contracts = daoContract.getContractsWithReferral();

        Set<String> accountsIds = new Set<String>();

        for(Contract contract : contracts) {
            accountsIds.add(contract.Referred_By__c);
        }
        
        dao_Account daoAccount = new dao_Account();
        List<Account> accounts = daoAccount.findAllByIds(accountsIds);

        for(Account account : accounts) {
            Map<String, String> receiver = new Map<String, String> {
                'id' => account.id,
                'name' => account.Name
            };
            receivers.add(receiver);
        }

        return receivers;
    }

    private List<Map<String, String>> getReceiversByCommissions() {
        List<Map<String, String>> receivers = new List<Map<String, String>>();

        dao_Contract daoContract = new dao_Contract();
        List<Contract> contracts = daoContract.getContractsWithSalesperson();

        Set<String> usersIds = new Set<String>();

        for(Contract contract : contracts) {
            usersIds.add(contract.Salesperson__c);
        }

        dao_User daoUser = new dao_User();
        List<User> users = daoUser.findAllByIds(usersIds);

        for(User user : users) {
            Map<String, String> receiver = new Map<String, String> {
                'id' => user.id,
                'name' => user.Name
            };
            receivers.add(receiver);
        }

        return receivers;
    }

    private List<Map<String, String>> getReceiversByExpenses() {
        List<Map<String, String>> receivers = new List<Map<String, String>>();

        dao_User daoUser = new dao_User();
        List<User> users = daoUser.findAllWithExpenseEntries();

        for(User user : users) {
            Map<String, String> receiver = new Map<String, String> {
                'id' => user.id,
                'name' => user.Name
            };
            receivers.add(receiver);
        }

        return receivers;
    }

    private Map<String, Payment_Line_Item__c> processingPayment(Payment__c payment) {
        Set<String> timesheetsIds = new Set<String>();

        List<Invoice__c> invoices = getInvoices(payment);        

        for(Invoice__c invoice : invoices) {
            for(Invoice_Line_Item__c invoiceLineItem : invoice.Invoice_Line_Items__r) {
                timesheetsIds.add(invoiceLineItem.Timesheet__c);
            }
        }

        List<Timesheet_Entry__c> timesheetsEntries = new List<Timesheet_Entry__c>();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();

        switch on payment.Payment_type__c {
            when 'Subcontractor' {                    
                timesheetsEntries = daoTimesheetEntry.getTimesheetsEntriesBySubcontractor(timesheetsIds, payment.ReceiverId__c, payment.StartDate__c, payment.EndDate__c);
            }
            when 'Referral' {                    
                timesheetsEntries = daoTimesheetEntry.getTimesheetsEntriesByRefferal(timesheetsIds, payment.ReceiverId__c, payment.StartDate__c, payment.EndDate__c);
            }
            when 'Commissions' {                    
                timesheetsEntries = daoTimesheetEntry.getTimesheetsEntriesBySalesperson(timesheetsIds, payment.ReceiverId__c, payment.StartDate__c, payment.EndDate__c);
            }
        }

        Map<String, Payment_Line_Item__c> mapPaymentLineItems = new Map<String, Payment_Line_Item__c>();

        Map<String, Object> mapPayment = new Map<String, Object>{
            'item' => payment,
            'list' => mapPaymentLineItems
        };

        for(Timesheet_Entry__c timesheetEntry : timesheetsEntries) {
            Payment_Line_Item__c paymentLineItem = mapPaymentLineItems.get(timesheetEntry.Contract_Resource__c);
           
            if(paymentLineItem == null) {
                paymentLineItem = new Payment_Line_Item__c();

                Decimal employeeOnePercentRate = getEmployeeRate(timesheetEntry.Contract_Resource__c)/100;

                switch on payment.Payment_type__c {
                    when 'Subcontractor' {                    
                        paymentLineItem.Rate__c = timesheetEntry.Employee__r.Subcontractor_Rate__c != null ? timesheetEntry.Employee__r.Subcontractor_Rate__c : 0;                       
                    }
                    when 'Referral' {                    
                        paymentLineItem.Rate__c = timesheetEntry.Contract_Resource__r.Contract__r.Referral_Rate__c != null ? employeeOnePercentRate*timesheetEntry.Contract_Resource__r.Contract__r.Referral_Rate__c : 0;
                    }
                    when 'Commissions' {                    
                        paymentLineItem.Rate__c = timesheetEntry.Contract_Resource__r.Contract__r.Commission_Rate__c != null ? employeeOnePercentRate*timesheetEntry.Contract_Resource__r.Contract__r.Commission_Rate__c : 0;
                    }
                } 

                paymentLineItem.Contract_Resource__c = timesheetEntry.Contract_Resource__c;
                paymentLineItem.Payment__c = null;
                paymentLineItem.Minutes__c = 0;
                paymentLineItem.Amount__c = 0;

                mapPaymentLineItems.put(timesheetEntry.Contract_Resource__c, paymentLineItem);
            }

            payment.Total_Amount__c -= paymentLineItem.Amount__c;
            payment.Total_Minutes__c -= paymentLineItem.Minutes__c;

            paymentLineItem.Minutes__c = paymentLineItem.Minutes__c + timesheetEntry.Minutes__c;
            paymentLineItem.Amount__c = paymentLineItem.Rate__c * (paymentLineItem.Minutes__c/60).setScale(2);

            payment.Total_Amount__c += paymentLineItem.Amount__c;
            payment.Total_Minutes__c += paymentLineItem.Minutes__c;
        }
        
        if(payment.Payment_type__c == 'Expenses Reimbursement') {
            payment.Total_Amount__c = getExpensesReimbursement(payment.ReceiverId__c, payment.StartDate__c, payment.EndDate__c);
        }

        return mapPaymentLineItems;
    }

    private Boolean validType(String type) {
        Schema.DescribeFieldResult fieldResult = Payment__c.Payment_type__c.getDescribe();//TODO: move to Dao
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry pe : ple) {
            if(type == pe.getValue()) {
                return true;
            }
        }     

        return false;
    }

    private Boolean validReceiver(String paymentType, String receiverId) {
        switch on paymentType {
            when 'Subcontractor', 'Referral' {
                dao_Account daoAccount = new dao_Account();
                Account acc = daoAccount.findOne(receiverId);
                return (acc != null);
            }
            when 'Commissions', 'Expenses Reimbursement' {
                dao_User daoUser = new dao_User();
                User u = daoUser.findOne(receiverId);
                return (u != null);
            }
        }

        return false;
    }
}