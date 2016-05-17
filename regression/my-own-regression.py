#!/usr/bin/env python

'''
y = m.x + b

m = x-mean*y-mean - (x*y)Mean/ (x-mean**2 - x**2mean)

b = y-mean - m*x-mean
'''

from statistics import mean 
import numpy as np 
import matplotlib.pyplot as plt 

xs =np.array([1,2,3,4,5,6,7,8], dtype = np.float64)
ys =np.array([2,6,8,12,17,18,19,22],dtype = np.float64)

def best_fit_slope_intercept(xs,ys):

	a = mean(xs) * mean(ys)
	b = mean(xs*ys)
	c = mean(xs)
	d = mean(xs**2)

	m = float((a - b)/(c**2 -d))

	B = mean(ys) - m*mean(xs)

	return m ,B

def squared_error(y_original,y_new):
	return sum((y_original - y_new)**2)


def coefficient_of_determination(y_original,y_new):
	mean_of_ys = [ mean(y_original) for y in y_original]
	squared_error_ys = squared_error(y_original,mean_of_ys)
	squared_error_regression = squared_error(y_original,y_new)

	return 1 -(squared_error_regression/squared_error_ys)




m,b = best_fit_slope_intercept(xs,ys)


regression_line = [(m*x) +b for x in xs]

R = coefficient_of_determination(ys,regression_line)
print R
new_x = 12
predict_y = m*new_x +b 

plt.scatter(xs,ys)
plt.scatter(new_x,predict_y, color = 'g')
plt.plot(xs,regression_line)
plt.show()

