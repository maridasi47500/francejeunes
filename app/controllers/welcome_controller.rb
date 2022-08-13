class WelcomeController < ApplicationController
  layout false, except: [:contactus,:search,:link,:index,:shop,:avatar,:photosmember,:messaging,:privateforum,:editprivateforum,:webeauty,:love,:discut]
  def newprivateforum
    @forum=Privateforum.new(privateforum_params)
    if @forum.save
      redirect_to privateforum_path(tid: @forum.id)
    end
  end
  def updateprivateforum
    @forum=Privateforum.find(params[:tid])
    if @forum.update(privateforum_params)
      redirect_to privateforum_path(tid: @forum.id)
    end
  end
  def love
    @members=Member.leplusdedicaces.nbpage(params[:page])
  end
  def editprivateforum
  @forum=Privateforum.find(params[:tid])

  end
  def privateforum
    if params[:tid]
    @forum=Privateforum.find(params[:tid])

      render :showprivate
    else
      render :privateforum
    end
  end
  def shop
    @products=Product.all
  end
  def search
    if params[:q].length < 3 && !notice
      redirect_to mysearch_path(q: params[:q], search_type: params[:search_type]), notice: "Vous devez indiquer vos termes de recherche. Ceux-ci doivent faire au moins 3 caractères."
    else
    case params[:search_type]
    when "articles"
      @articles=Article.findallby(params[:q])
    when "membres"
      @members=Member.searchmembres(params[:q])
    when "paroles"
      @songs=Song.byarticletitle(params[:q])
    when "images"
      @images=Rubriqueimage.search(params[:q])
    end
    end
  end
  def sentmessage
    @member=Member.find(params[:tid])
    if @member.update(mymembermessage_params)
      redirect_to memberzone_path
    end

  end
  def webeauty
    if params[:tid] && params[:form_note]
      member=Member.find(params[:tid])
      member.webeauties.create(note: params[:form_note], member: current_member)
    end
    @member=Member.mybeautysample 

  end
  def index
    @articles=Article.all.take(5)
    @forums = Forum.all
    @articlesbycat = Article.all.take(5)
    
  end
  def dedicace
    @member=Member.find(params[:tid])

    if params[:type]=="sent"
      render :dedicace
    else
      render :dedicacerecu
    end
  end
  def photos
    @member=Member.find(params[:tid])
  end
  def sendmessage
    @member=Member.find(params[:tid])
  end
  def contact
    @member=Member.find(params[:tid])
  end
  def updatemember
    @member=Member.find(params[:tid])
    if @member.update(membermessage_params)
      redirect_to memberzone_path
    end
  end
  private
  def mymembermessage_params
    params.permit(:image,:currentmemberid,:contentmessage,:contentdedicace,:photosmembre=>[])
  end

  def membermessage_params
    params.require(:member).permit(:image,:currentmemberid,:contentmessage,:contentdedicace,:photosmembre=>[], :photos_attributes=>{})
  end
  def privateforum_params
    params.permit(:member_id, :title,:content,:updatemember_id,:privatemessages_attributes=>{})
  end
end
