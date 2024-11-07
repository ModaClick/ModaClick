package clases;

import clases.CompraDetalle;
import clases.MedioPagoPorCompra;
import clases.Persona;
import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Compra {
    private String idCompra;
    private String idProveedor;
    private String fechaCompra;
    private String nombresProveedor;
    private int total;
    private int abonado;

    public Compra() {
        System.out.println("Inicializando objeto Compra vacío.");
    }

    public Compra(String idCompra) {
        this.idCompra = idCompra;
        String cadenaSQL = "SELECT idProveedor, fechaCompra, nombre, "
                + "getTotalCompra(idCompra) AS total, getAbonadoCompra(idCompra) AS Abonado "
                + "FROM compra INNER JOIN Persona ON identificacion = idProveedor WHERE idCompra = " + idCompra;

        System.out.println("Consulta SQL para cargar compra: " + cadenaSQL);
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                idProveedor = resultado.getString("idProveedor");
                nombresProveedor = resultado.getString("nombre");
                fechaCompra = resultado.getString("fechaCompra");
                total = resultado.getInt("total");
                abonado = resultado.getInt("Abonado");
                System.out.println("Compra cargada: idProveedor=" + idProveedor + ", nombreProveedor=" + nombresProveedor + ", total=" + total + ", abonado=" + abonado);
            } else {
                System.out.println("No se encontró la compra con id: " + idCompra);
            }
        } catch (SQLException ex) {
            Logger.getLogger(Compra.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getNombresCompletosProveedor() {
        return nombresProveedor != null ? nombresProveedor : "";
    }

    public List<MedioPagoPorCompra> getMediosDePago() {
        List<MedioPagoPorCompra> lista = MedioPagoPorCompra.getListaEnObjetos("idCompraDetalle='" + idCompra + "'", null);
        System.out.println("Medios de pago obtenidos para la compra " + idCompra + ": " + lista);
        return lista;
    }

    public String getIdCompra() {
        return idCompra != null ? idCompra : "";
    }

    public void setIdCompra(String idCompra) {
        this.idCompra = idCompra;
    }

    public String getIdProveedor() {
        return idProveedor != null ? idProveedor : "";
    }

    public void setIdProveedor(String idProveedor) {
        this.idProveedor = idProveedor;
    }

    public Persona getProveedor() {
        return new Persona(idProveedor);
    }

    public String getFechaCompra() {
        return fechaCompra != null ? fechaCompra : "";
    }

    public void setFechaCompra(String fechaCompra) {
        this.fechaCompra = fechaCompra;
    }

    public String getNombresProveedor() {
        return nombresProveedor != null ? nombresProveedor : "";
    }

    public void setNombresProveedor(String nombresProveedor) {
        this.nombresProveedor = nombresProveedor;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getAbonado() {
        return abonado;
    }

    public void setAbonado(int abonado) {
        this.abonado = abonado;
    }

    public int getSaldo() {
        return total - abonado;
    }

    public static ResultSet getLista(String filtro, String orden) {
        if (filtro != null && !filtro.isEmpty()) {
            filtro = " WHERE " + filtro;
        } else {
            filtro = "";
        }
        if (orden != null && !orden.isEmpty()) {
            orden = " ORDER BY " + orden;
        } else {
            orden = "";
        }

        String cadenaSQL = "SELECT c.idCompra, c.idProveedor, c.fechaCompra, p.nombre, "
                + "getTotalCompra(c.idCompra) AS Total, getAbonadoCompra(c.idCompra) AS Abonado, "
                + "i.nombreArticulo "
                + "FROM compra c "
                + "INNER JOIN Persona p ON p.identificacion = c.idProveedor "
                + "INNER JOIN compraDetalle cd ON c.idCompra = cd.idCompraDetalle "
                + "INNER JOIN Inventario i ON i.idArticulo = cd.idArticuloInventario "
                + filtro + orden;

        System.out.println("Cadena productos: " + cadenaSQL);
        return ConectorBD.consultar(cadenaSQL);
    }

    public static List<Compra> getListaEnObjetos(String filtro, String orden) {
        List<Compra> lista = new ArrayList<>();
        ResultSet datos = getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    Compra compra = new Compra();
                    compra.setIdCompra(datos.getString("idCompra"));
                    compra.setIdProveedor(datos.getString("idProveedor"));
                    compra.setFechaCompra(datos.getString("fechaCompra"));
                    compra.setNombresProveedor(datos.getString("nombre"));
                    compra.setTotal(datos.getInt("Total"));
                    compra.setAbonado(datos.getInt("Abonado"));
                    lista.add(compra);
                    System.out.println("Compra agregada a la lista: " + compra.getIdCompra());
                }
            } catch (SQLException ex) {
                Logger.getLogger(Compra.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }

    public boolean grabar() {
        String cadenaSQL = "INSERT INTO Compra (idProveedor, fechaCompra) VALUES ('" + idProveedor + "', NOW())";
        System.out.println("Insertando compra: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean grabarConProcedimientoAlmacenado(String cadenaArticulos, String cadenaMediosPago) {
        String cadenaSQL = "call RegistrarCompraEnModaClick('" + this.idProveedor + "','" + cadenaArticulos + "','"
                + cadenaMediosPago + "')";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean modificar(String idAnterior) {
        String cadenaSQL = "UPDATE Compra SET idProveedor = '" + idProveedor + "', fechaCompra = NOW() WHERE idCompra = " + idAnterior;
        System.out.println("Modificando compra: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public List<CompraDetalle> getDetalles() {
        return CompraDetalle.getListaEnObjetos("idCompraDetalle='" + idCompra + "'", null);
    }

    public boolean eliminarConProcedimiento() {
        String cadenaSQL = "CALL EliminarCompraConDetalles(" + idCompra + ")";
        System.out.println("Ejecutando eliminación de la compra con el procedimiento almacenado: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    @Override
    public String toString() {
        return idCompra + " " + fechaCompra;
    }
}
