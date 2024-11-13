from flask import Flask, jsonify, request
import pandas as pd
import surprise
from surprise import Dataset, Reader
import pickle

app = Flask(__name__)

# Cargar los datos
data = pd.read_json("data/recomendaciones.json")
reader = Reader(rating_scale=(1, 5))
dataset = Dataset.load_from_df(data[['user_id', 'item_id', 'rating']], reader)

# Entrenar el modelo
model = surprise.SVD()
trainset = dataset.build_full_trainset()
model.fit(trainset)

# Rutas de la API
@app.route("/recomendacion", methods=["GET"])
def recomendar():
    user_id = int(request.args.get("user_id"))
    item_id = int(request.args.get("item_id"))
    prediction = model.predict(user_id, item_id)
    return jsonify({"prediccion": prediction.est})

if __name__ == "__main__":
    app.run(debug=True)
