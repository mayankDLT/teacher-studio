(function($){
    $.fn.validationEngineLanguage = function(){
    };
    $.validationEngineLanguage = {
        newLang: function(){
            $.validationEngineLanguage.allRules = {
                "required": { // Add your regex rules here, you can take telephone as an example
                    "regex": "none",
                    "alertText": "* 此字段是必需的",
                    "alertTextCheckboxMultiple": "* 請選擇一個選項",
                    "alertTextCheckboxe": "* 此複選框"
                },
			    "dateTime":{
					"regex": /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/,
					"alertText": "從日曆中選擇"
				},
			    "dateOnly":{
					"regex": /^(\d{4})-(\d{2})-(\d{2})$/,
					"alertText": "從日曆中選擇日期"
				},				
				"setTime":{
					"regex": /^(\d{2}):(\d{2}):(\d{2})$/,
					"alertText": "從時間選擇器中選擇"
				},				
                "minSize": {
                    "regex": "none",
                    "alertText": "* 最低限度 ",
                    "alertText2": " 允許的字符"
                },
                "maxSize": {
                    "regex": "none",
                    "alertText": "* 最大 ",
                    "alertText2": " 允許的字符"
                },
                "min": {
                    "regex": "none",
                    "alertText": "* 最低值 "
                },
                "max": {
                    "regex": "none",
                    "alertText": "* 最大值 "
                },
                "past": {
                    "regex": "none",
                    "alertText": "* 日期前 "
                },
                "future": {
                    "regex": "none",
                    "alertText": "* 請選擇日期大於或等於 "
                },	
                "maxCheckbox": {
                    "regex": "none",
                    "alertText": "* 檢查允許超出"
                },
                "minCheckbox": {
                    "regex": "none",
                    "alertText": "* 請選擇 ",
                    "alertText2": " 選項"
                },
                "equals": {
                    "regex": "none",
                    "alertText": "* 字段不匹配"
                },
                "phone": {
                    // credit: jquery.h5validate.js / orefalo
                    "regex": /^([\+][0-9]{1,3}[ \.\-])?([\(]{1}[0-9]{2,6}[\)])?([0-9 \.\-\/]{3,20})((x|ext|extension)[ ]?[0-9]{1,4})?$/,
                    "alertText": "* 無效的電話號碼"
                },
                "email": {
                    // Simplified, was not working in the Iphone browser
                    "regex": /^([A-Za-z0-9_\-\.\'])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,6})$/,
                    "alertText": "* 電子郵件地址無效"
                },
                "integer": {
                    "regex": /^[\-\+]?\d+$/,
                    "alertText": "* 不是一個有效的整數"
                },
                "number": {
                    // Number, including positive, negative, and floating decimal. credit: orefalo
                    "regex": /((^[1-9]([0-9]{0,2})([\.]([1-9]{1,1}[0-9]{0,1}))?)$|(^[1-9]([0-9]{0,2})([\.](0{1,2}))?)$|(^[0-9]([\.])([1-9]{1,1}[0-9]{0,1}))$)/,
                    "alertText": "* 無效的標誌條目（例如，1，1.25等。）"
                },
                "date": {
                    // Date in ISO format. Credit: bassistance
                    "regex": /^\d{4}[\/\-]\d{1,2}[\/\-]\d{1,2}$/,
                    "alertText": "* 無效的日期，一定要在YYYY-MM-DD格式"
                },
                "ipv4": {
                    "regex": /^((([01]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))[.]){3}(([0-1]?[0-9]{1,2})|(2[0-4][0-9])|(25[0-5]))$/,
                    "alertText": "* 無效的IP地址"
                },
                "url": {
                    "regex": /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/,
                    "alertText": "* 無效的URL"
                },
                "onlyNumberSp": {
                    "regex": /^[0-9\ ]+$/,
                    "alertText": "* 只有數字"
                },
                "onlyLetterSp": {
                    "regex": /^[a-zA-Z\ \']+$/,
                    "alertText": "* 字母只"
                },
				"onlyUnderscoreSp": {
                    "regex": /_+/,
                    "alertText": "* 添加空白_"
                },
                "onlyLetterNumber": {
                    "regex": /^[0-9a-zA-Z]+$/,
                    "alertText": "* 不允許特殊字符"
                },
                "hasnumber": {
                    "regex": /^([\+-]|\d|[a-zA-Z]|\(|\$)([\+-]?|[a-zA-Z]*[\+-]?\d*[a-zA-Z]*[\+-]?|\d*\s?|\d*\:?\d{0,2}\s?|\d*\.?\d*\s?|\s?[a-zA-Z]*[\+-]?\d*\)*\(*)(\d|[a-zA-Z]*[\+-]?\d*\)|[a-zA-Z]*\/?[a-zA-Z]*|[a,p,A,P]{0,1}\.?[m,M]{0,1}\.?|\d*[a-zA-Z])$/,
                    "alertText": "* 无效的输入数值"
                },
                // --- CUSTOM RULES -- Those are specific to the demos, they can be removed or changed to your likings
                "ajaxUserCall": {
                    "url": "ajaxValidateFieldUser",
                    // you may want to pass extra data on the ajax call
                    "extraData": "name=eric",
                    "alertText": "* 此用戶已",
                    "alertTextLoad": "* 驗證中，請稍候"
                },
                "ajaxNameCall": {
                    // remote json service location
                    "url": "ajaxValidateFieldName",
                    // error
                    "alertText": "* 該名稱已被使用",
                    // if you provide an "alertTextOk", it will show as a green prompt when the field validates
                    "alertTextOk": "* 這個名字是",
                    // speaks by itself
                    "alertTextLoad": "* 驗證中，請稍候"
                },
                "validate2fields": {
                    "alertText": "* 請輸入HELLO"
                },
			    "whitespace": {
                    "alertText": "* 輸入需要"
                },
			    "maxMark": {
                    "alertText": "* 馬克不應超過問號"
                },				
				"hostname": {
					"regex": /^[A-Za-z0-9\_\-\.\:]+$/,
                    "alertText": "* 需要輸入，只輸入主機名"
                },
                "examName": {
                	"regex": /^[\w\s-]+$/,
                    "alertText": "* 考試名稱無效"
                },
                "examCode": {
                	"regex": /^[\w\s-]+$/,
                    "alertText": "* 考試代碼無效"
                }
            };
            
        }
    };
    $.validationEngineLanguage.newLang();
})(jQuery);
