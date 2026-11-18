from flask import Blueprint, render_template, request, redirect, url_for, flash
from psycopg2 import errors
from db import get_conn

bp = Blueprint("clientes", __name__, url_prefix="/clientes")


def validar(form):
    """Revisa los datos del formulario y devuelve una lista de errores."""
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
    if not form.get("ciudad", "").strip():
        errores.append("La ciudad es obligatoria.")
    return errores


def datos_formulario(form):
    """Devuelve los datos limpios, en el mismo orden de las columnas del INSERT y del UPDATE."""
    return (form["cedula"].strip(), form["nombres"].strip(), form["apellidos"].strip(),
            form["telefono"].strip(), form["correo"].strip().lower(), form["ciudad"].strip())


def mensaje_duplicado(e):
    """Indica qué dato se repitió, según la restricción UNIQUE que falló."""
    if "cedula" in (e.diag.constraint_name or ""):
        return "Ya existe un cliente con esa cédula."
    return "Ya existe un cliente con ese correo."


# LISTAR
@bp.route("/")
def listar():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT * FROM clientes ORDER BY apellidos, nombres")
    clientes = cur.fetchall()
    conn.close()
    return render_template("clientes/listar.html", clientes=clientes)


# CREAR
@bp.route("/crear", methods=["GET", "POST"])
def crear():
    if request.method == "POST":
        errores = validar(request.form)
        if errores:
            for error in errores:
                flash(error, "danger")
            return render_template("clientes/form.html", cliente=request.form, titulo="Nuevo cliente")

        conn = get_conn()
        cur = conn.cursor()
        try:
            cur.execute(
                """INSERT INTO clientes (cedula, nombres, apellidos, telefono, correo, ciudad)
                   VALUES (%s, %s, %s, %s, %s, %s)""",
                datos_formulario(request.form))
            conn.commit()
            flash("Cliente creado correctamente.", "success")
            return redirect(url_for("clientes.listar"))
        except errors.UniqueViolation as e:
            conn.rollback()
            flash(mensaje_duplicado(e), "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al guardar el cliente.", "danger")
        finally:
            conn.close()
        return render_template("clientes/form.html", cliente=request.form, titulo="Nuevo cliente")

    return render_template("clientes/form.html", cliente={}, titulo="Nuevo cliente")


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
            return render_template("clientes/form.html", cliente=request.form, titulo="Editar cliente")
        try:
            cur.execute(
                """UPDATE clientes
                   SET cedula = %s, nombres = %s, apellidos = %s,
                       telefono = %s, correo = %s, ciudad = %s
                   WHERE id_cliente = %s""",
                datos_formulario(request.form) + (id,))
            conn.commit()
            flash("Cliente actualizado correctamente.", "success")
            return redirect(url_for("clientes.listar"))
        except errors.UniqueViolation as e:
            conn.rollback()
            flash(mensaje_duplicado(e), "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al actualizar el cliente.", "danger")
        finally:
            conn.close()
        return render_template("clientes/form.html", cliente=request.form, titulo="Editar cliente")

    cur.execute("SELECT * FROM clientes WHERE id_cliente = %s", (id,))
    cliente = cur.fetchone()
    conn.close()
    if cliente is None:
        flash("El cliente no existe.", "warning")
        return redirect(url_for("clientes.listar"))
    return render_template("clientes/form.html", cliente=cliente, titulo="Editar cliente")


# ELIMINAR
@bp.route("/eliminar/<int:id>", methods=["POST"])
def eliminar(id):
    conn = get_conn()
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM clientes WHERE id_cliente = %s", (id,))
        conn.commit()
        flash("Cliente eliminado correctamente.", "success")
    except (errors.ForeignKeyViolation, errors.RestrictViolation):
        conn.rollback()
        flash("No se puede eliminar: el cliente tiene ventas registradas.", "warning")
    except Exception:
        conn.rollback()
        flash("Ocurrió un error al eliminar el cliente.", "danger")
    finally:
        conn.close()
    return redirect(url_for("clientes.listar"))