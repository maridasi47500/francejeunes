# frozen_string_literal: true

class Members::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  protect_from_forgery except: [:create,:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
 def create
  @u=Member.new(member_params)
  if @u.save
    bypass_sign_in(@u)
    render :create
  else
    render :new
  end
  end

  # GET /resource/edit
   def edit
     @member.form_sexe = @member.sex
   end

  # PUT /resource
 def update
  if @member.update(member_params)
    redirect_to memberzone_path
  end
 end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end
 def member_params
   params.permit(:aime,:image,:form_login,:form_mdp, :form_nom, :form_prenom, :form_email, :form_sexe, :form_naissance_jour, :form_naissance_mois, :form_naissance_annee, :form_ville, :form_pays,:photosmembre=>[],:alert_attributes=>{},:photos_attributes=>{})
 end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
