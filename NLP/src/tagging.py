#!/usr/bin/env python

import nltk
from nltk.corpus import state_union
from nltk.tokenize import PunktSentenceTokenizer #unsupervised tokenizer


train_text = state_union.raw('2005-GWBush.txt')

#print train_text

test_text = state_union.raw('2006-GWBush.txt')

custom_sent_token = PunktSentenceTokenizer(train_text)

tokenized = custom_sent_token.tokenize(test_text)

#print tokenized
#print type(tokenized)

def tag():
	try:
		for i in tokenized:
			words = nltk.word_tokenize(i)
			tagged = nltk.pos_tag(words)
			print tagged


	except Exception as e:
		print str(e)

tag()