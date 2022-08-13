(function() {
    var LanguagePicker = function(element) {
        this.element = element;
        this.select = this.element.getElementsByTagName('select')[0];
        this.options = this.select.getElementsByTagName('option');
        this.selectedOption = getSelectedOptionText(this);
        this.pickerId = this.select.getAttribute('id');
        this.trigger = false;
        this.dropdown = false;
        this.firstLanguage = false;
        this.canChange = this.element.classList.contains('js-language-picker-change');
        // dropdown arrow inside the button element
        this.arrowSvgPath = '<svg viewBox="0 0 16 16"><polygon points="3,5 8,11 13,5 "></polygon></svg>';
        this.globeSvgPath = '<svg viewBox="0 0 16 16"><path d="M8,0C3.6,0,0,3.6,0,8s3.6,8,8,8s8-3.6,8-8S12.4,0,8,0z M13.9,7H12c-0.1-1.5-0.4-2.9-0.8-4.1 C12.6,3.8,13.6,5.3,13.9,7z M8,14c-0.6,0-1.8-1.9-2-5H10C9.8,12.1,8.6,14,8,14z M6,7c0.2-3.1,1.3-5,2-5s1.8,1.9,2,5H6z M4.9,2.9 C4.4,4.1,4.1,5.5,4,7H2.1C2.4,5.3,3.4,3.8,4.9,2.9z M2.1,9H4c0.1,1.5,0.4,2.9,0.8,4.1C3.4,12.2,2.4,10.7,2.1,9z M11.1,13.1 c0.5-1.2,0.7-2.6,0.8-4.1h1.9C13.6,10.7,12.6,12.2,11.1,13.1z"></path></svg>';
        initLanguagePicker(this);
        initLanguagePickerEvents(this);
    }
    function initLanguagePicker(picker) {
        // create the HTML for the custom dropdown element
        picker.element.insertAdjacentHTML('beforeend', initButtonPicker(picker) + initListPicker(picker));
        // save picker elements
        picker.dropdown = picker.element.getElementsByClassName('language-picker__dropdown')[0];
        picker.languages = picker.dropdown.getElementsByClassName('language-picker__item');
        picker.firstLanguage = picker.languages[0];
        picker.trigger = picker.element.getElementsByClassName('language-picker__button')[0];
    }
    function initLanguagePickerEvents(picker) {
        // make sure to add the icon class to the arrow dropdown inside the button element
        var svgs = picker.trigger.getElementsByTagName('svg');
        svgs[0].classList.add('icon');
        if(!picker.canChange) return false;
        // language selection in dropdown
        initLanguageSelection(picker);
        // click events
        picker.trigger.addEventListener('click', function(){
            toggleLanguagePicker(picker, false);
        });
        // keyboard navigation
        picker.dropdown.addEventListener('keydown', function(event){
            if(event.keyCode && event.keyCode == 38 || event.key && event.key.toLowerCase() == 'arrowup') {
                keyboardNavigatePicker(picker, 'prev');
            } else if(event.keyCode && event.keyCode == 40 || event.key && event.key.toLowerCase() == 'arrowdown') {
                keyboardNavigatePicker(picker, 'next');
            }
        });
    }
    function toggleLanguagePicker(picker, bool) {
        var ariaExpanded;
        if(bool) {
            ariaExpanded = bool;
        } else {
            ariaExpanded = picker.trigger.getAttribute('aria-expanded') == 'true' ? 'false' : 'true';
        }
        picker.trigger.setAttribute('aria-expanded', ariaExpanded);
        if(ariaExpanded == 'true') {
            picker.dropdown.addEventListener('transitionend', function cb(){
                picker.dropdown.removeEventListener('transitionend', cb);
            });
        }
    }
    function checkLanguagePickerClick(picker, target) { // if user clicks outside the language picker -> close it
        if( !picker.element.contains(target) ) {
            toggleLanguagePicker(picker, 'false');
        }
    }
    function moveFocusToPickerTrigger(picker) {
        if(picker.trigger.getAttribute('aria-expanded') == 'false') {
            return;
        }
        if(document.activeElement.closest('.language-picker__dropdown') == picker.dropdown) picker.trigger.focus();
    }
    function initButtonPicker(picker) { // create the button element -> picker trigger
        // check if we need to add custom classes to the button trigger
        var customClasses = picker.element.getAttribute('data-trigger-class') ? ' '+picker.element.getAttribute('data-trigger-class') : '';
        var lang = getFlagFromValue(picker.select.value);
        var button = '<button class="language-picker__button'+customClasses+'" aria-label="'+picker.select.value+' Select your language" aria-expanded="false" aria-controls="'+picker.pickerId+'-dropdown">';
        button = button + '<span aria-hidden="true" class="language-picker__label language-picker__flag language-picker__flag--'+picker.select.value+'"><img src="/icons/flags/24x24/'+lang+'.png" alt="'+picker.selectedOption+'" title="'+picker.selectedOption+'" /><span>'+picker.selectedOption+'</span>'+picker.arrowSvgPath+'</span>';
        return button+'</button>';
    }
    function initListPicker(picker) { // create language picker dropdown
        var list = '<div class="language-picker__dropdown" aria-describedby="'+picker.pickerId+'-description" id="'+picker.pickerId+'-dropdown">';
        list = list + '<p class="sr-only" id="'+picker.pickerId+'-description">Select your language</p>';
        list = list + '<ul class="language-picker__list" role="listbox">';
        for(var i = 0; i < picker.options.length; i++) {
            var selected = picker.options[i].selected ? ' aria-selected="true"' : '',
                language = picker.options[i].getAttribute('lang'),
                lang = getFlagFromValue(language);
            list = list + '<li><a lang="'+language+'" hreflang="'+language+'" href="#"'+selected+' role="option" data-value="'+picker.options[i].value+'" class="language-picker__item language-picker__flag language-picker__flag--'+picker.options[i].value+'"><img src="/icons/flags/24x24/'+lang+'.png" alt="'+picker.options[i].text+'" title="'+picker.options[i].text+'" /><span>'+picker.options[i].text+'</span></a></li>';
        }
        return list;
    }
    function getSelectedOptionText(picker) { // used to initialize the label of the picker trigger button
        var label = '';
        if('selectedIndex' in picker.select) {
            label = picker.options[picker.select.selectedIndex].text;
        } else {
            label = picker.select.querySelector('option[selected]').text;
        }
        return label;
    }
    function initLanguageSelection(picker) {
        picker.element.getElementsByClassName('language-picker__list')[0].addEventListener('click', function(event){
            var language = event.target.closest('.language-picker__item');
            if(!language) {
                return;
            }
            if(language.hasAttribute('aria-selected') && language.getAttribute('aria-selected') == 'true') {
                // selecting the same language
                event.preventDefault();
                picker.trigger.setAttribute('aria-expanded', 'false'); // hide dropdown
            } else {
                event.preventDefault();
                picker.element.getElementsByClassName('language-picker__list')[0].querySelector('[aria-selected="true"]').removeAttribute('aria-selected');
                language.setAttribute('aria-selected', 'true');

                $(picker.select).val(language.getAttribute('data-value'));
                $(picker.select).parents('form').submit();
            }
        });
    }
    function getFlagFromValue(val) {
        switch (val) {
            case 'en':
                return 'gb';
            default:
                return val;
        }
    }
    function keyboardNavigatePicker(picker, direction) {
        var index = jQuery.getIndexInArray(picker.languages, document.activeElement);
        index = (direction == 'next') ? index + 1 : index - 1;
        if(index < 0) index = picker.languages.length - 1;
        if(index >= picker.languages.length) index = 0;
        jQuery.moveFocus(picker.languages[index]);
    }

    $(document).ready(function() {
        //initialize the LanguagePicker objects
        var languagePicker = document.getElementsByClassName('js-language-picker');
        if (languagePicker.length > 0) {
            var pickerArray = [];
            for (var i = 0; i < languagePicker.length; i++) {
                (function (i) {
                    pickerArray.push(new LanguagePicker(languagePicker[i]));
                })(i);
                languagePicker[i].getElementsByClassName('language-picker-select')[0].style.display = 'none';
            }
            // listen for key events
            window.addEventListener('keyup', function (event) {
                if (event.keyCode && event.keyCode == 27 || event.key && event.key.toLowerCase() == 'escape') {
                    // close language picker on 'Esc'
                    pickerArray.forEach(function (element) {
                        moveFocusToPickerTrigger(element); // if focus is within dropdown, move it to dropdown trigger
                        toggleLanguagePicker(element, 'false'); // close dropdown
                    });
                }
            });
            // close language picker when clicking outside it
            window.addEventListener('click', function (event) {
                pickerArray.forEach(function (element) {
                    checkLanguagePickerClick(element, event.target);
                });
            });
        }
    });
}());