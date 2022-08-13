require "nokogiri"
require "open-uri"
@doc=Nokogiri::HTML(URI.open("./app/views/welcome/discut.html.erb"))
@t={}
@doc.css('.erreur,.big').each do |titre|

  t=titre.attributes["class"].value rescue ""


  if t.include?('erreur')

    @t1=titre.text.strip.squish
    @t[@t1] ||= []
  elsif t.include?('big')
    begin
    @t[@t1].push(titre.text.squish.strip)
    rescue => e
      p e.message
    end
  end
end
@t.to_a.each do |cat,subcat|
  @f=Forumcat.create(name: cat)
  subcat.each do |subcat1|
    @ff=@f.forumsubcats.create(name: subcat1)
  end
end
