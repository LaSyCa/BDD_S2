import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import math
from sklearn.linear_model import LinearRegression

# Chargement des données avec le bon séparateur
CollegesDF = pd.read_csv("./colleges.csv", delimiter=',')

# Suppression des lignes avec des valeurs manquantes
CollegesDF = CollegesDF.dropna()

# Conversion du DataFrame en array numpy
CollegesAr = CollegesDF.to_numpy()

# On ne garde que les valeurs numériques
CollegesAr0 = CollegesAr[:, 2:7]  # Mise à jour de la tranche pour inclure toutes les colonnes numériques
print(CollegesAr0)

# Fonction de centrage-réduction
def Centreduire(T):
    T = np.array(T, dtype=np.float64)
    lignes, colonnes = T.shape
    res = np.zeros((lignes, colonnes))
    moy = np.mean(T, axis=0)
    ecarttype = np.std(T, axis=0)
    for i in range(0, lignes):
        for j in range(0, colonnes):
            res[i][j] = (T[i][j] - moy[j]) / ecarttype[j]
    return res

CollegesAr0_CR = Centreduire(CollegesAr0)
print(CollegesAr0_CR)

# Fonction pour créer un histogramme
def DiagrammeBaton(Colonne, title):
    m = min(Colonne)  # m contient la valeur minimale de la colonne
    M = max(Colonne)  # M contient la valeur maximale de la colonne
    inter = np.linspace(m, M, num=20)
    plt.figure()
    plt.hist(Colonne, histtype="bar", bins=inter, rwidth=1)
    plt.title(title)
    plt.show()

# Affichage des histogrammes pour chaque colonne
DiagrammeBaton(CollegesAr0[:, 0], "Nombre de lettres dans le nom des établissements")
DiagrammeBaton(CollegesAr0[:, 1], "Distribution de l'effectif des élèves de 3ème")
DiagrammeBaton(CollegesAr0[:, 2], "Longitude")
DiagrammeBaton(CollegesAr0[:, 3], "Latitude")
DiagrammeBaton(CollegesAr0[:, 4], "Taux de réussite")

# Calcul de la matrice de covariance
MatriceCov = np.cov(CollegesAr0_CR, rowvar=False)
print("Matrice de covariance :\n", MatriceCov)
print("regression linéaire")
# Régression linéaire
Y = np.array(CollegesAr0_CR[:, 1])
X = np.array(CollegesAr0_CR[:, 0:5])
 
RegressionLineaire = LinearRegression()
RegressionLineaire.fit(X, Y)
print(RegressionLineaire.coef_)


print(RegressionLineaire.score(X, Y))
print(math.sqrt(RegressionLineaire.score(X, Y)))


