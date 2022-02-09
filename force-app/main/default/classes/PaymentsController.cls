/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class PaymentsController {
      @AuraEnabled
      public static Map<String, Object> getTypes() {
            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{},
                  'service' => Services.Payments,
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
                  'params' => (new Map<String, Object>())
            };

            Map<String, Object> response = new Map<String, Object>();

            service_Validation.proccessRequest(request, response);

            return response;
      }

      @AuraEnabled
      public static Map<String, Object> getReceivers(String paymentType) {
            Map<String, Object> params = new Map<String, Object>{
                  'paymentType' => paymentType
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'paymentType',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Payments,
                  'action' => 'getReceivers',
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
                  'service' => Services.Payments,
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
                  'service' => Services.Payments,
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
      public static Map<String, Object> getListItems(String paymentId) {
            Map<String, Object> params = new Map<String, Object>{
                  'paymentId' => paymentId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'paymentId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Payments,
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
      public static Map<String, Object> getTotalItemsCount(String paymentId) {
            Map<String, Object> params = new Map<String, Object>{
                  'paymentId' => paymentId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'paymentId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Payments,
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
      public static Map<String, Object> getInformation(String paymentId) {
            Map<String, Object> params = new Map<String, Object>{
                  'paymentId' => paymentId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'paymentId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Payments,
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
      public static Map<String, Object> insertEntry(String paymentType, String receiverId, Date startDate,
                                                    Date endDate, Boolean paidInvoices,
                                                    Boolean pendingInvoices, Date pendingInvoicesStartDate) {

            Map<String, Object> params = new Map<String, Object>{
                  'paymentType' => paymentType,
                  'receiverId' => receiverId,
                  'startDate' => startDate,
                  'endDate' => endDate,
                  'paidInvoices' => paidInvoices,
                  'pendingInvoices' => pendingInvoices,
                  'pendingInvoicesStartDate' => pendingInvoicesStartDate
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'paymentType',
                              'type' => 'string',
                              'required' => true,
                              'availableTypes' =>  new Set<Object> {
                                    'Subcontractor',
                                    'Referral',
                                    'Commissions',
                                    'Expenses Reimbursement'
                              },
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'receiverId',
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
                              'name' => 'paidInvoices',
                              'type' => 'boolean',
                              'required' => false,
                              'defaultValue' => 'false',
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'pendingInvoices',
                              'type' => 'boolean',
                              'required' => false,
                              'defaultValue' => 'false',
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'checked',
                              'type' => 'boolean',
                              'operation' => '||',
                              'leftExpr' => 'paidInvoices',
                              'rightExpr' => 'pendingInvoices',
                              'required' => (paymentType != 'Expenses Reimbursement') ? true : false,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Please check the box to create a payment'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'pendingInvoicesStartDate',
                              'type' => 'date',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'rangDate',
                              'type' => 'date',
                              'operation' => '<=',
                              'leftExpr' => 'endDate',
                              'rightExpr' => 'pendingInvoicesStartDate',
                              'required' => false,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} should not be before the {1}'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'rangDate',
                              'type' => 'date',
                              'operation' => '>=',
                              'leftExpr' => 'startDate',
                              'rightExpr' => 'pendingInvoicesStartDate',
                              'required' => false,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} should not be before the {1}'
                                    }
                              }
                        }
                  },
                  'service' => Services.Payments,
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

      @AuraEnabled(cacheable=false)//TODO: require onlye field: paymentId;
      public static Map<String, Object> updateEntry(String paymentId, String paymentType, String receiverId,
                                                    Date startDate, Date endDate, Boolean paidInvoices,
                                                    Boolean pendingInvoices, Date pendingInvoicesStartDate) {

            Map<String, Object> params = new Map<String, Object>{
                  'paymentId' => paymentId,
                  'paymentType' => paymentType,
                  'receiverId' => receiverId,
                  'startDate' => startDate,
                  'endDate' => endDate,
                  'paidInvoices' => paidInvoices,
                  'pendingInvoices' => pendingInvoices,
                  'pendingInvoicesStartDate' => pendingInvoicesStartDate
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'paymentType',
                              'type' => 'string',
                              'required' => true,
                              'availableTypes' =>  new Set<Object> {
                                    'Subcontractor',
                                    'Referral',
                                    'Commissions',
                                    'Expenses Reimbursement'
                              },
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'paymentId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'receiverId',
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
                              'name' => 'paidInvoices',
                              'type' => 'boolean',
                              'required' => false,
                              'defaultValue' => 'false',
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'pendingInvoices',
                              'type' => 'boolean',
                              'required' => false,
                              'defaultValue' => 'false',
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'checked',
                              'type' => 'boolean',
                              'operation' => '||',
                              'leftExpr' => 'paidInvoices',
                              'rightExpr' => 'pendingInvoices',
                              'required' => (paymentType != 'Expenses Reimbursement') ? true : false,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Please check the box to create a payment'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'pendingInvoicesStartDate',
                              'type' => 'date',
                              'required' => false,
                              'errors' => new Map<String, Object> {}
                        },
                        new Map<String, Object>{
                              'name' => 'rangDate',
                              'type' => 'date',
                              'operation' => '<=',
                              'leftExpr' => 'endDate',
                              'rightExpr' => 'pendingInvoicesStartDate',
                              'required' => false,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} should not be before the {1}'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'rangDate',
                              'type' => 'date',
                              'operation' => '>=',
                              'leftExpr' => 'startDate',
                              'rightExpr' => 'pendingInvoicesStartDate',
                              'required' => false,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} should not be before the {1}'
                                    }
                              }
                        }
                  },
                  'service' => Services.Payments,
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
      public static Map<String, Object> deleteEntry(String paymentId) {
            Map<String, Object> params = new Map<String, Object>{
                  'paymentId' => paymentId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'paymentId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Payments,
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
      public static Map<String, Object> updateStatus(String paymentId, Date paymentDate) {
            Map<String, Object> params = new Map<String, Object>{
                  'paymentId' => paymentId,
                  'paymentDate' => paymentDate
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'paymentId',
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
                  'service' => Services.Payments,
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
      public static Map<String, Object> availableEntity(String paymentId) {
            Map<String, Object> params = new Map<String, Object>{
                  'paymentId' => paymentId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'paymentId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {}
                        }
                  },
                  'service' => Services.Payments,
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