#Rubriqueimage.destroy_all
#Sousrubimage.destroy_all
#
#femme=Rubriqueimage.create(name: 'Femmes célèbres')
#sous=femme.sousrubimages.create(name: "Millie Brady")
#homme =Rubriqueimage.create(name: 'Hommes célèbres')
#sous=homme.sousrubimages.create(name: "Millie Brady")
#
#sport =Rubriqueimage.create(name: 'Sports')
#sous=sport.sousrubimages.create(name: "Natation")
#
#monument =Rubriqueimage.create(name: 'Monuments historiques')
#sous= monument.sousrubimages.create(name: "Tour eiffel")
#
#ville =Rubriqueimage.create(name: 'Villes')
#sous= ville.sousrubimages.create(name: "Paramaribo")
#
#serie =Rubriqueimage.create(name: 'Films, séries télés et émissions')
#sous= serie.sousrubimages.create(name: "signal")
cat=Forumcat.create(name: "secret")
Forumsubcat.create(id: 222, forumcat: cat, name: "secret")