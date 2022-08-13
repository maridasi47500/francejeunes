class UltrazoneController < ApplicationController
  layout false, except: [:index]
  protect_from_forgery except: [:payment,:mypayment]
  def mypayment
    @par=pay_params
    if params[:proceed]
      p @array
      @code=Buycode.new(pay_params)
      if @code.save
                MyMailer.with(user: current_member, payment: @code).welcome_email.deliver_now

      #@array= {"result"=>"true","status"=>"error","errors"=>[{"field"=>"global","error"=>"As your payment cannot be completed, we invite you to try again. For any other question, our support service remains at your disposal at: customer-support@mobiyo.com"}]}
            @array={"result" => "true", "status" => "success", "html" => "<p>Le paiement a réussi</p>", "url" => "/myurl"}

        render json:@array
      else
            @array={"result" => "true", "status" => "error", "errors" => @code.myerrors}

        render json:@array

      end
    else
      render json: nil
      
    end
  end
  def index
    case params[:actions]
    when "articles_notes"
      @members=current_member.notesarticles
    when 'fiche'
          @members=current_member.vufichesuniq
    when "articles"
          @members=current_member.luarticlesuniq
    end
    

  end
  def payment
    
  end
  def sms
    
  end
  def ultra
  end
  def card
    redirect_to ultrazonepayment_path(params.as_json)
  end
  private
  def pay_params
    params.permit(:proceed,:card_token, :browser_info, :ids, :idd, :lang,:memberid, :rememberEmail,:numberOfCodes, :netsurferEmail, :card, :rememberCreditCard,:cvc1, :ccexp1, :ccname1, :cardnumber1)
  end
end
