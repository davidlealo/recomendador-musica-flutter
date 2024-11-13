from flask import Flask, jsonify, request
import pandas as pd
import surprise
from surprise import Dataset, Reader
import pickle
import os

app = Flask(__name__)

# Función para entrenar y guardar el modelo
def entrenar_y_guardar_modelo():
    # Cargar los datos
    data = pd.read_json("data/recomendaciones.json")
    reader = Reader(rating_scale=(1, 5))
    dataset = Dataset.load_from_df(data[['user_id', 'item_id', 'rating']], reader)

    # Entrenar el modelo
    model = surprise.SVD()
    trainset = dataset.build_full_trainset()
    model.fit(trainset)

    # Guardar el modelo entrenado
    with open("models/modelo_surprise.pkl", "wb") as f:
        pickle.dump(model, f)

# Verificar si el modelo guardado ya existe
if not os.path.exists("models/modelo_surprise.pkl"):
    entrenar_y_guardar_modelo()  # Entrenar y guardar el modelo si no existe

# Cargar el modelo guardado
with open("models/modelo_surprise.pkl", "rb") as f:
    model = pickle.load(f)

# Rutas de la API
@app.route("/recomendacion", methods=["GET"])
def recomendar():
    user_id = int(request.args.get("user_id"))
    item_id = int(request.args.get("item_id"))
    prediction = model.predict(user_id, item_id)
    return jsonify({"prediccion": prediction.est})

if __name__ == "__main__":
    app.run(debug=True)
