/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class ExpensesController {
      public static Map<String, Object> getTypes() {
            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{},
                  'service' => Services.ExpenseEntry,
                  'action' => 'getTypes',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'list',                              
                              'type' => 'list',
                              'required' => true,
                              'apiName' => 'list',
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'params' => (new  Map<String, Object>())
            };

            Map<String, Object> response = new Map<String, Object>();

            service_Validation.proccessRequest(request, response);

            return response;
      }

      @AuraEnabled(cacheable=false)//TODO:refactor: replace timesheetId, paymentId, invoiceId on type and id
      public static  Map<String, Object> getList(List<String> contractsIds, Date startDate, Date endDate, String employeeId, String timesheetId, String invoiceId, String paymentId) {
            Map<String, Object> params = new Map<String, Object>{
                  'contractsIds' => contractsIds,
                  'startDate' => startDate,
                  'endDate' => endDate,
                  'employeeId' => employeeId,
                  'timesheetId' => timesheetId,
                  'invoiceId' => invoiceId,
                  'paymentId' => paymentId
            };

            List<Map<String, Object>> fieldsForContracts = new List<Map<String, Object>>{
                  new Map<String, Object>{
                        'name' => 'contractsIds',
                        'type' => 'list',
                        'required' => true,
                        'errors' => new Map<String, Object> {}
                  },
                  new Map<String, Object>{
                        'name' => 'startDate',
                        'type' => 'date',
                        'required' => true,
                        'errors' => new Map<String, Object> {}
                  },
                  new Map<String, Object>{
                        'name' => 'endDate',
                        'type' => 'date',
                        'required' => true,
                        'errors' => new Map<String, Object> {}
                  },
                  new Map<String, Object>{
                        'name' => 'rangDate',
                        'type' => 'date',
                        'operation' => '<',
                        'leftExpr' => 'startDate',
                        'rightExpr' => 'endDate',
                        'required' => true,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} should not be before the {1}'
                              }
                        }
                  },
                  new Map<String, Object>{
                        'name' => 'employeeId',
                        'type' => 'string',
                        'required' => true,
                        'excludeFor' => new List<String>{
                              'timesheetId', 'invoiceId'
                        },
                        'defaultValue' => UserInfo.getUserId(),
                        'errors' => new Map<String, Object> {}
                  }
            };

            List<Map<String, Object>> fieldsForTimesheet = new List<Map<String, Object>>{                 
                  new Map<String, Object>{
                        'name' => 'timesheetId',
                        'type' => 'string',
                        'required' => true,
                        'errors' => new Map<String, Object> {}
                  }
            };

            List<Map<String, Object>> fieldsForInvoice = new List<Map<String, Object>>{
                  new Map<String, Object>{
                        'name' => 'invoiceId',
                        'type' => 'string',
                        'required' => true,
                        'errors' => new Map<String, Object> {}
                  }
            };

            List<Map<String, Object>> fieldsForPayment = new List<Map<String, Object>>{
                  new Map<String, Object>{
                        'name' => 'paymentId',
                        'type' => 'string',
                        'required' => true,
                        'errors' => new Map<String, Object> {}
                  }
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => null,
                  'service' => Services.ExpenseEntry,
                  'action' => 'getList',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'list',                              
                              'type' => 'list',
                              'required' => true,
                              'apiName' => 'list',
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'params' => params
            };

            if(timesheetId != null) {
                  request.put('fields', fieldsForTimesheet); 
            } else if (invoiceId != null) {
                  request.put('fields', fieldsForInvoice); 
            } else if (paymentId != null) {
                  request.put('fields', fieldsForPayment); 
            }  else {  
                  request.put('fields', fieldsForContracts); 
            }

            Map<String, Object> response = new Map<String, Object>();

            service_Validation.proccessRequest(request, response);

            return response;
      }

      @AuraEnabled(cacheable=false)
      public static Map<String, Object> getAccounts(String status, String employeeId, String timesheetId) {
            Map<String, Object> params = new Map<String, Object>{
                  'status' => status,
                  'employeeId' => employeeId,
                  'timesheetId' => timesheetId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'status',
                              'type' => 'string',
                              'required' => false,
                              'defaultValue' => AppConfig.STATUS.get('active'),
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'employeeId',
                              'type' => 'string',
                              'required' => false,
                              'defaultValue' => UserInfo.getUserId(),                        
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'timesheetId',
                              'type' => 'string',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Account,
                  'action' => 'getList',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'list',                              
                              'type' => 'list',
                              'required' => true,
                              'apiName' => 'list',
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'params' => params
            };

            Map<String, Object> response = new Map<String, Object>();

            service_Validation.proccessRequest(request, response);

            return response;
      }

      @AuraEnabled(cacheable=false)
      public static Map<String, Object> getContracts(String accountId) {
            Map<String, Object> params = new Map<String, Object>{
                  'id' => accountId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'id',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Contract,
                  'action' => 'getListByAccount',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'list',                              
                              'type' => 'list',
                              'required' => true,
                              'apiName' => 'list',
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'params' => params
            };

            Map<String, Object> response = new Map<String, Object>();

            service_Validation.proccessRequest(request, response);

            return response;
      }

      @AuraEnabled(cacheable=false)
      public static Map<String, Object> updateEntries(List<Map<String, String>> expenseEntriesList) {    
            Map<String, Object> params = new Map<String, Object>{
                  'list' => expenseEntriesList
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'list',
                              'type' => 'list',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.ExpenseEntry,
                  'action' => 'updateEntries',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'list',                              
                              'type' => 'list',
                              'required' => true,
                              'apiName' => 'list',
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'params' => params
            };

            Map<String, Object> response = new Map<String, Object>();

            service_Validation.proccessRequest(request, response);

            return response;
      }

      @AuraEnabled(cacheable=false)
      public static  Map<String, Object> insertEntry(
            String contractId, 
            String description,
            Decimal amount, 
            Decimal invoicedAmount,
            Date expenseDate, 
            Date submittalDate,
            Boolean billable,
            String type, 
            String timesheetId, 
            String employeeId) {  
            Map<String, Object> params = new Map<String, Object>{
                  'contractId' => contractId,
                  'amount' => amount,
                  'invoicedAmount' => invoicedAmount,
                  'description' => description,
                  'expenseDate' => expenseDate,
                  'submittalDate' => submittalDate,
                  'billable' => billable,
                  'type' => type,
                  'timesheetId' => timesheetId,
                  'employeeId' => employeeId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'contractId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'amount',
                              'type' => 'decimal',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'invoicedAmount',
                              'type' => 'decimal',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'expenseDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'submittalDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'type',
                              'type' => 'string',
                              'required' => true,
                              'availableTypes' =>  new Set<Object> {
                                    'Airfare',
                                    'Rental Car',
                                    'Hotel Room',
                                    'Meal'
                              },
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'description',
                              'type' => 'string',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'billable',
                              'type' => 'boolean',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        },   
                        new Map<String, Object>{
                              'name' => 'timesheetId',
                              'type' => 'string',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        },    
                        new Map<String, Object>{
                              'name' => 'employeeId',
                              'type' => 'string',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        }                    
                  },
                  'service' => Services.ExpenseEntry,
                  'action' => 'insertEntry',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'item',                              
                              'type' => 'item',
                              'required' => true,
                              'apiName' => 'item',
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'params' => params
            };

            Map<String, Object> response = new Map<String, Object>();

            service_Validation.proccessRequest(request, response);

            return response;
      }

      @AuraEnabled(cacheable=false)
      public static  Map<String, Object> deleteEntry(String entryId) {  
            Map<String, Object> params = new Map<String, Object>{
                  'entryId' => entryId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'entryId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.ExpenseEntry,
                  'action' => 'deleteEntry',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'status',                              
                              'type' => 'string',
                              'required' => true,
                              'apiName' => 'status',
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'params' => params
            };

            Map<String, Object> response = new Map<String, Object>();

            service_Validation.proccessRequest(request, response);

            return response;
      }
}