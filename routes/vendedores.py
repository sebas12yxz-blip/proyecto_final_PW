from datetime import date
from flask import Blueprint, render_template, request, redirect, url_for, flash
from psycopg2 import errors
from db import get_conn

bp = Blueprint("vendedores", __name__, url_prefix="/vendedores")


def fecha_valida(texto):
    """True si el texto es una fecha AAAA-MM-DD que no está en el futuro."""
    try:
        return date.fromisoformat(texto) <= date.today()
    except ValueError:
        return False


def validar(form):
    errores = []
    cedula = form.get("cedula", "").strip()
    telefono = form.get("telefono", "").strip()
    correo = form.get("correo", "").strip()

    if not cedula.isdigit() or not (6 <= len(cedula) <= 10):
        errores.append("La cédula debe tener entre 6 y 10 números, sin puntos ni espacios.")
    if not form.get("nombres", "").strip():
        errores.append("Los nombres son obligatorios.")
    if not form.get("apellidos", "").strip():
        errores.append("Los apellidos son obligatorios.")
    if not telefono.isdigit() or len(telefono) != 10:
        errores.append("El teléfono debe tener exactamente 10 números, sin espacios.")
    if "@" not in correo or "." not in correo.split("@")[-1]:
        errores.append("Escribe un correo válido, por ejemplo nombre@gmail.com.")
    if not fecha_valida(form.get("fecha_ingreso", "")):
        errores.append("La fecha de ingreso es obligatoria y no puede ser una fecha futura.")
    try:
        comision = float(form.get("comision_pct", ""))
        if not (0 <= comision <= 100):
            errores.append("La comisión debe estar entre 0 y 100.")
    except ValueError:
        errores.append("La comisión debe ser un número.")
    return errores


def datos_formulario(form):
    return (form["cedula"].strip(), form["nombres"].strip(), form["apellidos"].strip(),
            form["telefono"].strip(), form["correo"].strip().lower(),
            form["fecha_ingreso"], form["comision_pct"])


def mensaje_duplicado(e):
    if "cedula" in (e.diag.constraint_name or ""):
        return "Ya existe un vendedor con esa cédula."
    return "Ya existe un vendedor con ese correo."


# LISTAR
@bp.route("/")
def listar():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT * FROM vendedores ORDER BY apellidos, nombres")
    vendedores = cur.fetchall()
    conn.close()
    return render_template("vendedores/listar.html", vendedores=vendedores)


# CREAR
@bp.route("/crear", methods=["GET", "POST"])
def crear():
    if request.method == "POST":
        errores = validar(request.form)
        if errores:
            for error in errores:
                flash(error, "danger")
            return render_template("vendedores/form.html", vendedor=request.form, titulo="Nuevo vendedor")

        conn = get_conn()
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO vendedores (cedula, nombres, apellidos, telefono, correo,
                                           fecha_ingreso, comision_pct)
                   VALUES (%s, %s, %s, %s, %s, %s, %s)""",
                datos_formulario(request.form))
            conn.commit()
            flash("Vendedor creado correctamente.", "success")
            return redirect(url_for("vendedores.listar"))
        except errors.UniqueViolation as e:
            conn.rollback()
            flash(mensaje_duplicado(e), "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al guardar el vendedor.", "danger")
        finally:
            conn.close()
        return render_template("vendedores/form.html", vendedor=request.form, titulo="Nuevo vendedor")

    return render_template("vendedores/form.html", vendedor={}, titulo="Nuevo vendedor")


# EDITAR
@bp.route("/editar/<int:id>", methods=["GET", "POST"])
def editar(id):
    conn = get_conn()
    cur = conn.cursor()

    if request.method == "POST":
        errores = validar(request.form)
        if errores:
            for error in errores:
                flash(error, "danger")
            conn.close()
            return render_template("vendedores/form.html", vendedor=request.form, titulo="Editar vendedor")
        try:
            cur.execute(
                """UPDATE vendedores
                   SET cedula = %s, nombres = %s, apellidos = %s, telefono = %s,
                       correo = %s, fecha_ingreso = %s, comision_pct = %s
                   WHERE id_vendedor = %s""",
                datos_formulario(request.form) + (id,))
            conn.commit()
            flash("Vendedor actualizado correctamente.", "success")
            return redirect(url_for("vendedores.listar"))
        except errors.UniqueViolation as e:
            conn.rollback()
            flash(mensaje_duplicado(e), "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al actualizar el vendedor.", "danger")
        finally:
            conn.close()
        return render_template("vendedores/form.html", vendedor=request.form, titulo="Editar vendedor")

    cur.execute("SELECT * FROM vendedores WHERE id_vendedor = %s", (id,))
    vendedor = cur.fetchone()
    conn.close()
    if vendedor is None:
        flash("El vendedor no existe.", "warning")
        return redirect(url_for("vendedores.listar"))
    return render_template("vendedores/form.html", vendedor=vendedor, titulo="Editar vendedor")


# ELIMINAR
@bp.route("/eliminar/<int:id>", methods=["POST"])
def eliminar(id):
    conn = get_conn()
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM vendedores WHERE id_vendedor = %s", (id,))
        conn.commit()
        flash("Vendedor eliminado correctamente.", "success")
    except (errors.ForeignKeyViolation, errors.RestrictViolation):
        conn.rollback()
        flash("No se puede eliminar: el vendedor tiene ventas registradas.", "warning")
    except Exception:
        conn.rollback()
        flash("Ocurrió un error al eliminar el vendedor.", "danger")
    finally:
        conn.close()
    return redirect(url_for("vendedores.listar"))