# Databricks notebook source
# MAGIC %md
# MAGIC #Heart Disease Prediction Model

# COMMAND ----------

# MAGIC %md
# MAGIC Heart disease is a leading cause of death worldwide, and identifying individuals who are at risk for developing heart disease is crucial for early intervention and prevention. This project aims to build a heart disease prediction model using machine learning techniques. The model will use various patient attributes such as age, gender, blood pressure, cholesterol levels, and other clinical features to predict the likelihood of a patient developing heart disease in the future.
# MAGIC 
# MAGIC The heart prediction model will be built using a dataset of patient information and medical records. The dataset will be preprocessed and cleaned to remove missing data, outliers, and other inconsistencies. The model will be trained using a supervised learning approach, with machine learning algorithm like RandomForestClassifier
# MAGIC 
# MAGIC The final heart prediction model will be evaluated BinaryClassificationEvaluator. The project aims to provide a useful tool for doctors and healthcare professionals to identify patients at high risk of developing heart disease and to take early preventive measures to reduce the risk.

# COMMAND ----------

# MAGIC %md
# MAGIC importing necessary libraries

# COMMAND ----------

from pyspark.sql import SparkSession
spark = SparkSession.builder.appName('HeartDisease').getOrCreate()
from pyspark.sql.functions import col, when, corr
from pyspark.ml.linalg import Vector
from pyspark.ml.feature import VectorAssembler, StringIndexer
from pyspark.ml.classification import RandomForestClassifier
from pyspark.ml.evaluation import BinaryClassificationEvaluator

# COMMAND ----------

# MAGIC %md
# MAGIC importing dataset

# COMMAND ----------

df = spark.sql("SELECT * FROM heart_disease_data_2_csv")

# COMMAND ----------

# MAGIC %md
# MAGIC About the Dataset
# MAGIC 
# MAGIC 1. ChestPainType: 
# MAGIC 
# MAGIC                   TA - Typical Angina
# MAGIC                   
# MAGIC                   ATA - Atypical Angina
# MAGIC 
# MAGIC                   NAP - Non-Anginal Pain
# MAGIC                   
# MAGIC                   ASY - Asymptotic
# MAGIC                   
# MAGIC 2. Resting BP: Resting BloodPressure (mmHg)
# MAGIC 
# MAGIC 3. Cholestrol: (mm/dl)
# MAGIC 
# MAGIC 4. Fasting BS: Fasting Blood Suger
# MAGIC 
# MAGIC                1 - Fasting BS > 120 mg/dl
# MAGIC                
# MAGIC                0 - Fasting BS < 120 mg/dl
# MAGIC                
# MAGIC 5. Resting ECG: Resting Electrocadiagram results
# MAGIC 
# MAGIC                 Normal - Normal
# MAGIC                 
# MAGIC                 ST - Having ST-T wave abnormality (T wave invesion and/or ST elevation or depression of > 0.05mV)
# MAGIC                 
# MAGIC                 LVH - SHowing probable or definatr left venticullar hyperthrophy by Estes' criteria
# MAGIC                 
# MAGIC 6. Max HR:     maximum heart rate, achived between 60 and 202
# MAGIC 
# MAGIC 7. ST Slop:   The stop of the peak excercise ST segment
# MAGIC 
# MAGIC               Up - upsloping
# MAGIC               
# MAGIC               Down - downsloping
# MAGIC               
# MAGIC               Flat - flatsloping

# COMMAND ----------

# MAGIC %md
# MAGIC data exploration

# COMMAND ----------

#counting the number of column in the dataset
df.count()

# COMMAND ----------

#checking the datatypes
df.printSchema()

# COMMAND ----------

#displaying the first and last 5 columns
display(df.head(5))
display(df.tail(5))

# COMMAND ----------

#checking got null values
df.isEmpty()

# COMMAND ----------

#describing the data
display(df.describe())

# COMMAND ----------

