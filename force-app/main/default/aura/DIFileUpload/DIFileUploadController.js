({
    scriptsLoaded: function(component, event, helper) {
        helper.processingProcess(component, 'scriptsLoaded');
    },
    doInit: function(component, event, helper) {
        helper.processingProcess(component, 'init');
    },
    handleFilesChange: function(component, event, helper) {
        let listFiles = Array.from(event.getSource().get("v.files"));

        console.log('DIFileUpload:handleFilesChange:listFiles:', listFiles);

        if (listFiles.length > 0) {
            let existFiles = helper.getView(component, 'files');

            listFiles.forEach(file => {
                let type = file.type.split('/');

                if(type[0]) {
                    type = (type[0] + '').toUpperCase();
                }
                
                file.typeLabel = type;

                existFiles.push(file);
            });

            helper.setView(component, 'files', existFiles /*[...existFiles, ...listFiles]*/);
            helper.setView(component, 'showMessage', false);
        }

        let data = {
            files: listFiles
        };

        helper.notify(component, 'change', data);
    },
    update: function(component, event, helper) {
        let params = event.getParam('arguments');
        let data = params['data'];
  
        if(distdlib.isObject(data)) {   
           console.log('DEBUG: DiFileUploadController: update: data:', data.action, data.recordId);      
           helper.updateView(component, data);        
        } else {
           console.log('DEBUG: DiFileUploadController: update: not is object');
        }
     },
    deleteFile: function(component, event, helper) {
        helper.deleteFile(component, event);
    },
    viewFile: function(component, event, helper) {
        helper.viewFile(component, event);
    },
    closeModel: function(component, event, helper) {
        // for Close Model, set the "hasModalOpen" attribute to "FALSE"  
        component.set("v.hasModalOpen", false);
        component.set("v.selectedDocumentId" , null); 
    },
})