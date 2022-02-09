/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class TimeTrackingController {
    @AuraEnabled(cacheable=false)
    public static Map<String, Object> getProducts() {  
      Map<String, Object> params = new Map<String, Object>();

      Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>(),
            'service' => Services.Products,
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
    public static Map<String, Object> getList(List<String> contractIds, List<String> userIds, Date startDate, Date endDate, Boolean previousWeek) {
      Map<String, Object> params = new Map<String, Object>{
            'contractIds' => contractIds,
            'userIds' => userIds,
            'startDate' => startDate,
            'endDate' => endDate,
            'previousWeek' => previousWeek
      };

      Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
                  new Map<String, Object>{
                        'name' => 'contractIds',
                        'type' => 'list',
                        'required' => false,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  },
                  new Map<String, Object>{
                        'name' => 'userIds',
                        'type' => 'list',
                        'required' => false,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  },
                  new Map<String, Object>{
                        'name' => 'list',
                        'type' => 'list',
                        'operation' => '||',
                        'leftExpr' => 'contractIds',
                        'rightExpr' => 'userIds',
                        'required' => true,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} should not be before the {1}'
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
                  },
                  new Map<String, Object>{
                        'name' => 'previousWeek',
                        'type' => 'boolean',
                        'required' => false,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  }
            },
            'service' => Services.TimesheetEntry,
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
    public static  Map<String, Object> insertEntry(String contractId, String productId, String createdDate, String minutes, String userId) {
      Map<String, Object> params = new Map<String, Object>{
            'contractId' => contractId,
            'productId' => productId,
            'createdDate' => createdDate,
            'minutes' => minutes,
            'employeeId' => userId
      };

      Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
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
                        'name' => 'productId',
                        'type' => 'string',
                        'required' => true,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  },
                  new Map<String, Object>{
                        'name' => 'createdDate',
                        'type' => 'date',
                        'required' => true,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  },
                  new Map<String, Object>{
                        'name' => 'minutes',
                        'type' => 'string',
                        'required' => false,
                        'defaultValue' => 0,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  },
                  new Map<String, Object>{
                        'name' => 'employeeId',
                        'type' => 'string',
                        'required' => false,
                        'defaultValue' => UserInfo.getUserId(),
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  }
            },
            'service' => Services.TimesheetEntry,
            'action' => 'insertEntry',
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
    public static Map<String, Object> insertEntries(String contractId, List<Map<String, Object>> listEntries, String userId) {
      Map<String, Object> params = new Map<String, Object>{
            'contractId' => contractId,
            'list' => listEntries,
            'employeeId' => userId
      };

      Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
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
                        'name' => 'list',
                        'type' => 'list',
                        'required' => true,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  },
                  new Map<String, Object>{
                        'name' => 'employeeId',
                        'type' => 'string',
                        'required' => false,
                        'defaultValue' => UserInfo.getUserId(),
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  }
            },
            'service' => Services.TimesheetEntry,
            'action' => 'insert',
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
    public static Map<String, Object> updateEntry(String timesheetEntryId, String minutes) {
      Map<String, Object> params = new Map<String, Object> {
            'timesheetEntryId' => timesheetEntryId,
            'minutes' => minutes
      };

      Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
                  new Map<String, Object>{
                        'name' => 'timesheetEntryId',
                        'type' => 'string',
                        'required' => true,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  },
                  new Map<String, Object>{
                        'name' => 'minutes',
                        'type' => 'string',
                        'required' => false,
                        'defaultValue' => 0,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  }
            },
            'service' => Services.TimesheetEntry,
            'action' => 'updateEntry',
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
    public static Map<String, Object> updateEntries(List<Map<String, Object>> listEntries) {
      Map<String, Object> params = new Map<String, Object> {
            'list' => listEntries
      };

      Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
                  new Map<String, Object>{
                        'name' => 'list',
                        'type' => 'list',
                        'required' => true,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  }
            },
            'service' => Services.TimesheetEntry,
            'action' => 'update',
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
    public static Map<String, Object> deleteEntry(String timesheetEntryId) {
      Map<String, Object> params = new Map<String, Object> {
            'timesheetEntryId' => timesheetEntryId
      };

      Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
                  new Map<String, Object>{
                        'name' => 'timesheetEntryId',
                        'type' => 'string',
                        'required' => true,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} is empty'
                              }
                        }
                  }
            },
            'service' => Services.TimesheetEntry,
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
    public static Map<String, Object> getContractsAndUsersListByAccount(String accountId) {
      Map<String, Object> params = new Map<String, Object> {
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