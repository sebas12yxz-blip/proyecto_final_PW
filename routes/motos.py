from flask import Blueprint, render_template, request, redirect, url_for, flash
from psycopg2 import errors
from db import get_conn

bp = Blueprint("motos", __name__, url_prefix="/motos")

TIPOS = ["automatica", "semiautomatica", "sport", "enduro",
         "cruiser", "aventura", "alto cilindraje"]


def validar(form):
    """Revisa los datos del formulario y devuelve una lista de errores."""
    errores = []
    modelo = form.get("modelo", "").strip()
    tipo = form.get("tipo", "")
    cilindraje = form.get("cilindraje_cc", "")
    anio = form.get("anio_modelo", "")
    precio = form.get("precio_lista", "")

    if not modelo:
        errores.append("El modelo es obligatorio.")
    if tipo not in TIPOS:
        errores.append("Selecciona un tipo de moto válido.")
    if not cilindraje.isdigit() or int(cilindraje) <= 0:
        errores.append("El cilindraje debe ser un número mayor que 0.")
    if not anio.isdigit() or not (2015 <= int(anio) <= 2030):
        errores.append("El año debe estar entre 2015 y 2030.")
    try:
        if float(precio) <= 0:
            errores.append("El precio debe ser mayor que 0.")
    except ValueError:
        errores.append("El precio debe ser un número.")
    return errores


# LISTAR
@bp.route("/")
def listar():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT * FROM motos ORDER BY modelo")
    motos = cur.fetchall()
    conn.close()
    return render_template("motos/listar.html", motos=motos)


# CREAR
@bp.route("/crear", methods=["GET", "POST"])
def crear():
    if request.method == "POST":
        errores = validar(request.form)
        if errores:
            for e in errores:
                flash(e, "danger")
            return render_template("motos/form.html", moto=request.form,
                                   tipos=TIPOS, titulo="Nueva moto")

        conn = get_conn()
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO motos (modelo, tipo, cilindraje_cc, anio_modelo, precio_lista)
                   VALUES (%s, %s, %s, %s, %s)""",
                (request.form["modelo"].strip(), request.form["tipo"],
                 request.form["cilindraje_cc"], request.form["anio_modelo"],
                 request.form["precio_lista"]))
            conn.commit()
            flash("Moto creada correctamente.", "success")
            return redirect(url_for("motos.listar"))
        except errors.UniqueViolation:
            conn.rollback()
            flash("Ya existe una moto con ese modelo.", "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al guardar la moto.", "danger")
        finally:
            conn.close()
        return render_template("motos/form.html", moto=request.form,
                               tipos=TIPOS, titulo="Nueva moto")

    return render_template("motos/form.html", moto={}, tipos=TIPOS, titulo="Nueva moto")


# EDITAR
@bp.route("/editar/<int:id>", methods=["GET", "POST"])
def editar(id):
    conn = get_conn()
    cur = conn.cursor()

    if request.method == "POST":
        errores = validar(request.form)
        if errores:
            for e in errores:
                flash(e, "danger")
            conn.close()
            return render_template("motos/form.html", moto=request.form,
                                   tipos=TIPOS, titulo="Editar moto")
        try:
            cur.execute(
                """UPDATE motos
                   SET modelo = %s, tipo = %s, cilindraje_cc = %s,
                       anio_modelo = %s, precio_lista = %s
                   WHERE id_moto = %s""",
                (request.form["modelo"].strip(), request.form["tipo"],
                 request.form["cilindraje_cc"], request.form["anio_modelo"],
                 request.form["precio_lista"], id))
            conn.commit()
            flash("Moto actualizada correctamente.", "success")
            return redirect(url_for("motos.listar"))
        except errors.UniqueViolation:
            conn.rollback()
            flash("Ya existe una moto con ese modelo.", "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al actualizar la moto.", "danger")
        finally:
            conn.close()
        return render_template("motos/form.html", moto=request.form,
                               tipos=TIPOS, titulo="Editar moto")

    # GET: cargar los datos actuales para precargar el formulario
    cur.execute("SELECT * FROM motos WHERE id_moto = %s", (id,))
    moto = cur.fetchone()
    conn.close()
    if moto is None:
        flash("La moto no existe.", "warning")
        return redirect(url_for("motos.listar"))
    return render_template("motos/form.html", moto=moto, tipos=TIPOS, titulo="Editar moto")


# ELIMINAR
@bp.route("/eliminar/<int:id>", methods=["POST"])
def eliminar(id):
    conn = get_conn()
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM motos WHERE id_moto = %s", (id,))
        conn.commit()
        flash("Moto eliminada correctamente.", "success")
    except (errors.ForeignKeyViolation, errors.RestrictViolation):
        conn.rollback()
        flash("No se puede eliminar: la moto tiene repuestos o ventas asociadas.", "warning")
    except Exception:
        conn.rollback()
        flash("Ocurrió un error al eliminar la moto.", "danger")
    finally:
        conn.close()
    return redirect(url_for("motos.listar"))