#finding out how many patients has/ doesn't have a heart disease in the dataset
dff = df.withColumn('HeartDisease_Str', col('HeartDisease').cast('string'))
dff = dff.replace('0', 'False', 'HeartDisease_Str').replace('1', 'True', 'HeartDisease_Str')
display(dff)

# COMMAND ----------

#finding out how many male/ female patients has a heart disease in the dataset
dff = dff.filter(dff['HeartDisease_Str'] == 'True')
display(dff)

# COMMAND ----------

#figuring out which age category has heart disease
dff = dff.withColumn('Age Category', when(df['Age'] > 50,'Very Old').when(df['Age'] > 41, 'Old').when(df['Age'] > 35, 'Adult').when(df['Age'] > 28, 'Young Adult'))
display(dff)

# COMMAND ----------

#Histogram of each numerical variable
display(df.select('Age'))
display(df.select('RestingBP'))
display(df.select('Cholesterol'))
display(df.select('FastingBS'))
display(df.select('MaxHR'))
display(df.select('Oldpeak'))
display(df.select('HeartDisease'))

# COMMAND ----------

#Box plot of each numerical variable
display(df)
display(df)
display(df)
display(df)
display(df)

# COMMAND ----------

#Converting texts in the non numerical columns to numerics
indexer = StringIndexer(inputCols= ['Sex', 'ChestPainType', 'RestingECG', 'ExerciseAngina', 'ST_Slope'], outputCols= ['Sex_ind', 'ChestPainType_ind', 'RestingECG_ind', 'ExerciseAngina_ind', 'ST_Slope_ind'])
df= indexer.fit(df).transform(df)
df= df.drop('Sex', 'ChestPainType', 'RestingECG', 'ExerciseAngina', 'ST_Slope')
df.show(5)

# COMMAND ----------

#Correlarion of each variable with the HeartDisease variable
display(df.select(corr('Age', 'HeartDisease')))
display(df.select(corr('RestingBP', 'HeartDisease')))
display(df.select(corr('Cholesterol', 'HeartDisease')))
display(df.select(corr('FastingBS', 'HeartDisease')))
display(df.select(corr('MaxHR', 'HeartDisease')))
display(df.select(corr('Oldpeak', 'HeartDisease')))
display(df.select(corr('Sex_ind', 'HeartDisease')))
display(df.select(corr('ChestPainType_ind', 'HeartDisease')))
display(df.select(corr('RestingECG_ind', 'HeartDisease')))
display(df.select(corr('ExerciseAngina_ind', 'HeartDisease')))
display(df.select(corr('ST_Slope_ind', 'HeartDisease')))

# COMMAND ----------

#creating a VectorAssembler object that combines several input columns into a single feature vector column.
vec_assem = VectorAssembler(inputCols= ['Age', 'RestingBP', 'Cholesterol', 'FastingBS', 'MaxHR', 'Oldpeak', 'Sex_ind', 'ChestPainType_ind', 'RestingECG_ind', 'ExerciseAngina_ind', 'ST_Slope_ind'], outputCol= 'features')
df = vec_assem.transform(df)
df = df.select('features', 'HeartDisease')
df.show(10)

# COMMAND ----------

#Splitting the data
train_data, test_data = df.randomSplit([0.7, 0.3])

# COMMAND ----------

#training a Random Forest Classifier (RC) model using the training data 
RC = RandomForestClassifier(labelCol= 'HeartDisease')
RC_model = RC.fit(train_data)

# COMMAND ----------

#use the trained RC_model to predict the target variable (or dependent variable) on the test dataset
RC_model_pred = RC_model.transform(test_data)
RC_model_pred.show(10)

# COMMAND ----------

#creating a BinaryClassificationEvaluator object to evaluate the performance the model.
test =BinaryClassificationEvaluator(labelCol= 'HeartDisease')
test_result = test.evaluate(RC_model_pred)
test_result

# COMMAND ----------


