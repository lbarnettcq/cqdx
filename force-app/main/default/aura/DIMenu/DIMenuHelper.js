({
    id: 'diMenu',
    sfx: 'SOW ',
    contractIds: [],
    limit: {
      numberVisibleSows: 2
    },
    removeOutsideClickListener: null,
    childsData: [],
    startInit: false,
    processingProcess: function(component, currentState) {
      let process = {
          'scriptsLoaded': 'init',
          'init': 'scriptsLoaded'
      };

      let previousState = this.getView(component, 'stateProcess');

      console.log('DEBUG:DIDatePicker:Helper:processingProcess:', currentState, previousState, process[currentState]);

      if(process[currentState] == previousState) {
          this.setView(component, 'stateProcess', 'ready');
          this.init(component);
      } else {
          this.setView(component, 'stateProcess', currentState);
      }
    },
    init: function(component) {
      console.log('DEBUG:DIMenu:Helper:init:START:BEFORE');
      if(this.canLoad(component)) {
        console.log('DEBUG:DIMenu:Helper:init:START:LOAD');
        this.startInit = true;
        this.load(component);
      } else {
        console.log('DEBUG:DIMenu:Helper:init:START:INIT');
        this.notify(component, 'init');
      }      
    },
    load: function(component) {
      console.log('DEBUG:DIMenu:Helper:load:');
      if(this.canLoad(component)) {
        this.close(component);    
        this.initData(component);
        this.getList(component);
      }
    },
    initData: function(component) {
      this.contractIds = [];
      this.setView(component, 'selectedSows', 'Add SOW');
    },
    hideOnClickDiListOutside: function(component) {
      console.log('DEBUG:DIMenu:Helper:hideOnClickDiListOutside:', this.getView(component, 'state'));

      const outsideDiListClickListener = event => {
        let element = document.getElementById('diList');

        if (!element.contains(event.target)) { 
          console.log('DEBUG:DIMenu:Helper:hideOnClickDiListOutside:CLICK', this.getView(component, 'state'));
          if (this.isOpen(component)) {
            this.close(component);
          } else {
            console.log('DEBUG:DIMenu:Helper: handle not visible');
          }
        }
      }
  
      this.removeOutsideClickListener = () => {
        console.log('DEBUG:DIMenu:Helper:removeOutsideClickListener:', this.getView(component, 'state'));
        document.removeEventListener('click', outsideDiListClickListener)
      }
      
      document.addEventListener('click', outsideDiListClickListener);
    },
    toogle: function(component) {
      console.log('DEBUG:DIMenu:Helper:toogle:', this.getView(component, 'state'));
      if(this.getView(component, 'state') === 'opened') {
        this.close(component);
      } else {
        this.open(component);
      }
    },
    open: function(component) {
      console.log('DEBUG:DIMenu:Helper:open:', this.getView(component, 'state'));

      this.setView(component, 'state', 'opened');
      this.setView(component, 'classState', 'slds-is-open');

      if(!this.removeOutsideClickListener) {
        this.hideOnClickDiListOutside(component);
      }
    },
    close: function(component) {
      console.log('DEBUG:DIMenu:Helper:close:', this.getView(component, 'state'), typeof(this.removeOutsideClickListener));

      if(typeof(this.removeOutsideClickListener) === 'function') {
        this.removeOutsideClickListener();
        this.removeOutsideClickListener = null;
      }

      this.setView(component, 'state', 'closed');
      this.setView(component, 'classState', '');
    },
    isOpen: function(component) {
      return (this.getView(component, 'state') === 'opened');
    },
    getList: function(component) {
      console.log('DEBUG:DIMenu:Helper:List:Get:', this.data);
      this.api.list.get(component, this);
    },
    createList: function(component, list) {
      if(Array.isArray(list)) {
          let items = [];

          this.contractIds = [];

          for(let i = 0; i < list.length; i++) {
            let account = list[i];

            console.log('DEBUG:DIMenu:Helper:Api:List:createList:before', account.contracts);

            if(Array.isArray(account.contracts) && (account.contracts.length > 0)) {
              let parent = {
                id: account['id'], 
                name: account['name'], 
                label: account['name'], 
                childs: []
              };

              account.contracts.forEach((contract) => {
                let child = {
                  id: contract['id'], 
                  name: contract['contractNumber'], 
                  label: this.sfx + contract['contractNumber'],
                  parentId: account['id'], 
                  resourceId: null,
                  active: false, 
                  classState: ''
                };

                if(contract['status'] == 'active') {
                  child['active'] = true;
                  child['classState'] = 'slds-is-selected';

                  this.contractIds.push(child.id);
                }

                parent.childs.push(child)
              });

              /*if(first) {
                this.client.id = parent['id'];
                this.client.label = parent['label'];                
                this.sow.id = parent.childs[0]['id'];
                this.sow.label = parent.childs[0]['label'];
                this.sow.parentId = parent.childs[0]['parentId'];
                parent.childs[0].active = true;
                parent.childs[0].classState = 'slds-is-selected';

                first = false;
              }*/

              items.push(parent);
            }
          }

          console.log('DEBUG:DIMenu:Helper:Api:List:createList:items', items);

          this.setView(component, 'list', items);

          let state = 'change';

          if(this.startInit) {
            this.startInit = false;
            state = 'init';
          }

          this.getResource(component, state);
          console.log('DEBUG:DIMenu:Helper:Api:List:createList', this.data, state);
      }
    },
     api: {
      list: {
          get: function(component, ctx) {
              console.log('DEBUG:DI:Menu:Helper:Api:List:Get', ctx.data);

              let params = {status: 'Activated'};

              let dateRange = ctx.getDate(component);

              if(dateRange.startDate && dateRange.endDate) {
                params['startDate'] = dateRange.startDate;
                params['endDate'] = dateRange.endDate;
              }

              let action = component.get('c.getAccounts');

              action.setParams(params);

              action.setCallback(ctx, function(a) {
                  console.log('DEBUG:DIMenu:Helper:Api:List:Get:Response:');
                  let state = a.getState();
                  if(state == 'SUCCESS') {
                      let list = a.getReturnValue();

                      if(distdlib.isObject(list['data']) && Array.isArray(list['data']['list'])) {       
                          console.log('DEBUG:DIMenu:Helper:Api:List:Get:Response:SUCCESS', list['data']['list']);   
                          ctx.createList(component, list['data']['list']);   
                      } else {
                          console.log('DEBUG:DIMenu:Helper:Api:List:Get:Response:SUCCESS', 'List hasn\'t array schema');
                      }                       
                  }
              });
              $A.enqueueAction(action);
          }
      }
  },
  notify: function(component, state, data) {
    let params = {id: this.id, dependencies: this.getArrayDependencies(component)};

    if(!state) {
      state = 'init'
    }

    params['state'] = state;

    if(distdlib.isObject(data)) {
      let date = this.getDate(component);

      if(date.startDate && date.endDate) {
        data['startDate'] = date.startDate;
        data['endDate'] = date.endDate;
      }

      params['data'] = data;
    }

    console.log('DEBUG:EVENT:CHAINS:Menu', params);
    let changeEvent = component.getEvent('changeEvent');
    changeEvent.setParams({data: params});
    changeEvent.fire();
  },
  getSow: function(clientId, sowId) {
    for(let i = 0; i < this.list.data.length; i++) {
      let parent = this.list.data[i];
      let childs = parent['childs'];

      if(Array.isArray(childs)) {
        for(let j = 0; j < childs.length; j++) {
          let child = childs[j];
  
          if(child['id'] === sowId && child['parentId'] === clientId) {
            return child;
          }
        }
      }
    }

    return null;
  },
  updateList: function(component, clientId, sowId) {
    console.log('DEBUG:DIMenu:Helper:updateList:init', clientId, sowId);
    this.contractIds = [];
    let selectedSows = [];
    let countSelectedSowsLabel = 0;
    
    let list = this.getView(component, 'list');

    for(let i = 0; i < list.length; i++) {
      let parent = list[i];
      let childs = parent['childs'];

      if(Array.isArray(childs)) {
        for(let j = 0; j < childs.length; j++) {
          let child = childs[j];
  
          if(child['id'] === sowId && child['parentId'] === clientId) {
            if(child['active']) {
              child['active'] = false;
              child['classState'] = '';
            } else {
              child['active'] = true;
              child['classState'] = 'slds-is-selected';
            }          
          }

          if(child['active']) {
            if(countSelectedSowsLabel < this.limit.numberVisibleSows) {              
              selectedSows.push(child['label']);
              countSelectedSowsLabel++;
            } else {
              selectedSows[this.limit.numberVisibleSows] = '...';
            }
            this.contractIds.push(child.id);
          }
        }
      }
    }

    console.log('DEBUG:DIMenu:Helper:updateList:List', list);

    /*if(selectedSows.length > 0) {
      this.setView(component, 'selectedSows', selectedSows.join(', '));
    } else {
      this.setView(component, 'selectedSows', 'Add SOW');
    }*/

    this.setView(component, 'list', list);

    this.close(component);

    this.getResource(component, 'change');    
  },
  getResource: function(component, state) {
    console.log('DEBUG:DIMenu:Helper:getResource:contractIds: ', this.contractIds);

    let items = this.getView(component, 'list');

    let ids = [];

    items.forEach((item) => {
      if(Array.isArray(item.childs)) {
        item.childs.forEach((child) => {
            ids.push(child.id);
        });
      }
    });

    console.log('DEBUG:DIMenu:Helper:getResource:contractIds:ids:', this.contractIds, ids);

    let data = {contractIds: this.contractIds, list: ids};

    let dateRange = this.getDate(component);
    if(dateRange.startDate && dateRange.endDate) {
      data['startDate'] = dateRange.startDate;
      data['endDate'] = dateRange.endDate;
    }

    this.notify(component, state, data);
  },
  sendRequest: function(cmp, methodName, params) {
      return new Promise($A.getCallback(function(resolve, reject) {
          let action = cmp.get(methodName);
          action.setParams(params);
          action.setCallback(self, function(res) {
            var state = res.getState();
            if(state === 'SUCCESS') {
              resolve(res.getReturnValue());
            } else if(state === 'ERROR') {
              console.error('DEBUG:DIMenu:Helper:getResource: ERROR: sendRequest', action.getError());
              reject(action.getError())
            }
          });
          $A.enqueueAction(action);
      }));
  },
  setView: function(component, view, value) {
    return component.set('v.' + view, value);
  },
  getView: function(component, field) {
    return component.get('v.' + field);
  },
  getArrayDependencies: function(component) {        
    let dependencies = this.getView(component, 'dependencies');

    console.log('DEBUG:DIMenu:Helper:init:dependencies:', dependencies);

    if(dependencies && Array.isArray(dependencies)) {
        console.log('DEBUG:DIMenu:Helper:init:dependencies:array:', dependencies);
        return dependencies;
    }

    return [];
  },
  update: function (component, data) {
    this.childsData.push(data);

    if(this.isReady(component)) {
        this.childsData.forEach(data => {
            if(distdlib.isObject(data)) {
                switch(data.id) {
                    case 'diMenu': 
                        console.log('DEBUG:Menu:Helper:Update:Params:diTable', data.id,  data.state, data.data['diDatePicker']); 
    
                        if(distdlib.isObject(data.data)) {
                            if(data.data['diDatePicker'] && data.data['diDatePicker']['data']) {                           
                                let datePickerData = data.data['diDatePicker']['data'];
                               
                                console.log('DEBUG:Menu:Helper:Update:Params:diTable:diDatePicker', datePickerData.startDate, datePickerData.endDate);
                                let date = {
                                    startDate: distdlib.date.addZero(this.createDate(datePickerData.startDate)),
                                    endDate: distdlib.date.addZero(this.createDate(datePickerData.endDate))
                                };
                                this.setDate(component, date);                                                      
                            }
                        }
    
                        this.load(component);                   
                        break;
                    case 'diDatePicker':
                        console.log('DEBUG:Menu:Helper:Update:Params:diDatePicker', data.id,  data.state,  data.data.startDate, data.data.endDate);      
                        let date = {
                            startDate: distdlib.date.addZero(this.createDate(data.data.startDate)),
                            endDate: distdlib.date.addZero(this.createDate(data.data.endDate)),
                        };                        
                        this.setDate(component, date);
                        this.load(component);  
                        break;
                    default: {
                        console.log('DEBUG:Menu:Helper:Update:Params:default', data.action, data.data.startDate, data.data.endDate, data.data.userId);      
                        switch(data.action) {
                            case 'load':
                                if(typeof data.data.startDate != 'undefined' && typeof data.data.endDate != 'undefined') {
                                  let date = {
                                      startDate: distdlib.date.addZero(this.createDate(data.data.startDate)),
                                      endDate: distdlib.date.addZero(this.createDate(data.data.endDate))
                                  };
                                  this.setDate(component, date); 
                                }                                                           
                                this.load(component);
                                break;
                        }
                    }
                }
            }
        }); 

        this.childsData.length = 0;
    }
  },
  setDate: function(component, date) {
    this.setView(component, 'startDate', date.startDate);
    this.setView(component, 'endDate', date.endDate);
  },
  getDate: function(component) {
    let result = {
        startDate: this.getView(component, 'startDate'),
        endDate: this.getView(component, 'endDate'),
    };

    return result;
  },
  canLoad: function(component) {     
    let load = false;

    let dependencies = this.getArrayDependencies(component);

    if(dependencies.length > 0) {
      dependencies.forEach((dependency) => {
        if(dependency === 'diDatePicker') {
            let dateRange = this.getDate(component);

            if(dateRange.startDate && dateRange.endDate) {
              load = true;
            }
        }
      });
    } else {
      load = true;
    }

    console.log('DEBUG:Menu:Helper:canLoad', load);

    return load;
  },
  isReady: function(component) {
    return this.getView(component, 'stateProcess') === 'ready';
  },
  createDate: function(value) {
    return moment(value).toDate();
  }
})