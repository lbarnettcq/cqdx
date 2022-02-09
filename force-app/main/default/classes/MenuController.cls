/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class MenuController {
    @AuraEnabled(cacheable=false)
    public static Map<String, Object> getAccounts(String status, Date startDate, Date endDate, String employeeId) {
      Map<String, Object> params = new Map<String, Object>{
            'status' => status,
            'startDate' => startDate,
            'endDate' => endDate,
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
                        'defaultValue' => UserInfo.getUserId(),
                        'errors' => new Map<String, Object> {}
                  },
                  new Map<String, Object>{
                        'name' => 'startDate',
                        'type' => 'date',
                        'required' => false,
                        'errors' => new Map<String, Object> {}
                  },
                  new Map<String, Object>{
                        'name' => 'endDate',
                        'type' => 'date',
                        'required' => false,
                        'errors' => new Map<String, Object> {}
                  },
                  new Map<String, Object>{
                        'name' => 'rangDate',
                        'type' => 'date',
                        'operation' => '<',
                        'leftExpr' => 'startDate',
                        'rightExpr' => 'endDate',
                        'required' => false,
                        'errors' => new Map<String, Object> {
                              'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} should not be before the {1}'
                              }
                        }
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
    public static Map<String, Object> getContractResource(String contractId, String employeeId) {    
      Map<String, Object> params = new Map<String, Object>{
            'contractId' => contractId,
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
                        'name' => 'employeeId',
                        'type' => 'string',
                        'required' => false,
                        'defaultValue' => UserInfo.getUserId(),
                        'errors' => new Map<String, Object> {}
                  }
            },
            'service' => Services.ContractResource,
            'action' => 'getId',
            'response' => new List<Map<String, Object>>{
                  new Map<String, Object>{                              
                        'name' => 'id',                              
                        'type' => 'string',
                        'required' => true,
                        'apiName' => 'id',
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