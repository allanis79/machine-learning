#!/usr/bin/env python

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize


ex = "This is Gandalf again. Showing you how stopword filtration works"

stop_words = set(stopwords.words('english'))


words = word_tokenize(ex)

filter_sent = [i for i in words if i not in stop_words]

print filter_sent