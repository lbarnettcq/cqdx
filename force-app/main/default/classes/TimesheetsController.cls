/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class TimesheetsController {
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
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => ''
                                    }
                              }
                        }
                  },
                  'service' => Services.Timesheets,
                  'action' => 'getList',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'list',                              
                              'type' => 'list',
                              'required' => true,
                              'apiName' => 'list',
                              'errors' => new Map<String, Object> {}
                        }
                  }
            };
            request.put('params', params);
            Map<String, Object> response = new Map<String, Object>();
            
            service_Validation.proccessRequest(request, response);
            
            return response;
      }  

      @AuraEnabled(cacheable=false)
      public static Map<String, Object> getTotalCount() {
            Map<String, Object> params = new Map<String, Object>{};

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{},
                  'service' => Services.Timesheets,
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
      public static Map<String, Object> getInformation(String timesheetId) {
            Map<String, Object> params = new Map<String, Object>{
                  'timesheetId' => timesheetId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'timesheetId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        }
                  },
                  'service' => Services.Timesheets,
                  'action' => 'getInformation',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'item',                              
                              'type' => 'object',
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
      public static Map<String, Object> insertEntry(String userId, String contractId, Date startDate, Date endDate) {
            Map<String, Object> params = new Map<String, Object>{
                  'userId' => userId,
                  'contractId' => contractId,
                  'startDate' => startDate,
                  'endDate' => endDate
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                              'name' => 'userId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'contractId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'startDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'endDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
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
                        }
                  },
                  'service' => Services.Timesheets,
                  'action' => 'insertEntry',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'item',                              
                              'type' => 'object',
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
      public static Map<String, Object> updateEntry(String timesheetId, String userId, String contractId, Date startDate, Date endDate) {
            Map<String, Object> params = new Map<String, Object>{
                  'timesheetId' => timesheetId,
                  'userId' => userId,
                  'contractId' => contractId,
                  'startDate' => startDate,
                  'endDate' => endDate
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{                        
                        new Map<String, Object>{
                              'name' => 'timesheetId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'userId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'contractId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'startDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        },
                        new Map<String, Object>{
                              'name' => 'endDate',
                              'type' => 'date',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
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
                        }
                  },
                  'service' => Services.Timesheets,
                  'action' => 'updateEntry',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'item',                              
                              'type' => 'object',
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
      public static Map<String, Object> deleteEntry(String timesheetId) {
            Map<String, Object> params = new Map<String, Object>{
                  'timesheetId' => timesheetId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{                        
                        new Map<String, Object>{
                              'name' => 'timesheetId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        }                      
                  },
                  'service' => Services.Timesheets,
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
      public static Map<String, Object> updateStatus(String timesheetId) {
            Map<String, Object> params = new Map<String, Object>{
                  'timesheetId' => timesheetId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{                        
                        new Map<String, Object>{
                              'name' => 'timesheetId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        }                   
                  },
                  'service' => Services.Timesheets,
                  'action' => 'updateStatus',
                  'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{                              
                              'name' => 'item',                              
                              'type' => 'object',
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
      public static Map<String, Object> getContractsAndUsersListByAccount(String accountId) {
            Map<String, Object> params = new Map<String, Object>{
                  'accountId' => accountId
            };

            Map<String, Object> request = new Map<String, Object>{
                  'fields' => new List<Map<String, Object>>{                        
                        new Map<String, Object>{
                              'name' => 'accountId',
                              'type' => 'string',
                              'required' => true,
                              'errors' => new Map<String, Object> {
                                    'ValidationError' => new Map<String, String>{
                                          'message' => 'Parameter {0} is empty'
                                    }
                              }
                        }                      
                  },
                  'service' => Services.ContractResource,
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
}