class ParolesController < ApplicationController
  protect_from_forgery except: [:newsong]
  def newartist
    @artist=Artist.new(artist_params)
    if @artist.save
      redirect_to paroles_path, notice: "l'artiste #{@artist.name} a bien été ajouté"
    end
  end
  def editasong
    @song = Song.find(params[:tid])
    if !member_signed_in?
      redirect_to @song.easyurl, notice: "Vous devez être membre et être identifié pour corriger les paroles."
    else
      render :sendlyrics
    end
  end
  def editsong
    @song = Song.find(params[:id])
    if @song.update(songbis_params)
      redirect_to @song.easyurl
    end
  end
  def removelyrics
    @song = Song.find(params[:id])
  end

  def sendlyrics
    @song = Song.find(params[:id])

  end
  def index

          @songs = Song.allmysongs

    case params[:type]
    when "titre"

    @paroles = @songs.bytitle(params[:lettre])
    when "artiste"

    @paroles = @songs.byartist(params[:lettre])
    else
    @paroles = @songs.allsongs
    end
  end
  def delete
        @songs = Song.allmysongswithlyrics
    case params[:type]
    when "titre"

    @paroles = @songs.bytitle(params[:lettre])
    when "artiste"

    @paroles = @songs.byartist(params[:lettre])
    else
    @paroles = @songs.allsongs
    end

  end

  def sendd
        @songs = Song.allmysongswithoutlyrics
    case params[:type]
    when "titre"

    @paroles = @songs.bytitle(params[:lettre])
    when "artiste"

    @paroles = @songs.byartist(params[:lettre])
    else
    @paroles = @songs.allsongs
    end

  end
  def newsong
    @artist=Song.new(song_params)
    if @artist.save
      redirect_to paroles_path
    end
  end
  def actions
    if member_signed_in?
    case params[:actions]
    when "new_ar" #nouvel artiste
      redirect_to new_ar_path(actions: 'new_ar')
    when "send" #nouvel artiste
      redirect_to send_lyrics_path(actions: 'send')
    when "bestof_ar" #nouvel artiste
      redirect_to bestof_ar_path(actions: 'bestof_ar')
    when "bestof" #nouvel artiste
      redirect_to bestof_songs_path(actions: 'bestof')
    when "succes" #nouvel artiste
      redirect_to succes_songs_path(actions: 'succes')
    when "delete" #nouvel artiste
      redirect_to delete_lyrics_path(actions: 'delete')
    when "new" #nouvel artiste
      redirect_to new_text_path(actions: 'new')

    end
    else
      redirect_to paroles_path
    end
  end
  def new_ar
  end
  def bestof
    @paroles = Song.lesplusvues
    render :index
  end
  def bestof_ar
    @artistes = Artist.plusvus
  end
    def new
      @song=Song.new
      
    end
    def succes
    @paroles = Song.succesdumoment
    render :index
    end
    def showlyrics
      @song=Song.find_by_url(params[:title])
      @artist=Artist.find_by_url(params[:artist])
      @song.vuesongs.create(member: current_member) if member_signed_in?
    end
    def showartist
      @artist=Artist.findbyname(params[:artiste])
    end
    private
    def song_params
      params.permit(:content,:title,:nameartist,:artist=>{}, :artist_attributes=>{})
    end
    def songbis_params
      params.require(:song).permit(:content,:contentmember_id,:myaction, :youtubelink_id, :videomember_id)
    end
    def artist_params
      params.permit(:name,:member_id)
    end
end
