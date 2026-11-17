from flask import Blueprint, render_template, request, redirect, url_for, flash
from psycopg2 import errors
from db import get_conn

bp = Blueprint("repuestos", __name__, url_prefix="/repuestos")


def obtener_motos(cur):
    """Devuelve las motos para llenar la lista desplegable."""
    cur.execute("SELECT id_moto, modelo FROM motos ORDER BY modelo")
    return cur.fetchall()


def validar(form):
    errores = []
    if not form.get("id_moto", "").isdigit():
        errores.append("Selecciona la moto a la que pertenece el repuesto.")
    if not form.get("referencia", "").strip():
        errores.append("La referencia es obligatoria.")
    if not form.get("nombre", "").strip():
        errores.append("El nombre es obligatorio.")
    try:
        if float(form.get("precio", "")) <= 0:
            errores.append("El precio debe ser mayor que 0.")
    except ValueError:
        errores.append("El precio debe ser un número.")
    if not form.get("stock", "").isdigit():
        errores.append("El stock debe ser un número entero mayor o igual a 0.")
    return errores


# LISTAR (con JOIN para mostrar el nombre de la moto, no su ID)
@bp.route("/")
def listar():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("""SELECT r.id_repuesto, r.referencia, r.nombre, r.precio, r.stock, m.modelo
                   FROM repuestos r
                   JOIN motos m ON m.id_moto = r.id_moto
                   ORDER BY r.nombre""")
    repuestos = cur.fetchall()
    conn.close()
    return render_template("repuestos/listar.html", repuestos=repuestos)


# CREAR
@bp.route("/crear", methods=["GET", "POST"])
def crear():
    conn = get_conn()
    cur = conn.cursor()
    motos = obtener_motos(cur)

    if request.method == "POST":
        errores = validar(request.form)
        if errores:
            for e in errores:
                flash(e, "danger")
            conn.close()
            return render_template("repuestos/form.html", repuesto=request.form,
                                   motos=motos, titulo="Nuevo repuesto")
        try:
            cur.execute(
                """INSERT INTO repuestos (id_moto, referencia, nombre, precio, stock)
                   VALUES (%s, %s, %s, %s, %s)""",
                (request.form["id_moto"], request.form["referencia"].strip(),
                 request.form["nombre"].strip(), request.form["precio"],
                 request.form["stock"]))
            conn.commit()
            flash("Repuesto creado correctamente.", "success")
            return redirect(url_for("repuestos.listar"))
        except errors.UniqueViolation:
            conn.rollback()
            flash("Ya existe un repuesto con esa referencia.", "warning")
        except errors.ForeignKeyViolation:
            conn.rollback()
            flash("La moto seleccionada no existe.", "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al guardar el repuesto.", "danger")
        finally:
            conn.close()
        return render_template("repuestos/form.html", repuesto=request.form,
                               motos=motos, titulo="Nuevo repuesto")

    conn.close()
    return render_template("repuestos/form.html", repuesto={}, motos=motos,
                           titulo="Nuevo repuesto")


# EDITAR
@bp.route("/editar/<int:id>", methods=["GET", "POST"])
def editar(id):
    conn = get_conn()
    cur = conn.cursor()
    motos = obtener_motos(cur)

    if request.method == "POST":
        errores = validar(request.form)
        if errores:
            for e in errores:
                flash(e, "danger")
            conn.close()
            return render_template("repuestos/form.html", repuesto=request.form,
                                   motos=motos, titulo="Editar repuesto")
        try:
            cur.execute(
                """UPDATE repuestos
                   SET id_moto = %s, referencia = %s, nombre = %s, precio = %s, stock = %s
                   WHERE id_repuesto = %s""",
                (request.form["id_moto"], request.form["referencia"].strip(),
                 request.form["nombre"].strip(), request.form["precio"],
                 request.form["stock"], id))
            conn.commit()
            flash("Repuesto actualizado correctamente.", "success")
            return redirect(url_for("repuestos.listar"))
        except errors.UniqueViolation:
            conn.rollback()
            flash("Ya existe un repuesto con esa referencia.", "warning")
        except errors.ForeignKeyViolation:
            conn.rollback()
            flash("La moto seleccionada no existe.", "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al actualizar el repuesto.", "danger")
        finally:
            conn.close()
        return render_template("repuestos/form.html", repuesto=request.form,
                               motos=motos, titulo="Editar repuesto")

    cur.execute("SELECT * FROM repuestos WHERE id_repuesto = %s", (id,))
    repuesto = cur.fetchone()
    conn.close()
    if repuesto is None:
        flash("El repuesto no existe.", "warning")
        return redirect(url_for("repuestos.listar"))
    return render_template("repuestos/form.html", repuesto=repuesto, motos=motos,
                           titulo="Editar repuesto")


# ELIMINAR
@bp.route("/eliminar/<int:id>", methods=["POST"])
def eliminar(id):
    conn = get_conn()
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM repuestos WHERE id_repuesto = %s", (id,))
        conn.commit()
        flash("Repuesto eliminado correctamente.", "success")
    except Exception:
        conn.rollback()
        flash("Ocurrió un error al eliminar el repuesto.", "danger")
    finally:
        conn.close()
    return redirect(url_for("repuestos.listar"))