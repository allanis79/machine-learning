#!/usr/bin/env python
from unidecode import unidecode
import codecs

import nltk

import random
from nltk.corpus import movie_reviews
from nltk.classify.scikitlearn import SklearnClassifier
import operator
import pickle

from sklearn.naive_bayes import MultinomialNB, GaussianNB, BernoulliNB

from sklearn.linear_model import LogisticRegression, SGDClassifier

from sklearn.svm import SVC, LinearSVC, NuSVC

from nltk.classify import ClassifierI
from statistics import mode

from nltk.tokenize import word_tokenize



class VoteClassifier(ClassifierI):
    def __init__(self, *classifiers):
        self._classifiers = classifiers


    def classify(self, features):

        votes = []

        for c in self._classifiers:
            v = c.classify(features)
            votes.append(v)

        return mode(votes)

    def confidence(self,features):
        votes = []

        for c in self._classifiers:
            v = c.classify(features)
            votes.append(v)

        choice_votes = votes.count(mode(votes))
        #print 'choice_votes: ', choice_votes
        #print 'len: ', len(votes)

        a = choice_votes * 100
        b = len(votes)

        conf = a/b
        return float(conf)
        
        

pos = open('reviews/positive.txt','rb').read()
print type(pos)
enc = lambda pos: pos.decode('utf8', 'ignore')
pos1 = enc(pos)
print type(pos1)
neg = open('reviews/negative.txt','rb').read()
neg1 = enc(neg)

documents = []

for r in pos.split('\n'):
    documents.append((r,'pos'))

for r in neg.split('\n'):
    documents.append((r,'neg'))

#print documents

all_words = []

pos_words = word_tokenize(pos1)
neg_words = word_tokenize(neg1)


for w in pos_words:
    all_words.append(w.lower())

for w in neg_words:
    all_words.append(w.lower())


print type(all_words[0])

all_words1=[]

for i in all_words:
    all_words1.append(unidecode(i))

print type(all_words1[0])


all_words1 = nltk.FreqDist(all_words1)

##print all_words.most_common(15)
##d = {}
##count = 1
##
##for i in all_words:
##    if i not in d.keys():
##        d[i] = count
##    else:
##        d[i] +=1
##
##sorted_d = sorted(d.items(), key = operator.itemgetter(1))
##
##
##print sorted_d[2]

word_features = list(all_words1.keys())[:5000]


def find_features(document):
    document = enc(document)
    words = word_tokenize(document)
    features = {}
    for w in word_features:
        features[w] = w in words

    return features



#print find_features(movie_reviews.words('neg/cv000_29416.txt'))

featuresets =[(find_features(rev), category) for (rev,category) in documents]


random.shuffle(featuresets)

training_set = featuresets[:10000]
testing_set = featuresets[10000:]

####Naive Bayes:::::

# posterior = prior *likelihood /evidence (Go through google for more info)


classifier = nltk.NaiveBayesClassifier.train(training_set)

##load classifier using pickle

##classifier_f = open('naivebayes.pickle','rb')
##classifier = pickle.load(classifier_f)
##classifier_f.close()

print 'nltk naiveB classifier: ', nltk.classify.accuracy(classifier,testing_set) * 100

classifier.show_most_informative_features(15)

### save calssifier using pickle
#save_classifier = open('naivebayes.pickle','wb')

#pickle.dump(classifier, save_classifier)

#save_classifier.close()

#MNB classifier

MNB_classifier = SklearnClassifier(MultinomialNB())
MNB_classifier.train(training_set)

print 'MNB classifier accuracy: ', nltk.classify.accuracy(MNB_classifier,testing_set) * 100

#BernoulliNB

BernoulliNB_classifier = SklearnClassifier(BernoulliNB())
BernoulliNB_classifier.train(training_set)

print 'BernoulliNB classifier accuracy: ', nltk.classify.accuracy(BernoulliNB_classifier,testing_set) * 100

##LogisticRegression, SGDClassifier
##SVC, LinearSVC, NuSVC

#LogisticRegression

LogisticRegression_classifier = SklearnClassifier(LogisticRegression())
LogisticRegression_classifier.train(training_set)

print 'LogisticRegression classifier accuracy: ', nltk.classify.accuracy(LogisticRegression_classifier,testing_set) * 100

#SGDClassifier

SGDClassifier_classifier = SklearnClassifier(SGDClassifier())
SGDClassifier_classifier.train(training_set)

print 'SGDClassifier classifier accuracy: ', nltk.classify.accuracy(SGDClassifier_classifier,testing_set) * 100

#SVC

##SVC_classifier = SklearnClassifier(SVC())
##SVC_classifier.train(training_set)
##
##print 'SVC classifier accuracy: ', nltk.classify.accuracy(SVC_classifier,testing_set) * 100

#LinearSVC

LinearSVC_classifier = SklearnClassifier(LinearSVC())
LinearSVC_classifier.train(training_set)

print 'LinearSVC classifier accuracy: ', nltk.classify.accuracy(LinearSVC_classifier,testing_set) * 100

#NuSVC

NuSVC_classifier = SklearnClassifier(NuSVC())
NuSVC_classifier.train(training_set)

print 'NuSVC classifier accuracy: ', nltk.classify.accuracy(NuSVC_classifier,testing_set) * 100



##### Voting Systems #########


voted_classifier = VoteClassifier(classifier,
                                  MNB_classifier, BernoulliNB_classifier,
                                  LogisticRegression_classifier, SGDClassifier_classifier,
                                  LinearSVC_classifier, NuSVC_classifier)





print 'voted classifier accuracy: ', nltk.classify.accuracy(voted_classifier,testing_set) * 100

print 'classification: %s' %voted_classifier.classify(testing_set[6][0])

                                                    
print ' condifence: %f' %voted_classifier.confidence(testing_set[6][0])


































