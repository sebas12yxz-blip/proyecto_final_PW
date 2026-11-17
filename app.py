from flask import Flask, render_template
from config import Config
from routes.motos import bp as motos_bp
from routes.repuestos import bp as repuestos_bp

app = Flask(__name__)
app.config.from_object(Config)

app.register_blueprint(motos_bp)
app.register_blueprint(repuestos_bp)

@app.route("/")
def inicio():
    return render_template("inicio.html")

if __name__ == "__main__":
    app.run(debug=True)