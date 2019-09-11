# -*- coding: utf-8 -*-
"""
Éditeur de Spyder

Ceci est un script temporaire.
"""

#borrowed source from kaggle: 
#https://www.kaggle.com/avilesmarcel/open-mat-in-python-pandas-dataframe

import pandas as pd

from scipy.io import loadmat

mat = loadmat("C:/Users/Norville/Documents/spatial_data/SARs4EA")  
#  mat = loadmat('SARs4EA.mat')

mdata = mat['dataStruct']

mtype = mdata.dtype

ndata = {n: mdata[n][0,0] for n in mtype.names}

