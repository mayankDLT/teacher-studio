
(function($){
    $.fn.validationEngineLanguage = function(){
    };
    $.validationEngineLanguage = {
        newLang: function(){
            $.validationEngineLanguage.allRules = {
                "required": { // Add your regex rules here, you can take telephone as an example
                    "regex": "none",
                    "alertText": "* Dieses Feld ist ein Pflichtfeld",
                    "alertTextCheckboxMultiple": "* Bitte wählen Sie eine Option",
                    "alertTextCheckboxe": "* Dieses Feld ist ein Pflichtfeld"
                },
				"dateTime":{
					"regex": /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/,
					"alertText": "Wählen Sie aus dem Kalender"
				},
			    "dateOnly":{
					"regex": /^(\d{4})-(\d{2})-(\d{2})$/,
					"alertText": "Wählen Sie das Datum aus dem Kalender"
				},				
				"setTime":{
					"regex": /^(\d{2}):(\d{2}):(\d{2})$/,
					"alertText": "Wählen Sie aus der Zeit Picker"
				},
                "minSize": {
                    "regex": "none",
                    "alertText": "* Mindestens ",
                    "alertText2": " Zeichen benötigt"
                },
                "maxSize": {
                    "regex": "none",
                    "alertText": "* Maximal ",
                    "alertText2": " Zeichen erlaubt"
                },
                "min": {
                    "regex": "none",
                    "alertText": "* Mindeswert ist "
                },
                "max": {
                    "regex": "none",
                    "alertText": "* Maximalwert ist "
                },
                "past": {
                    "regex": "none",
                    "alertText": "* Datum vor "
                },
                "future": {
                    "regex": "none",
                    "alertText": "* DBitte wählen bis Datum größer oder gleich "
                },	
                "maxCheckbox": {
                    "regex": "none",
                    "alertText": "* Maximale Anzahl Markierungen überschritten"
                },
                "minCheckbox": {
                    "regex": "none",
                    "alertText": "* Bitte wählen Sie ",
                    "alertText2": " Optionen"
                },
                "equals": {
                    "regex": "none",
                    "alertText": "* Felder stimmen nicht überein"
                },
                "phone": {
                    // credit: jquery.h5validate.js / orefalo
                    "regex": /^([\+][0-9]{1,3}[ \.\-])?([\(]{1}[0-9]{2,6}[\)])?([0-9 \.\-\/]{3,20})((x|ext|extension)[ ]?[0-9]{1,4})?$/,
                    "alertText": "* Ungültige Telefonnummer"
                },
                "email": {
                    // Simplified, was not working in the Iphone browser
                    "regex": /^([A-Za-z0-9_\-\.\'])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,6})$/,
                    "alertText": "* Ungültige E-Mail Adresse"
                },
                "integer": {
                    "regex": /^[\-\+]?\d+$/,
                    "alertText": "* Keine gültige Ganzzahl"
                },
                "number": {
                    // Number, including positive, negative, and floating decimal. credit: orefalo
                    "regex": /((^[1-9]([0-9]{0,2})([\.]([1-9]{1,1}[0-9]{0,1}))?)$|(^[1-9]([0-9]{0,2})([\.](0{1,2}))?)$|(^[0-9]([\.])([1-9]{1,1}[0-9]{0,1}))$)/,
                    "alertText": "* Ungültige Zeichen Eintrag (z. B. 1, 1,25 usw.)"
                },
                "date": {
                    // Date in ISO format. Credit: bassistance
                    "regex": /^\d{4}[\/\-]\d{1,2}[\/\-]\d{1,2}$/,
                    "alertText": "* Ungültiges Datumsformat, erwartet wird das Format JJJJ-MM-TT"
                },
                "ipv4": {
                	"regex": /^((([01]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))[.]){3}(([0-1]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))$/,
                    "alertText": "* Ungültige IP Adresse"
                },
                "url": {
                    "regex": /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/,
                    "alertText": "* Ungültige URL"
                },
                "onlyNumberSp": {
                    "regex": /^[0-9\ ]+$/,
                    "alertText": "* Nur Zahlen erlaubt"
                },
                "onlyLetterSp": {
                    "regex": /^[a-zA-Z\ \']+$/,
                    "alertText": "* Nur Buchstaben erlaubt"
                },
                "onlyLetterNumber": {
                    "regex": /^[0-9a-zA-Z]+$/,
                    "alertText": "* Keine Sonderzeichen erlaubt"
                },
				"onlyUnderscoreSp": {
                    "regex": /_+/,
                    "alertText": "* Fügen Sie _ für Leerzeichen"
                },
                "hasnumber": {
                    "regex": /^([\+-]|\d|[a-zA-Z]|\(|\$)([\+-]?|[a-zA-Z]*[\+-]?\d*[a-zA-Z]*[\+-]?|\d*\s?|\d*\:?\d{0,2}\s?|\d*\.?\d*\s?|\s?[a-zA-Z]*[\+-]?\d*\)*\(*)(\d|[a-zA-Z]*[\+-]?\d*\)|[a-zA-Z]*\/?[a-zA-Z]*|[a,p,A,P]{0,1}\.?[m,M]{0,1}\.?|\d*[a-zA-Z])$/,
                    "alertText": "* Ungültige numerische Eingabe"
                },
                // --- CUSTOM RULES -- Those are specific to the demos, they can be removed or changed to your likings
                "ajaxUserCall": {
                    "url": "ajaxValidateFieldUser",
                    // you may want to pass extra data on the ajax call
                    "extraData": "name=eric",
                    "alertText": "* Dieser Benutzer ist bereits vergeben",
                    "alertTextLoad": "* Überprüfe Angaben, bitte warten"
                },
                "ajaxNameCall": {
                    // remote json service location
                    "url": "ajaxValidateFieldName",
                    // error
                    "alertText": "* Dieser Name ist bereits vergeben",
                    // if you provide an "alertTextOk", it will show as a green prompt when the field validates
                    "alertTextOk": "* Dieser Name ist verfügbar",
                    // speaks by itself
                    "alertTextLoad": "* Überprüfe Angaben, bitte warten"
                },
                "validate2fields": {
                    "alertText": "* Bitte geben Sie HALLO"
                },
			    "whitespace": {
                    "alertText": "* Eingabe erforderlich"
                },
			    "maxMark": {
                    "alertText": "* Mark sollte nicht mehr als Fragezeichen"
                },				
				"hostname": {
					"regex": /^[A-Za-z0-9\_\-\.\:]+$/,
                    "alertText": "* Eingabe erforderlich,Geben Sie den Hostnamen nur"
                },
                "examName": {
                	"regex": /^[\w\s-]+$/,
                    "alertText": "* Ungültige Exam Name"
                },
                "examCode": {
                	"regex": /^[\w\s-]+$/,
                    "alertText": "* Ungültige Prüfungscode"
                }				
            };
            
        }
    };
    $.validationEngineLanguage.newLang();
})(jQuery);


    
