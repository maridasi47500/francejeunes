class ArticlesController < ApplicationController
  protect_from_forgery except: [:log,:loginwizard,:endarticle,:images,:corps,:description,:creerparagraphe,:answermessage]
  before_action :set_article, only: [:images, :description, :corps,:endarticle]
  before_action :update_article, only: [:description, :corps,:endarticle]
  before_action :setmyarticle, only: [:loginarticle, :answer, :answermessage]
  
  layout false, only: [:member, :edit, :imprimhtml]
  def imprim
    
  end
  def imprimhtml
    case params[:type]
    when "article"
      @article = Article.find(params[:tid])
    end
  end
  def edit
    @message=Article.find(params[:tid])
    @message.categoryid=@message.category_id
  end
  def delete
    @message=Article.find(params[:tid])
    @message.destroy
  end
  def alert
    
  end
  def overview
    @articles=Article.bycat
  end
  def newarticle
    @article=Article.new(articleparams)
    if @article.save
      render :endarticle
    end
  end
  def publish
    
  end
  def rubrique
    @articles=Category.myarticles(params[:title])
    @articlenb=Category.articlenb(params[:title])
    @category=Category.findbyurl(params[:title])
  end
  def new
    
  end
  def loginarticle
   @m= Member.findby(memberparams)
    p @m
    if @m
      bypass_sign_in(@m)
      redirect_to answerarticle_path(tid: params[:tid], tid2: params[:tid2])
    end

  end
  def answermessage
    @article.comments.new(comment_params)
    @star=@article.stars.find_by_member_id(current_member.id)
    if params['star4.x']
      @article.stars.create(member: current_member, star: 4)
      redirect_to discut_path(tid:@article.category.id, tid2: @article.id), notice: "Article noté 4 étoiles sur 5 !"

    elsif params['star5.x']
      @article.stars.create(member: current_member, star: 5)
      redirect_to discut_path(tid:@article.category.id, tid2: @article.id), notice: "Article noté 5 étoiles sur 5 !"

    elsif params['star1.x']
      @article.stars.create(member: current_member, star: 1)
      redirect_to discut_path(tid:@article.category.id, tid2: @article.id), notice: "Article noté 1 étoiles sur 5 !"

    elsif params['star2.x']
      @article.stars.create(member: current_member, star: 2)
      redirect_to discut_path(tid:@article.category.id, tid2: @article.id), notice: "Article noté 2 étoiles sur 5 !"
    elsif params['star3.x']
      @article.stars.create(member: current_member, star: 3)
    redirect_to discut_path(tid:@article.category.id, tid2: @article.id), notice: "Article noté 3 étoiles sur 5 !"
    elsif @article.save
      redirect_to answerarticle_path(tid: params[:tid], tid2: params[:tid2])
    end
  end
  def answer
    if !@forum
    @member=@article.member
    render :answer
    else
      render "forums/show"
    end
  end
  def mysexe
    case sex
    when "F"
      "femme"
    when "H"
        "homme"
    else
      "femme"
    end
  end
  def show
    @article=Article.find(params[:id])
    @article.vuearticles.create!(member: (member_signed_in? ? current_member : nil))
  end
  def member
    @member=Member.find(params[:tid])
    @member.vuefiches.create(member: (member_signed_in? ? current_member : nil))
  end
  def creerparagraphe
    @article=Article.find(params[:postid])
        @article.update(articleparams)

  end
  def loginwizard
    @m= Member.findby(memberparams)
    p @m
    if @m
      bypass_sign_in(@m)
      redirect_to publishwizard_path(actions: "")
    end
  end
  def log
    @m= Member.findby(memberparams)
    p @m
    if @m
      bypass_sign_in(@m)
      redirect_to publishwizard_path(actions: "")
    end
  end

  def titre
  end
  def images
    @article=Article.new(articleparams)
    @article.save
    session[:articleid]=@article.id.to_s
  end
  def description
  end
  def corps
    
  end
  def endarticle
  end
  private
  def update_article
        @article.update(articleparams)
  end
  def set_article
    @article=Article.find(session[:articleid]) rescue nil
  end
  def memberparams
    params.permit(:login, :mdp)
  end
  def setmyarticle
    begin 
    @article=Article.find(params[:tid2])
    @category = Category.find(params[:tid])
    rescue
    @forum=Forum.find(params[:tid2])
    @forumcat = Forumsubcat.find(params[:tid])
    end
  end
  def comment_params
    params.permit(:member_id, :content,:title)
  end
  def articleparams
    params.permit(:noprivate,:title,:subtitle,:description,:categoryid,:memberid,:content, :paragraphes_attributes=>{},:images=>[])
  end
end
