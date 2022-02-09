/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class InvoicesController {
      @AuraEnabled(cacheable=false)
      public static Map<String, Object> getAccounts(String status, String employeeId) {
             Map<String, Object> params = new Map<String, Object>{
                  'status' => status,
                  'employeeId' => employeeId
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
      public static Map<String, Object> getList(Integer limits, Integer offset) {
            Map<String, Object> params = new Map<String, Object>{
                  'limits' => limits,
                  'offset' => offset
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'limits',
                              'type' => 'integer',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'offset',
                              'type' => 'integer',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Invoices,
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
      public static Map<String, Object> getTotalCount() {
            Map<String, Object> params = new Map<String, Object>{};

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{},
                  'service' => Services.Invoices,
                  'action' => 'getTotalCount',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'count',                              
                              'type' => 'integer',
                              'required' => true,
                              'apiName' => 'count',
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
      public static Map<String, Object> getListItems(String invoiceId) {
            Map<String, Object> params = new Map<String, Object>{
                  'invoiceId' => invoiceId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'invoiceId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Invoices,
                  'action' => 'getListItems',
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
      public static Map<String, Object> getTotalItemsCount(String invoiceId) {
            Map<String, Object> params = new Map<String, Object>{
                  'invoiceId' => invoiceId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'invoiceId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Invoices,
                  'action' => 'getTotalItemsCount',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'count',                              
                              'type' => 'count',
                              'required' => true,
                              'apiName' => 'count',
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
      public static Map<String, Object> getInformation(String invoiceId) {
            Map<String, Object> params = new Map<String, Object>{
                  'invoiceId' => invoiceId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'invoiceId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Invoices,
                  'action' => 'getInformation',
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
      public static Map<String, Object> insertEntry(String accountId, Date startDate, Date endDate, Date issueDate , Date dueDate) {  
            Map<String, Object> params = new Map<String, Object>{
                  'accountId' => accountId,
                  'startDate' => startDate,
                  'endDate' => endDate,
                  'issueDate' => issueDate,
                  'dueDate' => dueDate
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'accountId',
                              'type' => 'string',
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
                              'name' => 'issueDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'dueDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'rangDate',
                              'type' => 'date',
                              'operation' => '<',
                              'leftExpr' => 'endDate',
                              'rightExpr' => 'issueDate',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} should not be before the {1}'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'rangDate',
                              'type' => 'date',
                              'operation' => '<',
                              'leftExpr' => 'issueDate',
                              'rightExpr' => 'dueDate',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} should not be before the {1}'
                                    }
                              }
                        }
                  },
                  'service' => Services.Invoices,
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

      @AuraEnabled(cacheable=false)//TODO: extract params to object
      public static Map<String, Object> updateEntry(String invoiceId, String accountId, Date startDate, Date endDate, Date issueDate , Date dueDate) {  
            Map<String, Object> params = new Map<String, Object>{
                  'invoiceId' => invoiceId,
                  'accountId' => accountId,
                  'startDate' => startDate,
                  'endDate' => endDate,
                  'issueDate' => issueDate,
                  'dueDate' => dueDate
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'invoiceId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                       new Map<String, Object>{
                              'name' => 'accountId',
                              'type' => 'string',
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
                              'name' => 'issueDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'dueDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'rangDate',
                              'type' => 'date',
                              'operation' => '<',
                              'leftExpr' => 'endDate',
                              'rightExpr' => 'issueDate',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} should not be before the {1}'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'rangDate',
                              'type' => 'date',
                              'operation' => '<',
                              'leftExpr' => 'issueDate',
                              'rightExpr' => 'dueDate',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} should not be before the {1}'
                                    }
                              }
                        }
                  },
                  'service' => Services.Invoices,
                  'action' => 'updateEntry',
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
      public static Map<String, Object> deleteEntry(String invoiceId) {
            Map<String, Object> params = new Map<String, Object>{
                  'invoiceId' => invoiceId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'invoiceId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Invoices,
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

      @AuraEnabled(cacheable=false)
      public static Map<String, Object> updateStatus(String invoiceId, Date paymentDate) {
            Map<String, Object> params = new Map<String, Object>{
                  'invoiceId' => invoiceId,
                  'paymentDate' => paymentDate
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'invoiceId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'paymentDate',
                              'type' => 'date',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Invoices,
                  'action' => 'updateStatus',
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

      @AuraEnabled(cacheable=false)
      public static Map<String, Object> availableEntity(String invoiceId) {
            Map<String, Object> params = new Map<String, Object>{
                  'invoiceId' => invoiceId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'invoiceId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Invoices,
                  'action' => 'availableEntity',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'status',                              
                              'type' => 'string',
                              'required' => true,
                              'apiName' => 'status',
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{                              
                              'name' => 'message',                              
                              'type' => 'string',
                              'required' => true,
                              'apiName' => 'message',
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