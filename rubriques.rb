require "nokogiri"
require "open-uri"
@doc=Nokogiri::HTML(URI.open("./app/views/articles/_rubriques.html.erb"))
Category.delete_all

@doc.css('.ml').map do |rubrique| 
  nom=(rubrique.attributes['href'] ? rubrique.attributes['href'].value.gsub("rubrique-","").gsub('.htm','') : nil)
  if nom
  nom1=nom.split('-')[0..-2].join('-')
  nb=nom.split('-').last
  realname=nom.split('-')[0..-2].join(' ')
  Category.create(name: realname, nb: nb, url: nom1)
  end


end
