({
    type: 'default',
    config: {
        for_approval: {
            colorText: '#ffffff;',
            colorBackground: '#706e6b;',
            label: 'For Approval'
        },
        in_progress: {
            colorText: '#ffffff;',
            colorBackground: '#fbb018;',
            label: 'In Progress'
        },
        approved: {
            colorText: '#ffffff;',
            colorBackground: '#0070d2;',
            label: 'Approved'
        },
        new: {
            colorText: '#ffffff;',
            colorBackground: '#706e6b;',
            label: 'New'
        },
        pending: {
            colorText: '#ffffff;',
            colorBackground: '#fbb018;',
            label: 'Pending'
        },
        invoiced: {
            colorText: '#ffffff;',
            colorBackground: '#26BBE9;',
            label: 'Invoiced'
        },
        paid: {
            colorText: '#ffffff;',
            colorBackground: '#4bca81;',
            label: 'Paid'
        },
        default: {
            colorText: '#ffffff;',
            colorBackground: '#706e6b;',
            label: 'New'
        }
    },
    updateView: function(component) {
        let type = component.get('v.type');
        
        console.log('DEBUG:DiLabelHelper:updateView:before', type);

        type && (type = type.toLowerCase());

        if(!this.config[type]) {
            type = this.type;
        }

        let config = this.config[type];

        console.log('DEBUG:DiLabelHelper:updateView:config', type, config);

        component.set('v.colorText', config.colorText);
        component.set('v.colorBackground', config.colorBackground);
        component.set('v.label', config.label);

        let el = component.find('diStatusLabel').getElement();
        el.setAttribute('style', 'color:' + config.colorText + ';background-color:' + config.colorBackground + ';');
        console.log('Element: el', el);
        //let cmpTarget = cmp.find('changeIt');
        //$A.util.removeClass(cmpTarget, 'changeMe');
        //$A.util.toggleClass(arr[cmp], cssClass);
        //let el = component.find('diStatusLabel');
        //$A.util.
        /*el.setAttribute('color', config.colorText);
        el.setAttribute('background-color', config.colorBackground);
        el.setText(config.label);*/
    },
})