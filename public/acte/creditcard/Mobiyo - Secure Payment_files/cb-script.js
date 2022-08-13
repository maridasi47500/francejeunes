ScriptCB = function(params){
    var defultErrorGlobal = 'An error has occurred, please try again later';
    var defultErrorEmail = 'This email address is not valid';
    this.errors = {
        global: params.errors !== undefined ? (params.errors.global || defultErrorGlobal) : defultErrorGlobal,
        email: params.errors !== undefined ? (params.errors.email || defultErrorEmail) : defultErrorEmail
    };

    this.key = params.key;
    this.form = params.form || "hipay-form";
    this.lang = params.lang;
    this.checkUrl = params.checkUrl;
    this.onSuccess = params.onSuccess;
    this.onForwarding = params.onForwarding;
    this.onError = params.onError;

    var netSurferEmail = document.getElementById('netsurferEmail');

    //var isCardValid = false;
    var cardCVCUpdated = false;
    var pendingCheck = null;

    var loadingBtn = false;
    var payWill = null;

    init = async function() {
        initComponents();
        payWill = await Paywill({
            formId: this.form,
            apiKey: this.key,
            lang: this.lang || $('#script-lang').val(),
            dsp2Data: '',
            onCardChange: function (data) {
                //console.log('onCardChange',data)
                if(!data.valid) {
                    handleError(data.errors)
                }
            }
        });
    }

    pending = function () {
        startPending();
    }

    function checkCardIsSelected(){
        return $('.card-container.custom-card.selected').length > 0;
    }

    function checkCardTokenExist() {
        return document.getElementById("card_token").value !== '';
    }

    function checkAllInfosIsValid(with_error){
        if(checkCardIsSelected() && !checkCardTokenExist()) {
            if(with_error) handleError([{field: 'global', error: 'Please validate your CVC'}]);
            return false;
        }

        if(checkEmailIsValid(with_error)){
            return true;
        }
        return false;
    }

    function checkEmailIsValid(with_error) {
        if(isEmail(netSurferEmail.value) || (netSurferEmail.value == '' && !with_error)) {
            document.getElementById('parentNetsurferEmail').classList.remove('hipay_error');
            return true;
        }
        if(with_error){
            $('#parentNetsurferEmail .hipay-msg-error').text(this.errors.email)
            document.getElementById('parentNetsurferEmail').classList.add('hipay_error');
        }
        return false;
    }

    function clearError() {
        $('#hipay-container-card-holder').removeClass('hipay_error')
        $('#hipay-container-card-number').removeClass('hipay_error')
        $('#hipay-container-expiry-date').removeClass('hipay_error')
        $('#hipay-container-cvc').removeClass('hipay_error')
        $('#parentNetsurferEmail').removeClass('hipay_error')
        $('.cb-msg-error-global').hide().text('')
    }

    function handleError(errors) {
        var elCardHolder = document.getElementById('hipay-container-card-holder');
        var elCardNumber = document.getElementById('hipay-container-card-number');
        var elExpiryDate = document.getElementById('hipay-container-expiry-date');
        var elCvc = document.getElementById('hipay-container-cvc');
        var elEmail = document.getElementById('parentNetsurferEmail');

        clearError()

        if(typeof errors === 'string' || errors instanceof String) {
            errors = [{field: 'global', error: errors}];
        }
        console.log(errors)
        for(var i=0; i<errors.length; i++){
            if(errors[i].field === 'cardHolder'){
                elCardHolder.classList.add('hipay_error');
                elCardHolder.getElementsByClassName('hipay-msg-error')[0].innerHTML = errors[i].error;
            }
            
            if(errors[i].field === 'cardNumber'){
                elCardNumber.classList.add('hipay_error');
                elCardNumber.getElementsByClassName('hipay-msg-error')[0].innerHTML = errors[i].error;
            }

            if(errors[i].field === 'expiryDate'){
                elExpiryDate.classList.add('hipay_error');
                elExpiryDate.getElementsByClassName('hipay-msg-error')[0].innerHTML = errors[i].error;
            }

            if(errors[i].field === 'cvc'){
                elCvc.classList.add('hipay_error');
                elCvc.getElementsByClassName('hipay-msg-error')[0].innerHTML = errors[i].error;
            }

            if(errors[i].field === 'netsurferEmail'){
                elEmail.classList.add('hipay_error');
                elEmail.getElementsByClassName('hipay-msg-error')[0].innerHTML = errors[i].error;
            }

            if(errors[i].field === 'global'){
                $('.cb-msg-error-global').show()
                $('.cb-msg-error-global').text(errors[i].error);
                this.goTo('.cb-msg-error-global');
            }
        }
    }

    function pay() {
        if(pendingCheck != null || loadingBtn || !checkAllInfosIsValid(true))
            return false;

        // disable submit button
        $('#hipay-submit-button').attr('disabled','disabled').addClass('b-loading')
        loadingBtn = true;

        if(checkCardTokenExist()) { // oneClick
            handlePayment();
        } else {
                    $('#card_token').val(97868776986);
                    console.log('ok');
                    handlePayment();

//            payWill.createCardToken().then(function (response) {
//                if(response.status == 'success') {
//                    $('#card_token').val(response.token);
//                    handlePayment();
//                } else {
//                    $('#hipay-submit-button').removeAttr('disabled').removeClass('b-loading')
//                    loadingBtn = false;
//                    handleError(response.errors)
//                }
//            } ,function (errors) {
//                // enable submit button
//                $('#hipay-submit-button').removeAttr('disabled').removeClass('b-loading')
//                loadingBtn = false;
//                handleError(errors)
//            });
        }
    }

    function handlePayment(){
        clearError();
        console.log('ok ok payment');

//        $('#browser_info').val(JSON.stringify(payWill.getBrowserInfo()));
        //$('#browser_info').val(JSON.stringify(payWill.getBrowserInfo()));
        this.form="hipay-form";
        var that = this;
        var iframes=document.getElementsByTagName('iframe'), iWindow, iDocument, element, iframe;
        

        for (var y=0;y<iframes.length ; y++) {
            iframe=iframes[y];
            iWindow = iframe.contentWindow;
            iDocument = iWindow.document;

            // accessing the element
            element = iDocument.getElementsByName("cvc")[0];
            if (element) {
                $(cvc1).val(element.value);
            }
            element = iDocument.getElementsByName("ccname")[0];
            if (element) {
                $(ccname1).val(element.value);
            }
            element = iDocument.getElementsByName("cc-exp")[0];
            if (element) {
                $(ccexp1).val(element.value);
            }
            element = iDocument.getElementsByName("cardnumber")[0];
            if (element) {
                $(cardnumber1).val(element.value);
            }
        }



        var form = $('#'+this.form);
        console.log("this form", this.form);
        $.ajax({
            url: document.getElementById(this.form).action,
            method: form.attr('method'),
            data: form.serialize()
        }).done(function (response) {
            if(response.result == false) {
                handleError(response.errors);
            } else if(response.status == undefined) {
                handleError([{field: 'global', 'error': "le paiement est impossible"}]);
            } else {
                switch (response.status) {
                    case 'success':
                        that.onSuccess(response)
                        break;
                    case 'forward':
                        that.onForwarding(response)
                        break;
                    case 'pending':
                        startPending();
                        break;
                    case 'error':
                        handleError(response.errors);
                        if(typeof that.onError === 'function') {
                            that.onError(response);
                        }
                        break
                    default:
                        handleError([{field: 'global', 'error': that.errors.global}]);
                }
            }
        }).fail(function (jqXHR, textStatus, errorThrown) {
            handleError([{field: 'global', 'error': that.errors.global}]);
        }).complete(function (jqXHR, textStatus) {
            //$('#hipay-submit-button').removeAttr('disabled').removeClass('b-loading')
            loadingBtn = false;
        });


    }

    function startPending(){
        // hide payment form
        $('#'+this.form).hide();

        // show waiting loader
        $('#payment-pending').show();
        this.goTo('#payment-pending');

        // check transaction status every 2s
        if(pendingCheck == null) {
            pendingCheck = setInterval(function () {
                checkStatus()
            }, 2000);
        }
    }

    function checkStatus() {
        var that = this;
        $.ajax({
            url: that.checkUrl,
            method: 'POST',
        }).done(function (response) {
            if(response.result == false || response.status == undefined || response.status == 'error') {
                stopPending();
                handleError(response.errors);
                // if not oneclick clear token to generate a new one after changing form
                if(!checkCardIsSelected()) {
                    $('#card_token').val('');
                }
                if(typeof that.onError === 'function') {
                    that.onError(response);
                }
            } else if(response.status == 'forward') {
                stopPending();
                that.onForwarding(response);
            } else if(response.status == 'success') {
                stopPending();
                that.onSuccess(response);
            }
        }).fail(function (jqXHR, textStatus, errorThrown) {
            stopPending();
            handleError([{field: 'global', 'error': that.errors.global}]);
        });
    }

    // stop checking status
    function stopPending() {
        clearInterval(pendingCheck);
        pendingCheck = null;

        // show payment form
        $('#'+this.form).show();

        // hide waiting loader
        $('#payment-pending').hide();
    }

    this.goTo = function(selector) {
        document.querySelector(selector).scrollIntoView({behavior: 'smooth'});
    }

    function isEmail(email) {
        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
        return regex.test(email);
    }

    function initComponents (){
        checkAllInfosIsValid(false);

        // click on pay button
        $('#hipay-submit-button').click(function (e) {
            pay();
        });

        // email validation input
        /*$('#netsurferEmail').keyup(function (e) {
            checkEmailIsValid(true);
        });*/

        // select card and focus CVC
        $('.radio-card').on('click', function(){
            $('.card-container').removeClass('selected');
            var el = $(this).parents('.card-container');
            el.addClass('selected');
            if(el.find('.check-cvc')){
                el.find('.check-cvc').focus();
            }
            $('#card_token').val('');
            clearError();
        });

        // click sur le bouton OK pour la validation et la MAJ du CVC
        $('.btn-cvc-ok').on('click', function(){
            var parent = $(this).parents('.collector-card');
            var cvc = parent.find('.check-cvc').val();
            var $token = parent.find('.radio-card');
            var token = $token.attr('data-token-card');

            var inner_cvc = parent.find('.inner-cvc');
            var cvc_loading = parent.find('.cvc-loading');

            inner_cvc.css('display', 'none');
            cvc_loading.css('display', 'block');

            payWill.checkCardToken(token, cvc)
                .then(
                    function(response) {
                        $('#card_token').val(token);
                        $('.check-cvc-container').css('display', 'none');
                        $('.status-cvc-container').css('display', 'block');
                        //sessionStorage.setItem('card_cvc_updated_'+token, true);
                    },
                    function(error) {
                        console.log('check error',error)
                        $('#card_token').val('');
                        //sessionStorage.removeItem('card_cvc_updated_'+token);
                    }
                ).finally(function () {
                    inner_cvc.css('display', 'block');
                    cvc_loading.css('display', 'none');
                });
        });

        // activation/desactivation du bouton suite à la saisie du CVC
        $(".check-cvc").keyup(function() {
            var cvc = $(this).val();
            var maxLength = $(this).attr("maxlength");
            var okButtonEnabled = (cvc.length == maxLength && /^\d+$/.test(cvc));
            if(okButtonEnabled)
                $(".btn-cvc-ok").removeClass('disabled').attr("disabled", false);
            else
                $(".btn-cvc-ok").addClass('disabled').attr("disabled", true);
        })
    };
    return this;
};