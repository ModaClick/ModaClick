package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MedioPagoPorCompra {
    private String idMedioPagoCompra;   
    private String idCompraDetalle;
    private String idPagos;
    private String fecha;
    private String valor;
    private String nombreMedioDePago;

    public MedioPagoPorCompra() {
    }

    public MedioPagoPorCompra(String idMedioPagoCompra) {
        String cadenaSQL = "SELECT idMedioPagoCompra, idCompraDetalle, idPagos, fecha, valor, tipopago "
                + "FROM MedioPagoPorCompra "
                + "INNER JOIN MedioPago ON MedioPago.idMedioPago = MedioPagoPorCompra.idPagos "
                + "WHERE idMedioPagoCompra = " + idMedioPagoCompra;
        
        try (ResultSet resultado = ConectorBD.consultar(cadenaSQL)) {
            if (resultado.next()) {
                this.idMedioPagoCompra = idMedioPagoCompra;
                idCompraDetalle = resultado.getString("idCompraDetalle");
                idPagos = resultado.getString("idPagos");
                fecha = resultado.getString("fecha");
                valor = resultado.getString("valor");
                nombreMedioDePago = resultado.getString("tipopago");
            }
        } catch (SQLException ex) {
            Logger.getLogger(MedioPagoPorCompra.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getIdMedioPagoCompra() {
        return idMedioPagoCompra;
    }

    public void setIdMedioPagoCompra(String id) {
        this.idMedioPagoCompra = id;
    }

    public MedioDePago getMedioDePago() {
        return new MedioDePago(idPagos);
    }

    public Compra getCompra() {
        return new Compra(idCompraDetalle);
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getIdPagos() {
        return idPagos;
    }

    public void setIdPagos(String idPagos) {
        this.idPagos = idPagos;
    }

    public String getValor() {
        return valor;
    }

    public void setValor(String valor) {
        this.valor = valor;
    }

    public String getNombreMedioDePago() {
        return nombreMedioDePago;
    }

    public void setNombreMedioDePago(String nombreMedioDePago) {
        this.nombreMedioDePago = nombreMedioDePago;
    }

    public String getIdCompraDetalle() {
        return idCompraDetalle;
    }

    public void setIdCompraDetalle(String idCompraDetalle) {
        this.idCompraDetalle = idCompraDetalle;
    }

    @Override
    public String toString() {
        return idPagos;
    }

    public boolean grabar() {
    try {
        // Obtener el último idMedioPagoCompra
        String obtenerUltimoID = "SELECT MAX(idMedioPagoCompra) AS ultimoID FROM MedioPagoPorCompra";
        ResultSet rs = ConectorBD.consultar(obtenerUltimoID);

        int nuevoIdMedioPagoCompra = 1; // Valor inicial

        if (rs.next()) {
            int ultimoID = rs.getInt("ultimoID");
            nuevoIdMedioPagoCompra = ultimoID + 1;
        }

        // Usar el nuevo ID generado para el insert
        String cadenaSQL = "INSERT INTO MedioPagoPorCompra (idMedioPagoCompra, idCompraDetalle, idPagos, fecha, valor) "
                + "VALUES ('" + nuevoIdMedioPagoCompra + "','" + idCompraDetalle + "','" + idPagos + "','" + fecha + "','" + valor + "')";
        
        // Ejecutar la consulta
        return ConectorBD.ejecutarQuery(cadenaSQL);

    } catch (SQLException ex) {
        Logger.getLogger(MedioPagoPorCompra.class.getName()).log(Level.SEVERE, "Error al grabar el medio de pago por compra", ex);
        return false;
    }
}


    public boolean modificar() {
        String cadenaSQL = "update MedioPagoPorCompra set idMedioPagoCompra='" + idMedioPagoCompra + "', idCompraDetalle='" + idCompraDetalle + "', idPagos='" + idPagos + "', fecha='" + fecha + "', valor='" + valor + "' where idMedioPagoCompra =" + idMedioPagoCompra;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean eliminar(){
        String cadenaSQL = "delete from MedioPagoPorCompra where idMedioPagoCompra=" + idMedioPagoCompra;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public static ResultSet getLista(String filtro, String orden){
        if(filtro != null && filtro != "") filtro = " where " + filtro;
        else filtro = "";
        if(orden != null && orden != "") orden = " order by " + orden;
        else orden = "";
        String cadenaSQL = "SELECT MedioPagoPorCompra.idMedioPagoCompra, idCompraDetalle, idPagos, fecha, valor, MedioPago.tipopago " +
                           "FROM MedioPagoPorCompra " +
                           "INNER JOIN MedioPago ON MedioPago.idMedioPago = MedioPagoPorCompra.idPagos " +
                           filtro + orden;
        return ConectorBD.consultar(cadenaSQL);
    }

    public static List<MedioPagoPorCompra> getListaEnObjetos(String filtro, String orden) {
        List<MedioPagoPorCompra> lista = new ArrayList<>();
        try (ResultSet datos = MedioPagoPorCompra.getLista(filtro, orden)) {
            while (datos != null && datos.next()) {
                MedioPagoPorCompra medioCompra = new MedioPagoPorCompra();
                medioCompra.setIdMedioPagoCompra(datos.getString("idMedioPagoCompra"));
                medioCompra.setIdCompraDetalle(datos.getString("idCompraDetalle"));
                medioCompra.setIdPagos(datos.getString("idPagos"));
                medioCompra.setFecha(datos.getString("fecha"));
                medioCompra.setValor(datos.getString("valor"));                    
                medioCompra.setNombreMedioDePago(datos.getString("tipopago"));                    
                lista.add(medioCompra);
            }
        } catch (SQLException ex) {
            Logger.getLogger(MedioPagoPorCompra.class.getName()).log(Level.SEVERE, null, ex);
        }
        return lista;
    }
}
