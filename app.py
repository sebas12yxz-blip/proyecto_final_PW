from flask import Flask, render_template
from config import Config
from routes.motos import bp as motos_bp
from routes.repuestos import bp as repuestos_bp
from routes.clientes import bp as clientes_bp
from routes.vendedores import bp as vendedores_bp
from routes.ventas import bp as ventas_bp

app = Flask(__name__)
app.config.from_object(Config)

app.register_blueprint(motos_bp)
app.register_blueprint(repuestos_bp)
app.register_blueprint(clientes_bp)
app.register_blueprint(vendedores_bp)
app.register_blueprint(ventas_bp)

@app.route("/")
def inicio():
    return render_template("inicio.html")

if __name__ == "__main__":
    app.run(debug=True)