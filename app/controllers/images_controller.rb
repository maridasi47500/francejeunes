class ImagesController < ApplicationController
  def see
    @image=Image.find(params[:tid])
    redirect_to @image.myurl
  end
  def seemembre
    @image=Photo.find(params[:tid])
    redirect_to "/images/"+@image.image
  end
  def sendimages
    @rubrique=Sousrubimage.find(params[:rubriqueid])
    if @rubrique.update(rubrique_params)
      redirect_to @rubrique.myurl
    end
  end
  def add
    @sousrubrique =Sousrubimage.find(params[:rubrique]) rescue nil
    @rubrique=@sousrubrique.rubriqueimage
    @sousrubriques=@rubrique.sousrubimages
    @images=@sousrubrique.myimages(params[:nbi],params[:start])
    @rubriques=Rubriqueimage.all
  end
  def index
    @rubriques=Rubriqueimage.allmy
    @rub=Rubriqueimage.find(params[:tid]) rescue nil
    @sousrub=Sousrubimage.find(params[:tid2]) rescue nil
    if @sousrub
    @sousrubrique=@sousrub
    @rubrique=@sousrub.rubriqueimage
    @sousrubriques=@rubrique.sousrubimages
    @images=@sousrubrique.myimages(params[:nbi],params[:start])
    @rubriques=Rubriqueimage.all
    @nbpage=params[:nbi] ? (params[:nbi].to_i) : (params[:start].to_i / 12)
    @next =@sousrubrique.nextrub(params[:nbi],params[:start])
    @previous =@sousrubrique.prevrub(params[:nbi],params[:start])
    render :subcat
    elsif @rub
    @rubriques=Rubriqueimage.all

    @rubrique=@rub
    @sousrubriques=@rubrique.sousrubimages
    @sousrubriquesall=@rubrique.sousrubimages.allmy
    render :cat
    else
      render :index
    end
  end
  def cat
    @rubriques=Rubriqueimage.all

    @rubrique=Rubriqueimage.find(params[:rubrique]  || params[:tid])
    @sousrubriques=@rubrique.sousrubimages
    @sousrubriquesall=@rubrique.sousrubimages.allmy
  end
  def subcat
    @rubriques=Rubriqueimage.all

    @rubrique=Rubriqueimage.find(params[:rubrique]  || params[:tid])
    @sousrubriques=@rubrique.sousrubimages
    @sousrubrique=Sousrubimage.find(params[:tid2])
    @images=@sousrubrique.myimages(params[:nbi].to_i,params[:start].to_i)
    @nbpage=params[:nbi] ? (params[:nbi].to_i) : (params[:start].to_i / 12)
    @next =@sousrubrique.nextrub(params[:nbi],params[:start])
    @previous =@sousrubrique.prevrub(params[:nbi],params[:start])

  end
  private
  def rubrique_params
     params.require("sousrubimage").permit(:memberid, "addimage"=>[])
  end
end
