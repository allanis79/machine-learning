#!/usr/bin/env python

from nltk.corpus import wordnet

syns = wordnet.synsets('good')

#sysset
print syns[0].lemmas()[0].name()

#word

print syns[0].lemmas()[0].antonyms()

#def

print syns[0].definition()

#examples

print syns[0].examples()

synonyms =[]
antonyms =[]

for i in wordnet.synsets("good"):
	for j in i.lemmas():
		synonyms.append(j.name())
		if j.antonyms():
			antonyms.append(j.antonyms()[0].name())
		else:
			pass


print set(synonyms)

print set(antonyms)

w1 = wordnet.synset('boat.n.01')
w2 = wordnet.synset('ship.n.01')

print w1.wup_similarity(w2)