from datetime import date
from flask import Blueprint, render_template, request, redirect, url_for, flash
from psycopg2 import errors
from db import get_conn

bp = Blueprint("ventas", __name__, url_prefix="/ventas")

FORMAS_PAGO = ["contado", "credito"]


def fecha_valida(texto):
    try:
        return date.fromisoformat(texto) <= date.today()
    except ValueError:
        return False


def obtener_listas(cur):
    """Consulta clientes, vendedores y motos para llenar las 3 listas desplegables."""
    cur.execute("SELECT id_cliente, nombres, apellidos, cedula FROM clientes ORDER BY apellidos, nombres")
    clientes = cur.fetchall()
    cur.execute("SELECT id_vendedor, nombres, apellidos FROM vendedores ORDER BY apellidos, nombres")
    vendedores = cur.fetchall()
    cur.execute("SELECT id_moto, modelo, precio_lista FROM motos ORDER BY modelo")
    motos = cur.fetchall()
    return {"clientes": clientes, "vendedores": vendedores, "motos": motos,
            "formas_pago": FORMAS_PAGO}


def validar(form):
    errores = []
    if not form.get("id_cliente", "").isdigit():
        errores.append("Selecciona el cliente que realiza la compra.")
    if not form.get("id_vendedor", "").isdigit():
        errores.append("Selecciona el vendedor que realiza la venta.")
    if not form.get("id_moto", "").isdigit():
        errores.append("Selecciona la moto vendida.")
    if not fecha_valida(form.get("fecha_venta", "")):
        errores.append("La fecha de venta es obligatoria y no puede ser una fecha futura.")
    if not form.get("numero_chasis", "").strip():
        errores.append("El número de chasis es obligatorio.")
    if form.get("forma_pago", "") not in FORMAS_PAGO:
        errores.append("Selecciona una forma de pago válida.")
    try:
        if float(form.get("precio_final", "")) <= 0:
            errores.append("El precio final debe ser mayor que 0.")
    except ValueError:
        errores.append("El precio final debe ser un número.")
    return errores


def datos_formulario(form):
    return (form["id_cliente"], form["id_vendedor"], form["id_moto"], form["fecha_venta"],
            form["numero_chasis"].strip().upper(), form["forma_pago"], form["precio_final"])


# LISTAR (JOIN con 3 tablas para mostrar nombres, no ID)
@bp.route("/")
def listar():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("""SELECT v.id_venta, v.fecha_venta, v.numero_chasis, v.forma_pago, v.precio_final,
                          c.nombres || ' ' || c.apellidos AS cliente,
                          ve.nombres || ' ' || ve.apellidos AS vendedor,
                          m.modelo
                   FROM ventas v
                   JOIN clientes c    ON c.id_cliente = v.id_cliente
                   JOIN vendedores ve ON ve.id_vendedor = v.id_vendedor
                   JOIN motos m       ON m.id_moto = v.id_moto
                   ORDER BY v.fecha_venta DESC""")
    ventas = cur.fetchall()
    conn.close()
    return render_template("ventas/listar.html", ventas=ventas)


# CREAR
@bp.route("/crear", methods=["GET", "POST"])
def crear():
    conn = get_conn()
    cur = conn.cursor()
    listas = obtener_listas(cur)

    if request.method == "POST":
        errores = validar(request.form)
        if errores:
            for error in errores:
                flash(error, "danger")
            conn.close()
            return render_template("ventas/form.html", venta=request.form,
                                   titulo="Nueva venta", **listas)
        try:
            cur.execute(
                """INSERT INTO ventas (id_cliente, id_vendedor, id_moto, fecha_venta,
                                       numero_chasis, forma_pago, precio_final)
                   VALUES (%s, %s, %s, %s, %s, %s, %s)""",
                datos_formulario(request.form))
            conn.commit()
            flash("Venta registrada correctamente.", "success")
            return redirect(url_for("ventas.listar"))
        except errors.UniqueViolation:
            conn.rollback()
            flash("Ya existe una venta con ese número de chasis.", "warning")
        except errors.ForeignKeyViolation:
            conn.rollback()
            flash("El cliente, vendedor o moto seleccionado no existe.", "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al registrar la venta.", "danger")
        finally:
            conn.close()
        return render_template("ventas/form.html", venta=request.form,
                               titulo="Nueva venta", **listas)

    conn.close()
    # La fecha de hoy aparece llena por defecto
    return render_template("ventas/form.html", venta={"fecha_venta": date.today().isoformat()},
                           titulo="Nueva venta", **listas)


# EDITAR
@bp.route("/editar/<int:id>", methods=["GET", "POST"])
def editar(id):
    conn = get_conn()
    cur = conn.cursor()
    listas = obtener_listas(cur)

    if request.method == "POST":
        errores = validar(request.form)
        if errores:
            for error in errores:
                flash(error, "danger")
            conn.close()
            return render_template("ventas/form.html", venta=request.form,
                                   titulo="Editar venta", **listas)
        try:
            cur.execute(
                """UPDATE ventas
                   SET id_cliente = %s, id_vendedor = %s, id_moto = %s, fecha_venta = %s,
                       numero_chasis = %s, forma_pago = %s, precio_final = %s
                   WHERE id_venta = %s""",
                datos_formulario(request.form) + (id,))
            conn.commit()
            flash("Venta actualizada correctamente.", "success")
            return redirect(url_for("ventas.listar"))
        except errors.UniqueViolation:
            conn.rollback()
            flash("Ya existe una venta con ese número de chasis.", "warning")
        except errors.ForeignKeyViolation:
            conn.rollback()
            flash("El cliente, vendedor o moto seleccionado no existe.", "warning")
        except Exception:
            conn.rollback()
            flash("Ocurrió un error al actualizar la venta.", "danger")
        finally:
            conn.close()
        return render_template("ventas/form.html", venta=request.form,
                               titulo="Editar venta", **listas)

    cur.execute("SELECT * FROM ventas WHERE id_venta = %s", (id,))
    venta = cur.fetchone()
    conn.close()
    if venta is None:
        flash("La venta no existe.", "warning")
        return redirect(url_for("ventas.listar"))
    return render_template("ventas/form.html", venta=venta, titulo="Editar venta", **listas)


# ELIMINAR
@bp.route("/eliminar/<int:id>", methods=["POST"])
def eliminar(id):
    conn = get_conn()
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM ventas WHERE id_venta = %s", (id,))
        conn.commit()
        flash("Venta eliminada correctamente.", "success")
    except Exception:
        conn.rollback()
        flash("Ocurrió un error al eliminar la venta.", "danger")
    finally:
        conn.close()
    return redirect(url_for("ventas.listar"))