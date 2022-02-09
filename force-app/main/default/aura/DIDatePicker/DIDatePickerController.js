({
  scriptsLoaded: function(component, event, helper) {
    helper.processingProcess(component, 'scriptsLoaded');
  },
  doInit: function(component, event, helper) {
    helper.processingProcess(component, 'init');
  },
  handleManualInput: function(component, event, helper) {
    helper.handleManualInput(component, event);
  },
  handleYearChange: function(component, event, helper) {
    let newYear = event.getParam('data');
    let date = component.get('v.date');
    helper.changeYear(component, newYear, date);
  },
  handleClick: function(component, event, helper) {
    helper.selectDate(component, event);
    helper.hideGrid();   
  },
  handleClearDate: function(component, event, helper) {
    helper.clearDate(component);
    event.preventDefault();
    return false;
  },
  handleClickIconCalendar: function(component, event, helper) {
    let datepicker = document.getElementById('datepicker-dropdown')

    if (datepicker) {
      if(datepicker.classList.contains('slds-hide')) {
        helper.showGrid();
      } else {
        helper.hideGrid();
      }
    }
    
    event.preventDefault();
    event.stopPropagation();
    return false;
  },
  goToToday: function(component, event, helper) {
    event.stopPropagation();
    helper.goToToday(component, event);
    helper.hideGrid();   
    return false;
  },
  goToThisWeek: function(component, event, helper) {
    event.stopPropagation();
    helper.goToThisWeek(component, event);
    helper.hideGrid();   
    return false;
  },
  goToPreviousWeek: function(component, event, helper) {
    event.stopPropagation();
    helper.changeWeek(component, -7);
    return false;
  },
  goToNextWeek: function(component, event, helper) {
    event.stopPropagation();
    helper.changeWeek(component, 7);
    return false;
  },
  goToPreviousMonth: function(component, event, helper) {
    event.stopPropagation();
    helper.changeMonth(component, -1);
    return false;
  },
  goToNextMonth: function(component, event, helper) {
    event.stopPropagation();
    helper.changeMonth(component, 1); 
    return false;
  },
  onMouseEnterGrid: function(component, event, helper) {
    helper.setView(component, '_gridOver', true);
  },
  update: function (component, event, helper) {
    let params = event.getParam('arguments');
    console.log('DEBUG:TIMESHEET:DatePicker:Update:Params:', params['data'].id,  params['data'].state,  params['data'].data);
  }
});