class ForumsController < ApplicationController
  protect_from_forgery except: [:message]
  def forumtype
    case params[:tid]
    when '-1'
      @forums=[]
      @forumcat=Forumcat.new
    else
          @forumcat = Forumsubcat.find(params[:tid])
@forums=@forumcat.forums.vueetcoms
    end
  end
  def forumlogin
        @m= Member.findby(memberparams)
    p @m
    if @m
      bypass_sign_in(@m)
      redirect_to mydiscussion_path(tid: params[:tid])
    end
  end
  def forummessage
      @forum=Forumcommentaire.new(forumcommentaireparams)
      if @forum && @forum.save
        redirect_to showforum_path(tid: @forum.category.id, tid2: @forum.forum.id)
      end

  end
      def message
      @forum=Forum.new(forumparams)
      if @forum && @forum.save
        redirect_to showforum_path(tid: @forum.category.id, tid2: @forum.id)
      end
    end
    def show
      if params[:tid2] && params[:tid]
      @forum = Forum.find(params[:tid2])
      @forumcat = Forumsubcat.find(params[:tid])
      @forum.vueforums.create(member: (member_signed_in? ? current_member : nil))
      elsif params[:tid] == '-2'
        @forumcat=Forumsubcat.new
        @forum=Forum.new(member_id: current_member.id)
        @forums=Forum.all.vueetcoms
      render :forumtype

      elsif params[:tid] == ""
      redirect_to discut_path

      elsif params[:tid]
          @forumcat = Forumsubcat.find(params[:tid])
@forums=@forumcat.trouveraussi([:form_where, :form_q,:form_q2,:tid].map{|h|params[h]}).vueetcoms

        p @forums

      render :forumtype
      end
    rescue ActiveRecord::RecordNotFound
        @forumcat=Forumsubcat.new
        @forums=[]
        render :forumtype
    end
  private
  def memberparams
    params.permit(:login, :mdp)
  end
  def forumparams
    params.permit(:title,:content,:member_id,:tid)
  end
  def forumcommentaireparams
    params.permit(:title,:content,:member_id,:forum_id)
  end
  def search_params
    params.permit()
  end

  
end
