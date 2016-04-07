#!/usr/bin/env python

from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize


port = PorterStemmer()


ex = 'This is Gandalfing The Greating'

words = ex.split()

word_t = word_tokenize(ex)

for i in words:
	print port.stem(i)

for i in word_t:
	print port.stem(i)