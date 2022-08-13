class MeetingsController < ApplicationController
  protect_from_forgery except: [:index]
  def index
    @params1=paramswithactions
    @params2= paramswithoutactions
    @params3= paramswithoutformorder
    @cities=City.all
    @countries=Country.all
    @members=Member.findwithparams(*[:form_sexe, :form_couple, :form_departement, :form_pays, :form_ville, :form_agemin, :form_agemax, :form_aime, :form_avatar_perso, :form_bahut, :form_order, :results,:nb2].map{|h|params[h]}) rescue nil
   p @members
  end
  private
  def paramswithactions
    params.permit(:form_sexe, :form_couple, :form_departement, :form_pays, :form_ville, :form_agemin, :form_agemax, :form_aime, :form_avatar_perso, :form_bahut, :form_order, :actions, :results,:nb2)
  end
  def paramswithoutactions
    params.permit(:form_sexe, :form_couple, :form_departement, :form_pays, :form_ville, :form_agemin, :form_agemax, :form_aime, :form_avatar_perso, :form_bahut, :form_order, :results,:nb2)
  end
  def paramswithoutformorder
    params.permit(:form_sexe, :form_couple, :form_departement, :form_pays, :form_ville, :form_agemin, :form_agemax, :form_aime, :form_avatar_perso, :form_bahut, :results,:actions,:nb2)
  end
end
