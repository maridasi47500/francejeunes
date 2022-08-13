class MyMailer < ActionMailer::Base
  layout 'mailer'
  def welcome_email
        @user = params[:user]
        @payment = params[:payment]
      @url  = 'https://localhost:3000/log.php'
    mail(from: 'cleo.ordioni@gmail.com', to: 'cleo.ordioni@gmail.com', subject: 'Bienvenue sur France-jeunes.com')

  end

end
