import numpy as np
import pandas as pd
import pickle
import joblib
import tensorflow as tf
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.compose import ColumnTransformer
from PIL import Image

class Model:
    def __init__(self, model_path):
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
        '''
        Method ini berfungsi untuk membuat pipeline yang mencakup preprocessing data dan model.  
        Jenis preprocessing yang diterapkan bergantung pada kebutuhan model yang digunakan.  
        Pada method ini, contoh preprocessing yang disertakan adalah StandardScaler dan MinMaxScaler.  
        Parameter `scaler_type` dipilih karena kedua scaler ini adalah yang paling umum digunakan.  
        Baik data tabular maupun data gambar dapat direpresentasikan dalam bentuk numerik, sehingga kedua tipe data tersebut  
        dapat diproses dalam method ini menggunakan StandardScaler dan MinMaxScaler.
        '''
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
        
        pipeline = Pipeline([
            ('preprocessor', preprocessor),
            ('model', self.model)
        ])
        
        return pipeline

    def predict_from_image(self, image_file):
        '''
        Terkhusus preprocessing basic seperti resize, rescale dan convert grayscale bisa dilakukan di sini.
        ika preprocessing yang dibutuhkan lebih kompleks, 
        sebaiknya dilakukan di method `data_pipeline` dan dipanggil di method ini.
        Tidak ada batasan dalam preprocessing, sesuaikan dengan kebutuhan model. 
        Yang terdapat pada contoh ini adalah preprocessing untuk model MNIST.
        '''
        image = Image.open(image_file).convert('L')
        image = image.resize((28, 28))
        image_array = np.array(image) / 255.0
                       
        if image_array.ndim == 2: 
            # Menurunkan dimensi array menjadi 1D
            image_array = image_array.reshape(-1, 784)
            # Menaikkan dimensi array menjadi 3D
            # image_array = np.expand_dims(image_array, axis=0)

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
    '''
    Method ini digunakan untuk memprediksi data tabular yang diberikan.
    Berbagai jenis model (sklearn, keras, tflite) dapat digunakan dalam method ini.
    '''
    # Mulai Preprocessing ---------------------------
    
    if self.model_type == 'sklearn':
        # Pastikan data yang diterima berupa list, numpy array, atau dataframe
        if isinstance(data, (list, np.ndarray)):
            data = pd.DataFrame([data])
        elif not isinstance(data, pd.DataFrame):
            raise ValueError("Data format not supported for sklearn model. Use list, NumPy array, or DataFrame.")

        # Jika menggunakan pipeline untuk preprocessing data, bisa ditambahkan di sini
        # Misalnya pipeline = self.data_pipeline(numerical_features=numerical_features)
        
        # Lakukan prediksi
        prediction = self.model.predict(data)
        
        # Jika prediksi dalam bentuk angka, konversikan menjadi label (misalnya untuk dataset iris)
        if isinstance(prediction, np.ndarray) and prediction.ndim == 1:
            prediction = "setosa" if prediction[0] == 0 else "versicolor" if prediction[0] == 1 else "virginica"

        return prediction

    elif self.model_type == 'keras':
        # Jika menggunakan Keras model, pastikan data dalam bentuk array dan reshape jika perlu
        data = np.array(data)
        if data.ndim == 1:
            data = data.reshape(1, -1)  # Pastikan data memiliki dimensi yang benar
        
        # Prediksi dengan model Keras
        prediction = self.model.predict(data)
        return prediction.tolist()

    elif self.model_type == 'tflite':
        # Jika menggunakan model TensorFlow Lite
        input_details = self.model.get_input_details()
        output_details = self.model.get_output_details()
        
        # Mengubah data ke tipe yang sesuai
        data = np.array(data, dtype=input_details[0]['dtype'])
        if data.ndim == 1:
            data = np.expand_dims(data, axis=0)  # Mengubah dimensi menjadi batch
        
        # Menyusun tensor dan melakukan prediksi
        self.model.set_tensor(input_details[0]['index'], data)
        self.model.invoke()
        
        # Mengambil hasil prediksi
        prediction = self.model.get_tensor(output_details[0]['index'])
        prediction = np.argmax(prediction, axis=1)
        return prediction.tolist()

    else:
        raise ValueError(f"Model type '{self.model_type}' not supported.")
    
    # Terakhir Preprocessing ---------------------------

        
    @staticmethod
    def from_path(model_path):
        return Model(model_path)
