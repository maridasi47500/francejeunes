function Provider(adapter) {
    this.adapter = adapter
}

//https://developer.hipay.com/online-payments/sdk-reference/sdk-js
var HipayAdapter = {
    init: function (env, login, passw, lang, onCardChange) {
        this.env = env
        this.login = login
        this.passw = passw
        this.lang = lang
        this.onCardChange = onCardChange
        var _this = this

        return new Promise((resolve, reject) => {
            var script = document.createElement('script') // create a script DOM node
            script.src = 'https://libs.hipay.com/js/sdkjs.js' // set its src to the provided URL
            document.head.appendChild(script)
            script.onload = function () {
                resolve(_this.loadProviderForm())
            }
            script.onerror = function () {
                reject(console.error('Failed loading Hipay libs'))
            }
        })
    },

    loadProviderForm: function () {
        var _this = this

        return new Promise((resolve, reject) => {
            //Adapt DOM to match Hipay requirements
            var cardHolderElem = document.querySelector("[data-paywill='cardHolder']")
            if (!cardHolderElem.id) cardHolderElem.setAttribute('id', 'paywill-cardHolder')
            var cardNumberElem = document.querySelector("[data-paywill='cardNumber']")
            if (!cardNumberElem.id) cardNumberElem.setAttribute('id', 'paywill-cardNumber')
            var cardExpiryDateElem = document.querySelector("[data-paywill='cardExpiryDate']")
            if (!cardExpiryDateElem.id) cardExpiryDateElem.setAttribute('id', 'paywill-cardExpiryDate')
            var cardCVCElem = document.querySelector("[data-paywill='cardCVC']")
            if (!cardCVCElem.id) cardCVCElem.setAttribute('id', 'paywill-cardCVC')

            //Hipay JS public credentials
            var hipay = HiPay({ username: this.login, password: this.passw, environment: this.env, lang: this.lang })

            this.hipay = hipay

            var options = {
                multi_use: true,
                fields: {
                    cardHolder: {
                        selector: cardHolderElem.id, // card holder div id
                        uppercase: true,
                    },
                    cardNumber: {
                        selector: cardNumberElem.id, // card number div id
                    },
                    expiryDate: {
                        selector: cardExpiryDateElem.id, // expiry date div id
                    },
                    cvc: {
                        selector: cardCVCElem.id, // cvc div id
                        helpSelector: 'paywill-help-cvc',
                    },
                },
                //base paywill styles
                styles: {
                    base: {
                        color: '#000000',
                        fontSize: '15px',
                        fontFamily: 'Roboto',
                        fontWeight: 400,
                        placeholderColor: '#999999',
                        iconColor: '#00ADE9',
                        caretColor: '#00ADE9',
                    },
                    invalid: {
                        color: '#D50000',
                        caretColor: '#D50000',
                    },
                },
            }

            var cardInstance = hipay.create('card', options)
            this.cardInstance = cardInstance
            this.cardInstance.browser_info = hipay.getBrowserInfo()
            console.log(this.cardInstance)
            cardInstance.on('change', function (data) {
                _this.onCardChange(data)
                _this.handleError(data.valid, data.error)
                resolve(data)
            })
        })
    },

    handleError: function (valid, error) {
        document.getElementById('paywill-error-message').innerHTML = error
            ? '<i class="material-icons">cancel</i>' + error
            : error
        document.querySelector("[data-paywill='cardSubmit']").disabled = !valid
    },

    tokenise: function () {
        return this.cardInstance.getPaymentData().then(function (result) {
            let cardInfo = {
                token: result.token,
                expiration_date: result.card_expiry_year + '-' + result.card_expiry_month,
                owner_name: result.card_holder,
                pan: result.pan,
                bank_name: result.issuer || '',
                country: result.country,
                brand: result.brand,
            }

            if (this.dsp2data_customer && this.dsp2data_customer != '') {
                this.dsp2data_customer.browser_info = result.browser_info
                cardInfo.dsp2Data = this.dsp2data_customer
            }
            console.log(cardInfo)
            return cardInfo
        })
    },

    checkToken: async function (token, cvc, ce_month, ce_year, ch) {
        return this.hipay
            .updateToken({
                request_id: 0,
                card_token: token,
                card_expiry_month: ce_month,
                card_expiry_year: ce_year,
                card_holder: ch,
                cvc: cvc,
            })
            .then(
                function (response) {
                    return response
                },
                function (error) {
                    console.log(error)
                }
            )
    },
    getBrowserInfo: function () {        
        return this.hipay.getBrowserInfo()            
    },
}

var Paywill = function (p) {
    this.formId = p.formId
    this.apiKey = p.apiKey
    this.environment
    this.onFormSubmit = p.onFormSubmit
    this.lang = p.lang
    this.dsp2data_customer = p.dsp2Data != '' ? p.dsp2Data : ''
    this.adapter
    this.publicLogin
    this.publicPassw
    this.provider
    this.providerAccountId
    this.onCardChange = p.onCardChange

    this.Init = function () {
        //Callback on button click event
        document.querySelector("[data-paywill='cardSubmit']").addEventListener('click', function () {
            _this.onFormSubmit()
        })

        //Get PSP infos & Init paywill vars
        return fetch('https://gateway.paywill.io/getpublictokens?apikey=' + _this.apiKey, {
            method: 'GET',
            mode: 'cors',
        })
            .then((response) => response.json())
            .then((response) => {
                _this.adapter = response.providerName // Hipay|Stripe|...
                _this.publicLogin = response.publicLogin
                _this.publicPassw = response.publicPassword
                _this.providerAccountId = response.providerAccountId
                _this.environment = response.environment //stage|prod
                _this.provider = new Provider(this[_this.adapter + 'Adapter'])
                return _this.provider.adapter.init(
                    _this.environment,
                    _this.publicLogin,
                    _this.publicPassw,
                    _this.lang,
                    _this.onCardChange
                )
            })
            .then((response) => {
                return _this //Return paywill object
            })
            .catch((error) => {
                console.log(error)
            })
    }

    this.createCardToken = function () {
        return _this.provider.adapter
            .tokenise()
            .then(function (response) {
                //ajouter les info dsp2 ici
                console.log(response)
                response.providerAccountId = _this.providerAccountId //add providerAccountId to psp token datas
                return fetch('https://gateway.paywill.io/savePSPToken', {
                    method: 'POST',
                    mode: 'cors',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(response),
                })
            })
            .then((response) => response.json())
            .then(function (response) {
                return {
                    status: 'success',
                    token: response.cardId,
                }
            })
            .catch(function (error) {
                return {
                    status: 'error',
                    errors: error,
                }
            })
    }

    // Update provider token and retrieve the id paywill cardToken
    this.checkCardToken = function (paywillToken, cvc) {
        // get provider token from paywill one
        return fetch('https://gateway.paywill.io/getPSPToken', {
            method: 'POST',
            mode: 'cors',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ paywilltoken: paywillToken }),
        })
            .then((response) => response.json())
            .then((response) => {
                return _this.provider.adapter.checkToken(
                    response.token,
                    cvc,
                    response.ce_month,
                    response.ce_year,
                    response.ch
                )
            })
    }

    this.getBrowserInfo = function () {
        if (this.dsp2data_customer != '') {
            this.dsp2data_customer.browser_info = _this.provider.adapter.getBrowserInfo() 
            return dsp2data_customer
        }
        return _this.provider.adapter.getBrowserInfo()
    }

    var _this = this
    return this.Init()
}
