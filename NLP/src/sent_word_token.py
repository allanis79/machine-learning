#!/usr/bin/env python
from nltk.tokenize import sent_tokenize, word_tokenize


ex = "Hello how are you? The weather is aweosome. I am Gandalf The Great!!!!! I am from Middle Earth"

print sent_tokenize(ex)
print word_tokenize(ex)
