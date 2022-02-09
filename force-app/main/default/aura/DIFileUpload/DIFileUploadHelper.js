({
    id: 'diFileUpload',
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 4500000,      //Chunk Max size 750Kb/750000   
    processingProcess: function(component, currentState) {
        let process = {
            'scriptsLoaded': 'init',
            'init': 'scriptsLoaded'
        };

        let previousState = this.getView(component, 'stateProcess');

        console.log('DEBUG:ModalDialog:Create Timesheet:Helper:processingProcess:', currentState, previousState, process[currentState]);

        if(process[currentState] == previousState) {
            this.setView(component, 'stateProcess', 'ready');
            this.init(component); 
        } else {
            this.setView(component, 'stateProcess', currentState);
        }
    },
    init: function(component) {
        this.getFiles(component);
    },
    notify: function(component, state, data) {
        console.log('DiFileUploadHelper:notify:', state, data);
        let params = {id: this.id};
    
        if(!state) {
          state = 'init';
        }
    
        params['state'] = state;
    
        if(distdlib.isObject(data)) {
            params['data'] = data;
        }

        let changeEvent = component.getEvent('changeEvent');
        changeEvent.setParams({data: params});
        changeEvent.fire();
    },
    updateView: function(component, data) {
        Object.keys(data).forEach(prop => {
            this.setView(component, prop, data[prop]);            
        });

        switch(data.action) {
            case 'upload':
                this.uploadFiles(component);
                break;
            case 'getFiles':
                this.getFiles(component);
                break;
            case 'clear':
                this.clear(component);
                break;
        }
    },
    uploadFiles: function(component) {
        let recordId = this.getView(component, 'recordId');
        let listFiles = this.getView(component, 'files').filter(file => !file.id);

        console.log('DEBUG:DiFileUploadHelper:uploadFiles:listFiles:', listFiles);

        if (recordId && (listFiles.length > 0)) {
            let self = this;

            this.setView(component, 'showLoadingSpinner', true);

            const BASE_64 = 'base64,';
            const POSITION_START = 0;
    
            let filesDownload = [];

            let numberFiles = listFiles.length;
            let numberIterateFiles = 0;
    
            let canUpload = true;
            console.log('DEBUG:DiFileUploadHelper:uploadFiles:listFiles:after:', listFiles);
            listFiles.forEach(file => {
                if (file.size > self.MAX_FILE_SIZE || file.id) {
                    numberIterateFiles++;
                    console.error('File ' + file.name + ' has size more then ' + self.MAX_FILE_SIZE);
                    //component.set("v.showLoadingSpinner", false);
                    //component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
                    return;
                }
    
                //TODO:Replace by promise
                let fileReader = new FileReader();
                
                fileReader.onload = $A.getCallback(() => {   
                    numberIterateFiles++;
    
                    let content = fileReader.result;
                    let dataStart = content.indexOf(BASE_64) + BASE_64.length;
    
                    content = content.substring(dataStart);
    
                    filesDownload.push({
                        name: file.name,
                        content: content,
                        type: file.type,
                        position: {
                            start: POSITION_START,
                            end: POSITION_START + self.CHUNK_SIZE
                        },
                        attachId: ''
                    });
                    
                    console.log('DEBUG:DiFileUploadHelper:uploadFiles:iteration:' + file.name, numberIterateFiles, numberFiles, numberIterateFiles === numberFiles);
                    if((numberIterateFiles === numberFiles) && canUpload) {
                        canUpload = false;
                        console.log('DEBUG:DiFileUploadHelper:uploadFiles:iteration:run', filesDownload);
                        self.uploadProcess(component, filesDownload); 
                    }
                });
    
                fileReader.readAsDataURL(file);
            });
        } else {
            console.info('Files or recordId is absent');
            this.notify(component, 'change', {action: 'uploadedFiles'});
        }     
    }, 
    uploadProcess: function(component, files) {
        console.log('DEBUG:DiFileUploadHelper:uploadProcess:init:');
        let params = {
            listFiles: []
        };

        files.forEach((file, index) => {
            let getchunk = file.content.substring(file.position.start, file.position.end);

            params.listFiles.push(
                {
                    id: file.attachId,
                    name: file.name,
                    content: getchunk, //encodeURIComponent(getchunk),
                    type: file.type,                    
                    recordId: this.getView(component, 'recordId'),
                    _id: index
                }
            );
        });
        console.log('DEBUG:DiFileUploadHelper:uploadProcess:params:', params);
     
        let action = component.get("c.saveFiles");
        action.setParams(params);

        action.setCallback(this, function(response) {           
            let resultListFiles = response.getReturnValue(); //store the response / Attachment Id   

            console.log('DEBUG:DiFileUploadHelper:uploadProcess:resultListFiles:', resultListFiles);

            let state = response.getState();

            if (state === "SUCCESS") {
                let listFiles = [];
                console.log('DEBUG:DiFileUploadHelper:uploadProcess:resultListFiles:success:before');
                files.forEach(file => {
                    let startPosition = file.position.end;
                    let endPosition = Math.min(file.content.length, startPosition + this.CHUNK_SIZE);

                    if(startPosition < endPosition) {
                        resultListFiles.data.list.some(rFile => {
                            if(rFile['id'] && rFile['_id'] == file['_id']) {
                                file['id'] = rFile['id'];
                                file['position']['start'] = startPosition;
                                file['position']['end'] = endPosition;
                                listFiles.push(file);
                                return true;
                            }
                        });                        
                    }
                });
                console.log('DEBUG:DiFileUploadHelper:uploadProcess:resultListFiles:success:after', listFiles);
                files.length = 0;

                if (listFiles.length > 0) {
                    this.uploadProcess(component, listFiles);                    
                } else {                    
                    console.log('Your file is uploaded successfully');
                    this.setView(component, 'showLoadingSpinner', false);
                    this.notify(component, 'change', {action: 'uploadedFiles'});
                }                 
            } else if (state === 'INCOMPLETE') {
                console.log('File upload: ' + response.getReturnValue());
                this.notify(component, 'change', {action: 'uploadedFiles'});
            } else if (state === 'ERROR') {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error('File upload:' + errors[0].message);
                    }
                } else {
                    console.error('File upload:unknown error');
                }

                this.notify(component, 'change', {action: 'uploadedFiles'});
            } else {
                this.notify(component, 'change', {action: 'uploadedFiles'});
            }
        });

        $A.enqueueAction(action);
    },
    getView: function(component, view) {
        return component.get('v.' + view);
    },
    setView: function(component, view, value) {
        return component.set('v.' + view, value);
    },
    setLoadingIndicator: function(component, show) {
        this.setView(component, 'showLoadingSpinner', show);
    },
    getFiles:function(component) {        
        this.setLoadingIndicator(component, true);
        let recordId = this.getView(component, 'recordId');
        let files = this.getView(component, 'files');
        console.log('DEBUG:DIFileUpload:Helper:getFiles', recordId, files);

        if(recordId && (files.length == 0)) {
            let params = {
                recordId: recordId
            };
    
            console.log('DEBUG:DIFileUpload:Helper:getFiles: params:', params);
    
            this.sendRequest(component, 'c.getList', params)
            .then(result => {
                console.log('DEBUG:DIFileUpload:Helper:getFiles: Load:Success:', result);    
                if(result.status === 'success') {
                    if(distdlib.isObject(result['data']) && Array.isArray(result['data']['list'])) {
                        let resultFiles = result['data']['list'];
                        let listFiles = [];

                        resultFiles.forEach(file => {
                            listFiles.push({
                                id: file.id,
                                name: file.name,
                                type: file.type,
                                typeLabel: file.type
                            });
                        });

                        this.setView(component, 'files', listFiles);
                        this.setView(component, 'showMessage', listFiles.length === 0);
                        this.setLoadingIndicator(component, false);
                    }
                } else {
                    this.setLoadingIndicator(component, false);
                }                
            })
            .catch((errors) => {
                console.error('DEBUG:DIFileUpload:Helper:getFiles: Load:Error:', errors);
                this.setLoadingIndicator(component, false);
            }); 
        } else {
            this.setView(component, 'showMessage', (files.length == 0));
            this.setLoadingIndicator(component, false);
        }
    },
    deleteFile: function(component, event) {
        console.log('DEBUG:DIFileUpload:Helper:deleteFile');
        let rowId = event.target.dataset.rowId;   
        let listFiles = this.getView(component, 'files');
        let localFile = listFiles[rowId];
        console.log('DEBUG:DIFileUpload:Helper:deleteFile:localFile', listFiles, localFile, rowId);
        if(localFile) {
            let id = localFile.id;

            if(localFile.id) {
                localFile.state = 'delete';
                this.setView(component, 'files', listFiles);

                let params = {
                    documentId: id
                };

                console.log('DEBUG:DIFileUpload:Helper:deleteFile: params:', params);
           
                this.sendRequest(component, 'c.deleteEntry', params)
                .then((result) => {
                    console.log('DEBUG:DIFileUpload:Helper:deleteFile: Load:Success:', result);  

                    if(result.status === 'success') {                        
                        listFiles = this.getView(component, 'files');

                        let resultListFiles = listFiles.filter(file => file.id != id);

                        this.setView(component, 'files', resultListFiles);

                        if(resultListFiles.length === 0) {
                            this.setView(component, 'showMessage', true);
                        }                        
                    }
                })
                .catch((errors) => {
                    console.error('DEBUG:DIFileUpload:Helper:deleteFile: Load:Error:', errors);
                }); 
            } else {
                console.log('DEBUG:DIFileUpload:Helper:deleteFile:localFile:slice');
                listFiles.splice(rowId, 1);
                this.setView(component, 'files', listFiles);

                if(listFiles.length === 0) {
                    this.setView(component, 'showMessage', true);
                }
            }
        }        
    },
    clear: function(component) {
        this.setView(component, 'recordId', null);
        this.setView(component, 'files', null);
        this.setView(component, 'showMessage', true);
        this.setView(component, 'showLoadingSpinner', false);
    },
    sendRequest: function(component, methodName, params, category) {
        return new Promise($A.getCallback(function(resolve, reject) {
            let action = component.get(methodName);

            action.setParams(params);

            action.setCallback(self, function(res) {                
              let state = res.getState();

              if(state === 'SUCCESS') {
                let result = {};

                if(typeof category == 'undefined') {
                    result = res.getReturnValue();
                } else {
                    result[category] = res.getReturnValue();
                }           

                resolve(result);
              } else if(state === 'ERROR') {
                reject(action.getError())
              } else {
                reject(action.getError())
              }
            });
            $A.enqueueAction(action);
        }));
    },
    viewFile: function(component, event) {
        let files = this.getView(component, 'files');
        let rowIndex = event.currentTarget.getAttribute('data-row-id');

        if(files[rowIndex] && files[rowIndex]['id']) {
            this.setView(component, 'hasModalOpen', true);
            this.setView(component, 'selectedDocumentId', files[rowIndex]['id']);
        }
    }
})