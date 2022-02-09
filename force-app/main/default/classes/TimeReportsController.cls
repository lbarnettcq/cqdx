/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class TimeReportsController {
    @AuraEnabled(cacheable=false)
    public static Map<String, Object> getList(Integer limits, Integer offset, String timesheetId) {
        Map<String, Object> params = new Map<String, Object>{
            'limits' => limits,
            'offset' => offset,
            'timesheetId' => timesheetId
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
                    },
                    new Map<String, Object>{
                        'name' => 'timesheetId',
                        'type' => 'string',
                        'required' => false,
                        'errors' => new Map<String, Object> {}
                    }
            },
            'service' => Services.TimeReports,
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
    public static Map<String, Object> getReport(String employeeId, Date startDate, Date endDate , String status, String timesheetId) {
        Map<String, Object> params = new Map<String, Object>{
            'employeeId' => employeeId,
            'startDate' => startDate,
            'endDate' => endDate,
            'status' => status,
            'timesheetId' => timesheetId
        };

        Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'name' => 'employeeId',
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
                        'required' => false,
                        'errors' => new Map<String, Object> {
                                'ValidationError' => new Map<String, String>{
                                    'message' => 'Parameter {0} should not be before the {1}'
                                }
                        }
                    },
                    new Map<String, Object>{
                        'name' => 'status',
                        'type' => 'string',
                        'required' => true,
                        'errors' => new Map<String, Object> {}
                    },
                    new Map<String, Object>{
                        'name' => 'timesheetId',
                        'type' => 'string',
                        'required' => false,
                        'errors' => new Map<String, Object> {}
                    }
            },
            'service' => Services.TimeReports,
            'action' => 'findByReport',
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
    public static Map<String, Object> getTotalCount(String timesheetId) {
        Map<String, Object> params = new Map<String, Object>{
            'timesheetId' => timesheetId
        };

        Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
                new Map<String, Object>{
                    'name' => 'timesheetId',
                    'type' => 'string',
                    'required' => false,
                    'errors' => new Map<String, Object> {}
                }
            },
            'service' => Services.TimeReports,
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
    public static Map<String, Object> setMultipleStatus(List<Date> dateList, String employeeId, Boolean status , String timesheetId) {
        Map<String, Object> params = new Map<String, Object>{
            'dateList' => dateList,
            'employeeId' => employeeId,
            'status' => status,
            'timesheetId' => timesheetId
        };

        Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
                new Map<String, Object>{
                    'name' => 'dateList',
                    'type' => 'list',
                    'required' => true,
                    'errors' => new Map<String, Object> {}
                },
                new Map<String, Object>{
                    'name' => 'employeeId',
                    'type' => 'string',
                    'required' => true,
                    'errors' => new Map<String, Object> {}
                },
                new Map<String, Object>{
                    'name' => 'status',
                    'type' => 'boolean',
                    'required' => true,
                    'errors' => new Map<String, Object> {}
                },
                new Map<String, Object>{
                    'name' => 'timesheetId',
                    'type' => 'string',
                    'required' => false,
                    'errors' => new Map<String, Object> {}
                }
            },
            'service' => Services.TimeReports,
            'action' => 'updateMultipleStatus',
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

    //TODO: review result and name method
    @AuraEnabled(cacheable=false)
    public static  Map<String, Object> getUser(String userId) {
        Map<String, Object> params = new Map<String, Object>{
            'userId' => userId
        };

        Map<String, Object> request = new Map<String, Object>{
            'fields' => new List<Map<String, Object>>{
                new Map<String, Object>{
                    'name' => 'userId',
                    'type' => 'string',
                    'required' => true,
                    'errors' => new Map<String, Object> {}
                }
            },
            'service' => Services.User,
            'action' => 'getUserById',
            'response' => new List<Map<String, Object>>{
                    new Map<String, Object>{                              
                        'name' => 'user',                              
                        'type' => 'string',
                        'required' => true,
                        'apiName' => 'user',
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