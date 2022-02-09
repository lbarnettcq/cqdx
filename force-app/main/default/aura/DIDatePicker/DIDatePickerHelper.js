({
  id: 'diDatePicker',
  datesRange: null,
  numberCells: 42,
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
    this.initDatesRange();

    for (let i = 0; i < this.numberCells; i++) {
      let cellCmp = component.find(i);
      if (cellCmp) {
        cellCmp.addEventHandler('dateCellClick', component.getReference('c.handleClick'));
      }
    }

    //let format = component.get('v.formatSpecifier');
    let datestr = this.getView(component, 'value');
    //let langLocale = $A.get('$Locale.langLocale');

    let currentDate = this.parseInputDate(component, datestr);
    this.setDateValues(component, currentDate, currentDate.getDate());

    let minDateRaw = this.getView(component, 'min');
    if (minDateRaw) {
      this.setView(component, 'minDate', this.parseInputDate(component, minDateRaw));
    }

    this.updateNameOfWeekDays(component);
    this.generateYearOptions(component, currentDate);

    let setFocus = this.getView(component, 'setFocus');
    if (!setFocus) {
      this.setView(component, '_setFocus', false);
    }

    this.renderGrid(component);

    this.setView(component, 'date', currentDate.getDate());

    this.notify(component, 'init');
  },
  getView: function(component, view) {
    return component.get('v.' + view);
  },
  setView: function(component, view, value) {
      return component.set('v.' + view, value);
  },
  changeYear: function(component, newYear, date) {
    let currentMonth = this.getView(component, 'month');
    let currentYear = this.getView(component, 'year');

    if (!currentYear) {
      currentYear = distdlib.date.current.year();
    }

    let currentDate = new Date(currentYear, currentMonth, date);
    let targetDate = new Date(newYear, currentDate.getMonth(), 1);

    let daysInMonth = distdlib.date.numDays(currentMonth, currentYear);

    if (daysInMonth < date) {
      date = daysInMonth;
    }

    this.setDateValues(component, targetDate, date);
    this.selectWeek(component);
  },
  changeMonth: function(component, monthChange) {
    let currentYear = this.getView(component, 'year');
    let currentMonth = this.getView(component, 'month');
    let currentDay = this.getView(component, 'date');

    let targetDate = new Date(currentYear, currentMonth + monthChange, 1);
    let totalDaysTargetMonth = distdlib.date.numDays(targetDate.getMonth(), targetDate.getFullYear());

    console.log('DEBUG:DIDatePicker:Helper:changeMonth:', currentYear, currentMonth, currentDay, targetDate, totalDaysTargetMonth);

    if (totalDaysTargetMonth < currentDay) { // The target month doesn't have the current date. Just set it to the last date.
      currentDay = totalDaysTargetMonth;
    }

    targetDate.setDate(currentDay);

    console.log('DEBUG:DIDatePicker:Helper:changeMonth:targetDate', targetDate);

    this.setDateValues(component, targetDate, currentDay);
    this.selectWeek(component);
  },
  changeWeek: function(component, dateChange) {
    let currentYear = this.getView(component, 'year');
    let currentMonth = this.getView(component, 'month');
    let currentDay = this.getView(component, 'date');

    let targetDate = new Date(currentYear, currentMonth, currentDay + dateChange);

    this.setDateValues(component, targetDate, targetDate.getDate());
    this.selectWeek(component);
  },
  //TODO:Remove duplicate
  goToToday: function(component, event) {
    let currentYear = distdlib.date.current.year();
    let currentMonth = distdlib.date.current.month.integer();
    let currentDay = distdlib.date.current.day();

    let newYear = component.find('yearSelect').set('v.value', currentYear);

    let targetDate = new Date(currentYear, currentMonth, currentDay);
    this.setDateValues(component, targetDate, currentDay);
    this.selectWeek(component);
  },
  goToThisWeek: function(component, event) {
    let currentYear = distdlib.date.current.year();
    let currentMonth = distdlib.date.current.month.integer();
    let currentDay = distdlib.date.current.day();

    let newYear = this.setView(component.find('yearSelect'), 'value', currentYear);

    let targetDate = new Date(currentYear, currentMonth, currentDay);
    this.setDateValues(component, targetDate, currentDay);
    this.selectWeek(component);
  },
  dateCompare: function(date1, date2) {
    if (date1.getFullYear() !== date2.getFullYear()) {
      return date1.getFullYear() - date2.getFullYear();
    } else {
      if (date1.getMonth() !== date2.getMonth()) {
        return date1.getMonth() - date2.getMonth();
      } else {
        return date1.getDate() - date2.getDate();
      }
    }
  },
  dateEquals: function(date1, date2) {
    return date1 && date2 && this.dateCompare(date1, date2) === 0;
  },
  findDateComponent: function(component, date) {
    let firstDate = new Date(date.getTime());

    firstDate.setDate(1);

    let initialPos = firstDate.getDay();
    let pos = initialPos + date.getDate() - 1;

    return component.find(pos);
  },
  generateMonth: function(component) {
    let dayOfMonth = this.getView(component, 'date');
    let month = this.getView(component, 'month');
    let year = this.getView(component, 'year');

    let date = new Date(year, month, dayOfMonth);
    let minDate = this.getView(component, 'minDate');
    let datesRange = this.getView(component, 'dates');

    let selectedDate = new Date(year, month, dayOfMonth);

    let today = new Date();
    let d = new Date();
    d.setDate(1);
    d.setFullYear(year);
    d.setMonth(month);
  
    let firstDayOfWeek = $A.get('$Locale.firstDayOfWeek') - 1; // In Java, week day is 1 - 7
    let startDay = d.getDay();
    let firstFocusableDate;

    while (startDay !== firstDayOfWeek) {
      d.setDate(d.getDate() - 1);
      startDay = d.getDay();
    }

    for (let i = 0; i < this.numberCells; i++) {
      let cellCmp = component.find(i);
      if (cellCmp) {
        //let dayOfWeek = d.getDay();
        let tdClass = '';

        if (d.getMonth() === month - 1 || d.getFullYear() === year - 1) {
          this.setView(cellCmp, 'ariaDisabled', 'true');
          tdClass = 'slds-disabled-text';
        } else if (d.getMonth() === month + 1 || d.getFullYear() === year + 1) {
          this.setView(cellCmp, 'ariaDisabled', 'true');
          tdClass = 'slds-disabled-text';
        }

        if (d.getMonth() === month && d.getDate() === 1) {
          firstFocusableDate = cellCmp;
        }

        if (this.dateEquals(d, today)) {
          tdClass += ' slds-is-today';
        }

        if (this.dateEquals(d, selectedDate)) {
          this.setView(cellCmp, 'ariaSelected', 'true');
          tdClass += ' slds-is-selected';
          firstFocusableDate = cellCmp;
        }

        if (minDate && minDate.getTime() > d.getTime()) {
          this.setView(cellCmp, 'ariaDisabled', 'true');
          tdClass = 'slds-disabled-text';
        }

        this.setView(cellCmp, 'tabIndex', -1);
        this.setView(cellCmp, 'label', d.getDate());
  
        this.setView(cellCmp, 'date', d.getFullYear() + '-' + (d.getMonth()+1) + '-' + d.getDate());
        this.setView(cellCmp, 'tdClass', tdClass)

        this.setView(cellCmp, 'value', distdlib.date.addZero(d));

      }

      d.setDate(d.getDate() + 1);
    }

    if (firstFocusableDate) {
      this.setView(firstFocusableDate, 'tabIndex', 0);
    }

    this.setView(component, '_setFocus', true);
  },
  goToFirstOfMonth: function(component) {
    let date = new Date(this.getView(component, 'year'), this.getView(component, 'month'), 1);

    let targetId = date.getDay();
    let targetCellCmp = component.find(targetId);
    targetCellCmp.getElement().focus();

    this.setView(component, 'date', 1);
  },
  goToLastOfMonth: function(component) {
    let date = new Date(this.getView(component, 'year'), this.getView(component, 'month') + 1, 0);

    let targetCellCmp = this.findDateComponent(component, date);
    if (targetCellCmp) {
      targetCellCmp.getElement().focus();
      this.setView(component, 'date', this.getView(targetCellCmp, 'label'));
    }
  },
  renderGrid: function(component) {
    this.generateMonth(component);
    this.selectWeek(component);
  },
  selectDate: function(component, event) {
    let source = event.getSource();

    let firstDate = new Date(this.getView(component, 'year'), this.getView(component, 'month'), 1);
    let firstDateId = parseInt(firstDate.getDay(), 10);
  
    let firstDayOfWeek = $A.get('$Locale.firstDayOfWeek') - 1; // The week days in Java is 1 - 7
    let offset = 0;
    if (firstDayOfWeek !== 0) {
      if (firstDateId >= firstDayOfWeek) {
        offset -= firstDayOfWeek;
      } else {
        offset += (7 - firstDayOfWeek);
      }
    }

    firstDateId += offset;
    let lastDate = new Date(this.getView(component, 'year'), this.getView(component, 'month') + 1, 0);
    let lastDateCellCmp = this.findDateComponent(component, lastDate);
    let lastDateId = parseInt(lastDateCellCmp.getLocalId(), 10);
    lastDateId += offset;

    let currentId = parseInt(source.getLocalId(), 10);
    let currentDate = source.get('v.label');
    let targetDate;
    if (currentId < firstDateId) { // previous month
      targetDate = new Date(this.getView(component, 'year'), this.getView(component, 'month') - 1, currentDate);
      this.setDateValues(component, targetDate, targetDate.getDate());

    } else if (currentId > lastDateId) { // next month
      targetDate = new Date(this.getView(component, 'year'), this.getView(component, 'month') + 1, currentDate);
      this.setDateValues(component, targetDate, targetDate.getDate());

    } else {
      this.setView(component, 'date', currentDate);
    }

    let selectedDate = new Date(this.getView(component, 'year'), this.getView(component, 'month'), this.getView(component, 'date'));

    let paddedMonth = distdlib.addZeroToValue(this.getView(component, 'month') + 1);
    let paddedDay = distdlib.addZeroToValue(this.getView(component, 'date'));
    let dateStr = this.getView(component, 'year') + '-' + paddedMonth + '-' + paddedDay;

    this.setView(component, 'selectedDate', selectedDate);
    this.setView(component, 'value', dateStr);

    this.setView(component, 'dates', this.createDatesRange(component, selectedDate));

    this.validateSelectedDate(component, selectedDate);

    this.selectWeek(component);
  },
  setFocus: function(component) {
    let date = this.getView(component, 'date');

    if (!date) {
      date = 1;
    }

    let year = this.getView(component, 'year');
    let month = this.getView(component, 'month');
    let cellCmp = this.findDateComponent(component, new Date(year, month, date));

    if (cellCmp) {
      cellCmp.getElement().focus();
    }
  },
  updateNameOfWeekDays: function(component) {
    let firstDayOfWeek = $A.get('$Locale.firstDayOfWeek') - 1; // The week days in Java is 1 - 7
    let namesOfWeekDays = $A.get('$Locale.nameOfWeekdays');

    let days = [];
    if (distdlib.isNumber(firstDayOfWeek) && $A.util.isArray(namesOfWeekDays)) {
      for (let i = firstDayOfWeek; i < namesOfWeekDays.length; i++) {
        namesOfWeekDays[i]['shortName'] = distdlib.capitalizeFirstLetter(namesOfWeekDays[i]['shortName']);
        days.push(namesOfWeekDays[i]);
      }
      for (let j = 0; j < firstDayOfWeek; j++) {
        namesOfWeekDays[j]['shortName'] = distdlib.capitalizeFirstLetter(namesOfWeekDays[j]['shortName']);
        days.push(namesOfWeekDays[j]);
      }
      this.setView(component, '_namesOfWeekdays', days);
    } else {
      this.setView(component, '_namesOfWeekdays', namesOfWeekDays);
    }
  },
  setDateValues: function(component, fullDate, dateNum) {
    this.setView(component, 'year', fullDate.getFullYear());
    this.setView(component, 'month', fullDate.getMonth());
    this.setView(component, 'monthName', distdlib.l10n.months.longhand[fullDate.getMonth()]);
    this.setView(component, 'date', dateNum);
    this.setView(component, 'selectedDate', fullDate);
    this.validateSelectedDate(component, fullDate);

    console.log('DEBUG:DatePicker:setDateValues', fullDate);
    this.setView(component, 'dates', this.createDatesRange(component, fullDate));
  },
  generateYearOptions: function(component, fullDate) {
    let years = [];
    let startYear = this.getView(component, 'startYear');
    let finishYear = this.getView(component, 'finishYear');

    if (!this.getView(component, 'extendedYearRange') || !startYear || !finishYear || (startYear >= finishYear)) {
      startYear = fullDate.getFullYear() - 1;
      finishYear = startYear + 10
    }

    let thisYear = fullDate.getFullYear();

    for (let i = startYear; i <= finishYear; i++) {
      years.push({ 'class': 'optionClass', label: i, value: i });
    }

    try {
      years[thisYear].selected = true;
    } catch (e) {
      //can't select this year, so don't worry 'bout it
    }

    this.setView(component, 'options', years);
  },
  handleManualInput: function(component, event) {
    let params = event.getParam('data');
    if (params) {
      let date = params.date;
      this.setView(component, 'value', date);
      this.handleManualDateChange(component);
    }
  },
  handleManualDateChange: function(component) {
    //let format = component.get('v.formatSpecifier');
    let datestr = this.getView(component, 'value');
    //let langLocale = $A.get('$Locale.langLocale');

    //if a person has deliberately cleared the date, respect that.
    if ($A.util.isEmpty(datestr)) {
      this.clearDate(component);
      return;
    }

    let currentDate = this.parseInputDate(component, datestr);
    this.setDateValues(component, currentDate, currentDate.getDate());

    // Set the first day of week
    this.updateNameOfWeekDays(component);
    this.generateYearOptions(component, currentDate);

    let selectedDate = new Date(this.getView(component, 'year'), this.getView(component, 'month'), this.getView(component, 'date'));

    let paddedMonth = distdlib.addZero(this.getView(component, 'month') + 1);
    let paddedDay = distdlib.addZero(this.getView(component, 'date'));
    let dateStr = this.getView(component, 'year') + '-' + paddedMonth + '-' + paddedDay;
    console.log(dateStr);

    this.setView(component, 'selectedDate', selectedDate);
    this.setView(component, 'value', dateStr);

    this.validateSelectedDate(component, selectedDate);

    this.selectWeek(component);
    //finally fire the event to tell parent components we have changed the date:
    let dateChangeEvent = component.getEvent('dateChangeEvent');
    dateChangeEvent.setParams({ 'value': dateStr });
    dateChangeEvent.fire();

    console.log('manual change: selectedDate: ' + selectedDate);
    console.log('manual change: dateStr: ' + dateStr);
  },
  clearDate: function(component) {
    this.setView(component, 'selectedDate', '');
    this.setView(component, 'value', '');

    //finally fire the event to tell parent components we have changed the date:
    let dateChangeEvent = component.getEvent('dateChangeEvent');
    dateChangeEvent.setParams({ 'value': '' });
    dateChangeEvent.fire();

    this.validateSelectedDate(component, '');
  },
  validateSelectedDate: function(component, selectedDate) {
    let minDate = this.getView(component, 'minDate');
    
    if (selectedDate && minDate > selectedDate) {
      this.setView(component, '_error', true);
      this.setView(component, '_errorMessage', 'Date cannot be before ' + ((minDate.getMonth() + 1) + '/' + minDate.getDate() + '/' + minDate.getFullYear()));
    } else {
      this.setView(component, '_error', false);
      this.setView(component, '_errorMessage', '');
    }
  },
  parseInputDate: function(component, datestr) {
    let parsedDate = $A.localizationService.parseDateTime(datestr, 'MM/DD/YYYY');
    let timezone = $A.get('$Locale.timezone');

    //ok try this format
    if (parsedDate == null || !this.isDateValid(parsedDate)) {
      parsedDate = $A.localizationService.parseDateTime(datestr, 'yyyy-MM-dd');
    }

    //try, try again
    if (parsedDate == null || !this.isDateValid(parsedDate)) {
      $A.localizationService.getToday(timezone, function(today) {
        parsedDate = $A.localizationService.parseDateTime(today, 'yyyy-MM-dd');
      });
    }
    return parsedDate;
  },
  getOffset: function(el) {
    let _x = 0;
    let _y = 0;
    while (el && !isNaN(el.offsetLeft) && !isNaN(el.offsetTop)) {
      _x += el.offsetLeft - el.scrollLeft;
      _y += el.offsetTop - el.scrollTop;
      el = el.offsetParent;
    }
    return { top: _y, left: _x };
  },
  hideOnClickOutside: function(element) {
    const outsideClickListener = event => {
      if (!element.contains(event.target)) {
        if (this.isVisible(element)) {
          this.hideGrid();
          removeClickListener()
        } else {
          console.log('DEBUG:handle not visible');
        }
      }
    }

    const removeClickListener = () => {
      document.removeEventListener('click', outsideClickListener)
    }

    document.addEventListener('click', outsideClickListener);
  },
  isVisible: function(elem) {
    return (!!elem && !!(elem.offsetWidth || elem.offsetHeight || elem.getClientRects().length));
  },
  showGrid: function() {    
    let datepicker = document.getElementById('datepicker-dropdown');

    if (datepicker) {
      datepicker.classList.remove('slds-hide');
      datepicker.classList.remove('slds-transition-hide');
      this.hideOnClickOutside(document.getElementById('DeepDateGrid'));
    }
  },
  hideGrid: function() {
    let datepicker = document.getElementById('datepicker-dropdown')

    if (datepicker) {
      datepicker.classList.add('slds-hide');
      datepicker.classList.add('slds-transition-hide');
    }
  },
  initDatesRange: function() {
    this.datesRange = {
        selectedDate: null,
        ranges: {
          weekMonth: 0,
          weeks: [
            {class: ''},
            {class: ''},
            {class: ''},
            {class: ''},
            {class: ''},
            {class: ''},
            {class: ''}
          ],
          weekdays: {
            'sunday': {year: '', month: '',  date: '', value: '', label: '', format: 'YYYY-MM-DD'},
            'monday': {year: '', month: '',  date: '', value: '', label: '', format: 'YYYY-MM-DD'},
            'tuesday': {year: '', month: '',  date: '', value: '', label: '', format: 'YYYY-MM-DD'},
            'wednesday': {year: '', month: '',  date: '', value: '', label: '', format: 'YYYY-MM-DD'},
            'thursday': {year: '', month: '',  date: '', value: '', label: '', format: 'YYYY-MM-DD'},
            'friday': {year: '', month: '',  date: '', value: '', label: '', format: 'YYYY-MM-DD'},
            'saturday': {year: '', month: '',  date: '', value: '', label: '', format: 'YYYY-MM-DD'}
          },
          dates: {}
        }
      }
  },
  createDatesRange: function(component, selectedDate) {
    console.log('DEBUG:createDatesRange:selectedDate', selectedDate);

    if (distdlib.isDate(selectedDate)) { 
      console.log('DEBUG:createDatesRange:selectedDate:After', selectedDate);

      this.initDatesRange();

      this.datesRange.selectedDate = selectedDate;

      let currentTimestamp = selectedDate.getTime();
      let currentDayIndex = selectedDate.getDay();
      
      this.datesRange.ranges.weekMonth = distdlib.date.getWeekOfMonth(selectedDate);

      console.log('DEBUG:createDatesRange:selectedDate:After:Init:', this.datesRange.ranges.weekMonth);

      let weekSelected = this.datesRange.ranges.weeks[this.datesRange.ranges.weekMonth];
      if(weekSelected) {
        weekSelected.class = 'slds-has-multi-selection';
      }

      let weekdaysLength = distdlib.date.daysWeek.length;
      for(let dayIndex = 0; dayIndex < weekdaysLength; dayIndex++) {
        let date = new Date(currentTimestamp);
       
        date.setDate(selectedDate.getDate() + (dayIndex - currentDayIndex));
        
        //console.log('DEBUG:createDatesRange:selectedDate', dayIndex, currentDayIndex, date);

        let week = distdlib.date.daysWeek[date.getDay()]['name'];
        let day = this.datesRange.ranges.weekdays[week];

        day.year = date.getFullYear();
        day.month = date.getMonth();
        day.date = date.getDate();

        let month = (day.month+1);

        day.value = day.year + '-' + month + '-' + day.date;
        day.label = day.date + ' ' + distdlib.date.months[day.month].label + ' ' + day.year;

        this.datesRange.ranges.dates[day.year + '-' + month  + '-' + day.date] = week;
      }

      console.log('DEBUG:createDatesRange:selectedDate:Result', this.datesRange);

      this.notify(component, 'change');
    }

    return this.datesRange;
  },
  selectWeek: function(component) {
    console.log('DEBUG:createDatesRange:selectWeek:Result', this.datesRange, component.find(41));
    let datesRange = this.getView(component, 'dates');

    for (let i = 0; i < this.numberCells; i++) {
      let cellCmp = component.find(i);

      if (cellCmp) {
        let date = this.getView(cellCmp, 'date');//TODO
        //console.log('DEBUG:createDatesRange:selectWeek:date', date, i, cellCmp);
        if(date && datesRange.ranges.dates[date]) {
          this.setView(cellCmp, 'tdSelectClass', 'slds-is-selected is-selected-multi'); 
        } else {
          this.setView(cellCmp, 'tdSelectClass', ''); 
        }
      }
    }
  },
  notify: function(component, state, data) {
    let params = {id: this.id, dependencies: this.getArrayDependencies(component)};

    if(!state) {
      state = 'init';
    }

    params['state'] = state;

    if(!distdlib.isObject(data)) {
      data = {
        selectedDate: this.datesRange.selectedDate,
        startDate: this.datesRange.ranges.weekdays.sunday.value,
        endDate: this.datesRange.ranges.weekdays.saturday.value
      };
    }

    params['data'] = data;

    let changeEvent = component.getEvent('changeEvent');

    changeEvent.setParams({data: params});

    changeEvent.fire();
  },
  getDateRange: function() {
    return this.datesRange;
  },
  getArrayDependencies: function(component) {        
    let dependencies = this.getView(component, 'dependencies');

    console.log('DEBUG:DiDatePicker:Helper:init:dependencies:', dependencies);

    if(dependencies && Array.isArray(dependencies)) {
        console.log('DEBUG:DiDatePicker:Helper:init:dependencies:array:', dependencies);
        return dependencies;
    }

    return [];
},
});