import numpy as np
import pandas as pd
import pickle
import joblib
import tensorflow as tf
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.compose import ColumnTransformer
from sklearn.metrics import accuracy_score
from PIL import Image
import os

class Model:
    def __init__(self, model_path):
        """
        Inisialisasi model berdasarkan format file yang diterima.
        """
        if model_path.endswith('.pkl'):
            with open(model_path, 'rb') as f:
                self.model = pickle.load(f)
            self.model_type = 'sklearn'
        elif model_path.endswith('.joblib'):
            self.model = joblib.load(model_path)
            self.model_type = 'sklearn'
        elif model_path.endswith('.h5'):
            self.model = tf.keras.models.load_model(model_path)
            self.model_type = 'keras'
        elif model_path.endswith('.tflite'):
            self.model = tf.lite.Interpreter(model_path=model_path)
            self.model.allocate_tensors()
            self.model_type = 'tflite'
        else:
            raise ValueError(f"Model format '{model_path.split('.')[-1]}' not supported. Please use '.pkl', '.joblib', '.h5', or '.tflite'.")

def data_pipeline(self, numerical_features=None, scaler_type="standard"):
    """
    Membuat pipeline preprocessing dan model untuk skikit-learn.
    """
    if self.model_type != 'sklearn':
        raise ValueError("Data pipeline is only supported for scikit-learn models.")
    
    transformers = []
    
    if numerical_features:
        if scaler_type == "standard":
            transformers.append(('scaler', StandardScaler(), numerical_features))
        elif scaler_type == "minmax":
            transformers.append(('scaler', MinMaxScaler(), numerical_features))
        else:
            raise ValueError(f"Unsupported scaler type: '{scaler_type}'. Use 'standard' or 'minmax'.")

    preprocessor = ColumnTransformer(transformers, remainder='passthrough')
    
    # Membuat pipeline yang benar
    pipeline = Pipeline([
        ('preprocessor', preprocessor),
        ('model', self.model)  # Pastikan model ada di langkah terakhir
    ])
    
    # Debugging: Print langkah-langkah dalam pipeline
    print(pipeline.named_steps)  # Cek langkah-langkah dalam pipeline
    
    return pipeline



def predict_from_image(self, image_file):
    """
    Melakukan prediksi berdasarkan input gambar.
    """
    image = Image.open(image_file).convert('L')
    image = image.resize((28, 28))
    image_array = np.array(image) / 255.0

    if image_array.ndim == 2: 
        image_array = np.expand_dims(image_array, axis=0)

    if self.model_type == 'keras':
        prediction = self.model.predict(image_array)
        prediction = np.argmax(prediction, axis=1)
        return prediction.tolist()

    elif self.model_type == 'tflite':
        input_details = self.model.get_input_details()
        output_details = self.model.get_output_details()
        
        image_array = image_array.astype(input_details[0]['dtype'])
        self.model.set_tensor(input_details[0]['index'], image_array)
        self.model.invoke()
        prediction = self.model.get_tensor(output_details[0]['index'])
        return prediction.tolist()
    
    else:
        raise ValueError("This method is only supported for Keras and TensorFlow Lite models.")

def predict_from_data(self, data, numerical_features=None):
    """
    Melakukan prediksi berdasarkan data tabular.
    """
    if self.model_type == 'sklearn':
        if isinstance(data, (list, np.ndarray)):
            data = pd.DataFrame([data])
        elif not isinstance(data, pd.DataFrame):
            raise ValueError("Data format not supported for sklearn model. Use list, NumPy array, or DataFrame.")
        
        # Use the pipeline to process data and make predictions
        pipeline = self.data_pipeline(numerical_features=numerical_features)
        
        # Use pipeline to predict
        prediction = pipeline.predict(data)
        return prediction.tolist()

    elif self.model_type == 'keras':
        data = np.array(data)
        if data.ndim == 1:
            data = data.reshape(1, -1) 
        prediction = self.model.predict(data)
        return prediction.tolist()

    elif self.model_type == 'tflite':
        input_details = self.model.get_input_details()
        output_details = self.model.get_output_details()
        
        data = np.array(data, dtype=input_details[0]['dtype'])
        if data.ndim == 1:
            data = np.expand_dims(data, axis=0)
        self.model.set_tensor(input_details[0]['index'], data)
        self.model.invoke()
        prediction = self.model.get_tensor(output_details[0]['index'])
        prediction = np.argmax(prediction, axis=1)
        return prediction.tolist()

    else:
        raise ValueError("Model type not supported.")

def evaluate_accuracy(self, X_test, y_test):
    """
    Menghitung akurasi model untuk data uji, khusus untuk model sklearn.
    """
    if self.model_type == 'sklearn':
        y_pred = self.model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        return accuracy
    else:
        raise ValueError("Accuracy evaluation is supported only for scikit-learn models.")

@staticmethod
def from_path(path):
        """
        Memuat model dari file yang diberikan.
        """
        try:
            model = joblib.load(path)
            return model
        except Exception as e:
            raise ValueError(f"Error loading model from path {path}: {e}")

# Contoh penggunaan Model
try:
    model = Model.from_path('E:/template_PA_Mobile/api/Synapse/api/model/garden/PA.pkl')
    prediction = model.predict_from_data([5.1, 3.5], numerical_features=['feature1', 'feature2'])
    print(prediction)
except Exception as e:
    print(f"Error: {e}")
