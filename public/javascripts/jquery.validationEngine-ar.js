(function($){
    $.fn.validationEngineLanguage = function(){
    };
    $.validationEngineLanguage = {
        newLang: function(){
            $.validationEngineLanguage.allRules = {
                "required": { // Add your regex rules here, you can take telephone as an example
                    "regex": "none",
                    "alertText": "* هذا الحقل مطلوب",
                    "alertTextCheckboxMultiple": "* الرجاء تحديد خيار",
                    "alertTextCheckboxe": "* مطلوب هذا الاختيار"
                },
			    "dateTime":{
					"regex": /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/,
					"alertText": "حدد من التقويم"
				},
			    "dateOnly":{
					"regex": /^(\d{4})-(\d{2})-(\d{2})$/,
					"alertText": "حدد تاريخ من التقويم"
				},				
				"setTime":{
					"regex": /^(\d{2}):(\d{2}):(\d{2})$/,
					"alertText": "اختر من منتقي وقت"
				},				
                "minSize": {
                    "regex": "none",
                    "alertText": "* الحد الأدنى ",
                    "alertText2": " الأحرف المسموح بها"
                },
                "maxSize": {
                    "regex": "none",
                    "alertText": "* أقصى ",
                    "alertText2": " الأحرف المسموح بها"
                },
                "min": {
                    "regex": "none",
                    "alertText": "* قيمة الحد الأدنى هو "
                },
                "max": {
                    "regex": "none",
                    "alertText": "* أقصى قيمة "
                },
                "past": {
                    "regex": "none",
                    "alertText": "* تاريخ قبل "
                },
                "future": {
                    "regex": "none",
                    "alertText": "* الرجاء اختيار إلى تاريخ أكبر من أو يساوي "
                },	
                "maxCheckbox": {
                    "regex": "none",
                    "alertText": "* يسمح تجاوز الشيكات"
                },
                "minCheckbox": {
                    "regex": "none",
                    "alertText": "* الرجاء اختيار ",
                    "alertText2": " خيارات"
                },
                "equals": {
                    "regex": "none",
                    "alertText": "* الحقول لا تتطابق"
                },
                "phone": {
                    // credit: jquery.h5validate.js / orefalo
                    "regex": /^([\+][0-9]{1,3}[ \.\-])?([\(]{1}[0-9]{2,6}[\)])?([0-9 \.\-\/]{3,20})((x|ext|extension)[ ]?[0-9]{1,4})?$/,
                    "alertText": "* رقم الهاتف غير صالح"
                },
                "email": {
                    // Simplified, was not working in the Iphone browser
                    "regex": /^([A-Za-z0-9_\-\.\'])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,6})$/,
                    "alertText": "* عنوان البريد الإلكتروني غير صالح"
                },
                "integer": {
                    "regex": /^[\-\+]?\d+$/,
                    "alertText": "* ليس صحيحا صالحة"
                },
                "number": {
                    // Number, including positive, negative, and floating decimal. credit: orefalo
                    "regex": /((^[1-9]([0-9]{0,2})([\.]([1-9]{1,1}[0-9]{0,1}))?)$|(^[1-9]([0-9]{0,2})([\.](0{1,2}))?)$|(^[0-9]([\.])([1-9]{1,1}[0-9]{0,1}))$)/,
                    "alertText": "* (.دخول غير صالحة علامة (على سبيل المثال 1، 1.25 إلخ"
                },
                "date": {
                    // Date in ISO format. Credit: bassistance
                    "regex": /^\d{4}[\/\-]\d{1,2}[\/\-]\d{1,2}$/,
                    "alertText": "* تاريخ غير صالحة، يجب أن تكون في YYYY-MM-DD تنسيق"
                },
                "ipv4": {
                    "regex": /^((([01]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))[.]){3}(([0-1]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))$/,
                    "alertText": "* عنوان IP غير صالح"
                },
                "url": {
                    "regex": /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/,
                    "alertText": "* URL غير صالح"
                },
                "onlyNumberSp": {
                    "regex": /^[0-9\ ]+$/,
                    "alertText": "* أرقام فقط"
                },
                "onlyLetterSp": {
                    "regex": /^[a-zA-Z\ \']+$/,
                    "alertText": "* رسائل فقط"
                },
				"onlyUnderscoreSp": {
                    "regex": /_+/,
                    "alertText": "* إضافة ل_ فارغة"
                },
                "onlyLetterNumber": {
                    "regex": /^[0-9a-zA-Z]+$/,
                    "alertText": "* لا يسمح أحرف خاصة"
                },
                "hasnumber": {
                    "regex": /^([\+-]|\d|[a-zA-Z]|\(|\$)([\+-]?|[a-zA-Z]*[\+-]?\d*[a-zA-Z]*[\+-]?|\d*\s?|\d*\:?\d{0,2}\s?|\d*\.?\d*\s?|\s?[a-zA-Z]*[\+-]?\d*\)*\(*)(\d|[a-zA-Z]*[\+-]?\d*\)|[a-zA-Z]*\/?[a-zA-Z]*|[a,p,A,P]{0,1}\.?[m,M]{0,1}\.?|\d*[a-zA-Z])$/,
                    "alertText": "* صالح دخول العددية"
                },
                // --- CUSTOM RULES -- Those are specific to the demos, they can be removed or changed to your likings
                "ajaxUserCall": {
                    "url": "ajaxValidateFieldUser",
                    // you may want to pass extra data on the ajax call
                    "extraData": "name=eric",
                    "alertText": "* واتخذت بالفعل هذا المستخدم",
                    "alertTextLoad": "* التحقق من صحة، يرجى الانتظار"
                },
                "ajaxNameCall": {
                    // remote json service location
                    "url": "ajaxValidateFieldName",
                    // error
                    "alertText": "* واتخذت بالفعل هذا الاسم",
                    // if you provide an "alertTextOk", it will show as a green prompt when the field validates
                    "alertTextOk": "* هذا الاسم متاح",
                    // speaks by itself
                    "alertTextLoad": "* التحقق من صحة، يرجى الانتظار"
                },
                "validate2fields": {
                    "alertText": "* الرجاء إدخال مرحبا"
                },
			    "whitespace": {
                    "alertText": "* المدخلات المطلوبة"
                },
			    "maxMark": {
                    "alertText": "* وينبغي ألا يتجاوز علامة علامة الاستفهام"
                },				
				"hostname": {
					"regex": /^[A-Za-z0-9\_\-\.\:]+$/,
                    "alertText": "* المدخلات المطلوبة، أدخل اسم المضيف فقط"
                },
                "examName": {
                	"regex": /^[\w\s-]+$/,
                    "alertText": "* غير صالحة الامتحان الاسم"
                },
                "examCode": {
                	"regex": /^[\w\s-]+$/,
                    "alertText": "* كود امتحان غير صالحة"
                }
            };
            
        }
    };
    $.validationEngineLanguage.newLang();
})(jQuery);
