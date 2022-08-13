class MyParamConstraint
  def initialize(param1)
    @key = param1
  end

  def matches?(req)
    req.env["devise.mapping"] = Devise.mappings[:user]
    req.parameters.keys.include?(@key)
  end
end
class TwoParamConstraint
  def initialize(param1,param2)
    @key = param1
    @key2 = param2
  end

  def matches?(req)
    req.env["devise.mapping"] = Devise.mappings[:user]
    req.parameters.keys.include?(@key) && req.parameters.keys.include?(@key2)
  end
end
class SomeParamConstraint
  def initialize(param1,value)
    @key = param1
    @value = value
  end

  def matches?(req)
    req.env["devise.mapping"] = Devise.mappings[:user]
    req.parameters.keys.include?(@key) && req.parameters[@key] == @value
  end
end
Rails.application.routes.draw do
  get "contact.php", to: "welcome#contactus"
  get "search.php", to: "welcome#search", as: :mysearch
  get "/link.php", to: "welcome#link"
  get "imprim-html.php", to: "articles#imprimhtml"
  get "imprim.php", to: "articles#imprim"
  delete "deletemessage", to: "articles#delete", as: :deletemessage
  get "discut_edit.php", to: "articles#edit", as: :discutedit
  get "show_ccard", to: "ultrazone#card"
  post "/acte/creditcard/purchase.apu", to: "ultrazone#mypayment", as: :ultrazonepaymentlang
  get "/acte/creditcard/purchase.apu", to: "ultrazone#payment", as: :ultrazonepayment
  get "/love.php", to: "welcome#love", as: :love
  get "/alertes.php", to: "articles#alert"
  get "/overview.php", to: "articles#overview", as: :overview
  post "newarticle1.php", to: "articles#newarticle", as: :newarticle
  get "publish.php", to: "articles#publish"
  get "/edit_discut_private.php", to: "welcome#editprivateforum", as: :editforumprive
  post "/new_discut_private.php", to: "welcome#newprivateforum", as: :newprivateforum
  patch "/update_discut_private.php", to: "welcome#updateprivateforum", as: :newprivateforum2
  get "/discut_private.php", to: "welcome#privateforum", as: :privateforum
  get "/messaging.php", to: "welcome#messaging"
  patch "/sendmessage.php", to: "welcome#sentmessage"
  get "/search.php", to: "welcome#search"
  get "/add.php", to: "welcome#photosmember", as: :photosmember
  post "/update_member.php", to: "welcome#updatemember", as: :updatemember
  get "/avatar.php", to: "welcome#avatar"
  get "ultra_sms.php", to: "ultrazone#sms"
  get "ultra.php", to: "ultrazone#ultra"
  get "shop.php", to: "welcome#shop"
  get "webeauty.php", to: "welcome#webeauty"
  get "ultrazone", to: "ultrazone#index"
  get "all.php", to: "welcome#photos", as: :photosmembre
  get "dedicaces.php", to: "welcome#dedicace", as: :dedicacemembre
  get "sendmessage.php", to: "welcome#contact", as: :contactmembre
  get "send.php", to: "welcome#sendmessage"
  post "meetings.php", to: "meetings#index"
  get "meetings.php", to: "meetings#index"
  get "/imgserv_view.php", to: "images#see", as: :seepic
  get "/imgmembre_view.php", to: "images#seemembre", as: :seeimagemembre
  patch "addimages", to: "images#sendimages", as: :addimages
  get "/imgserv_add.php", to: "images#add"
  get "photos-:title-:tid-0-:tid.htm", to: "images#cat"

  get "photos-:title-:tid-:tid2-:tid2.htm", to: "images#subcat"
  get "/imgserv.php", to: 'images#index'
  get 'paroles.php', to: "paroles#removelyrics", as: :removelyrics, constraints: MyParamConstraint.new('id')

  post "/newartist", to: "paroles#newartist", as: :new_artist
  get "/paroles_edit.php", to: "paroles#editasong", as: :editlyrics
  patch 'editsong.php', to: "paroles#editsong", as: :sendasong
  get 'paroles.php', to: "paroles#sendlyrics", as: :sendlyrics, constraints: MyParamConstraint.new('id')

  post 'song.php', to: "paroles#newsong", as: :new_song
  get 'paroles.php', to: "paroles#showartist", as: :showartist, constraints: MyParamConstraint.new('artiste')

  get "paroles-:artist-:title-:id.htm", to: "paroles#showlyrics", as: :showlyrics, :constraints  => {  :artist => /[0-z\.]+/, :title => /[0-z\.]+/ }
  get 'paroles.php', to: "paroles#succes", as: :succes_songs, constraints: SomeParamConstraint.new('actions', 'succes')
  get 'paroles.php', to: "paroles#bestof_ar", as: :bestof_ar, constraints: SomeParamConstraint.new('actions', 'bestof_ar')
  get 'paroles.php', to: "paroles#bestof", as: :bestof_songs, constraints: SomeParamConstraint.new('actions', 'bestof')
  get 'paroles.php', to: "paroles#new", as: :new_text, constraints: SomeParamConstraint.new('actions', 'new')
  get 'paroles.php', to: "paroles#delete", as: :delete_lyrics, constraints: SomeParamConstraint.new('actions', 'delete')
  get 'paroles.php', to: "paroles#sendd", as: :send_lyrics, constraints: SomeParamConstraint.new('actions', 'send')
  get 'paroles.php', to: "paroles#new_ar", as: :new_ar, constraints: SomeParamConstraint.new('actions', 'new_ar')
  get 'paroles_div.php', to: "paroles#actions"
  get 'paroles.php', to: "paroles#index", as: :paroles
  post "log.php", to: "articles#log", as: :logme
  get "/guiness.php", to: "articles#guiness"
      post "/forummessage.php", to: "forums#forummessage", constraints: MyParamConstraint.new('tid'), as: :reponseforum
  #get "discut.php", to: "forums#forumtype", constraints: TwoParamConstraint.new('tid', 'type_forum'), as: :mydiscussionbis

      get "/discut.php", to: "forums#show", constraints: MyParamConstraint.new('type_forum'), as: :showforum

    post "/message.php", to: "articles#answermessage", constraints: TwoParamConstraint.new('tid','tid2'), as: :savecommentarticle
    post "/message.php", to: "forums#message"
    post "/discut.php", to: "articles#loginarticle", constraints: TwoParamConstraint.new('tid','tid2'), as: :loginarticle
    get "/discut.php", to: "articles#answer", constraints: TwoParamConstraint.new('tid','tid2'), as: :answerarticle
    post "/discut.php", to: "forums#loginforum", constraints: TwoParamConstraint.new('tid','login')

  get "/lire-:title-:id.htm", to: "articles#show"
  get "view.php", to: "articles#member", constraints: MyParamConstraint.new('tid')
  post "/publish_wizard.php", to: "articles#endarticle", constraints: SomeParamConstraint.new('actions','end')
  get "/publish_wizard.php", to: "articles#endarticle", constraints: SomeParamConstraint.new('actions','end')

  post "creerparagraphe.html", to: "articles#creerparagraphe"
  get "paragraphe.html", to: "articles#paragraphe"
  post "/publish_wizard.php", to: "articles#corps", constraints: SomeParamConstraint.new('actions','corps')
  get "/publish_wizard.php", to: "articles#corps", constraints: SomeParamConstraint.new('actions','corps')
  get "/publish_wizard.php", to: "articles#description", constraints: SomeParamConstraint.new('actions','description')
  post "/publish_wizard.php", to: "articles#description", constraints: SomeParamConstraint.new('actions','description')
  post "/publish_wizard.php", to: "articles#images", constraints: SomeParamConstraint.new('actions','images')
  get "/publish_wizard.php", to: "articles#images", constraints: SomeParamConstraint.new('actions','images')
  get "/publish_wizard.php", to: "articles#titre", constraints: SomeParamConstraint.new('actions','titre')
  post "/publish_wizard.php", to: "articles#loginwizard"
  get "/publish_wizard.php", to: "articles#new", as: :publishwizard
  get "discut.php", to: "forums#forumtype", constraints: MyParamConstraint.new('tid'), as: :mydiscussion

  devise_scope :member do
    get "log.php", to: "members/sessions#new", as: :login
    get "members/log.php", to: "members/sessions#new", as: :loginmembers
    get "inscription.php", to: "members/registrations#new"
    get "members/inscription.php", to: "members/registrations#new", as: :inscriptionmembers
    post "/inscription.php", to: "members/registrations#create"
    patch "/inscription.php", to: "members/registrations#create"
    patch "/editinfos.php", to: "members/registrations#update"
    patch "/update_member.php", to: "members/registrations#update"
    patch "/update_member1.php", to: "members/registrations#update", as: :updatememb
     get 'members.php', to: "members/sessions#index", as: :memberzone
  get "/edit.php", to: "members/registrations#edit", as: :editmember


  end
  devise_for :members, controllers: {
    sessions: 'members/sessions',
    registrations: 'members/registrations',
    passwords: 'members/passwords'
  }
  get 'articles/rubrique'
  get "discut.php", to: "welcome#discut", as: :discut
  root to: 'welcome#index'
  get "rubrique-:title-:id.htm", to: "articles#rubrique"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
