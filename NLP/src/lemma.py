#!/usr/bin/env python

from nltk.stem import WordNetLemmatizer

Lemmatizer = WordNetLemmatizer()


print Lemmatizer.lemmatize('better',pos='a')