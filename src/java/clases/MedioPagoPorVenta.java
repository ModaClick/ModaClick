package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MedioPagoPorVenta {
    private String idMedioPagoFactura;   
    private String idVentaDetalle;
    private String idPagos;
    private String fecha;
    private String valor;
    private String nombreMedioDePago;

    public MedioPagoPorVenta() {
    }

    public MedioPagoPorVenta(String idMedioPagoFactura) {
    String cadenaSQL = "SELECT idMedioPagoFactura, idVentaDetalle, idPagos, fecha, valor, tipopago "
            + "FROM MedioPagoPorVenta "
            + "INNER JOIN MedioPago ON MedioPago.idMedioPago = MedioPagoPorVenta.idPagos "
            + "WHERE idMedioPagoFactura = " + idMedioPagoFactura;
    
    try (ResultSet resultado = ConectorBD.consultar(cadenaSQL)) {
        if (resultado.next()) {
            this.idMedioPagoFactura = idMedioPagoFactura;
            idVentaDetalle = resultado.getString("idVentaDetalle");
            idPagos = resultado.getString("idPagos");
            fecha = resultado.getString("fecha");
            valor = resultado.getString("valor");
            nombreMedioDePago = resultado.getString("tipopago");
        }
    } catch (SQLException ex) {
        Logger.getLogger(MedioPagoPorVenta.class.getName()).log(Level.SEVERE, null, ex);
    }
}


    public String getIdMedioPagoFactura() {
        return idMedioPagoFactura;
    }

    public void setIdMedioPagoFactura(String id) {
        this.idMedioPagoFactura = id;
    }

    public MedioDePago getMedioDePago() {
        return new MedioDePago(idPagos);
    }

    public Venta getVenta() {
        return new Venta(idVentaDetalle);
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
        return nombreMedioDePago ;
    }

    public void setNombreMedioDePago(String nombreMedioDePago) {
        this.nombreMedioDePago = nombreMedioDePago;
    }

    public String getIdVentaDetalle() {
        return idVentaDetalle;
    }

    public void setIdVentaDetalle(String idVentaDetalle) {
        this.idVentaDetalle = idVentaDetalle;
    }

    @Override
    public String toString() {
        return idPagos;
    }

    public boolean grabar() {
        try {
            // Obtener el último idMedioPagoFactura
            String obtenerUltimoID = "SELECT MAX(idMedioPagoFactura) AS ultimoID FROM MedioPagoPorVenta";
            ResultSet rs = ConectorBD.consultar(obtenerUltimoID);

            int nuevoIdMedioPagoFactura = 1; // Valor inicial

            if (rs.next()) {
                int ultimoID = rs.getInt("ultimoID");
                nuevoIdMedioPagoFactura = ultimoID + 1;
            }

            // Usar el nuevo ID generado para el insert
            String cadenaSQL = "INSERT INTO MedioPagoPorVenta (idMedioPagoFactura, idVentaDetalle, idPagos, fecha, valor) "
                    + "VALUES ('" + nuevoIdMedioPagoFactura + "','" + idVentaDetalle + "','" + idPagos + "','" + fecha + "','" + valor + "')";
            return ConectorBD.ejecutarQuery(cadenaSQL);

        } catch (SQLException ex) {
            Logger.getLogger(MedioPagoPorVenta.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public boolean modificar() {
        String cadenaSQL = "update MedioPagoPorVenta set idMedioPagoFactura='" + idMedioPagoFactura + "', idVentaDetalle='" + idVentaDetalle + "', idPagos='" + idPagos + "', fecha='" + fecha + "', valor='" + valor + "' where idMedioPagoFactura =" + idMedioPagoFactura;
        return ConectorBD.ejecutarQuery(cadenaSQL);

    }

    public boolean eliminar() {
        // Crear la consulta SQL para eliminar el pago
        String cadenaSQL = "DELETE FROM MedioPagoPorVenta WHERE idMedioPagoFactura = " + idMedioPagoFactura;
        // Ejecutar la consulta de eliminación
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }
    
    ResultSet resultados = MedioPagoPorVenta.getLista("idVentaDetalle='1' AND idMedioPago='1'", "idMedioPago");

      public static ResultSet getLista(String filtro, String orden){
        if(filtro!=null && filtro!="")filtro=" where "+filtro;
        else filtro="";
        if(orden!=null && orden!="")orden=" order by "+orden;
        else orden ="";
        String cadenaSQL = "SELECT MedioPagoPorVenta.idMedioPagoFactura, idVentaDetalle, idPagos, fecha, valor, MedioPago.tipopago " +
                       "FROM MedioPagoPorVenta " +
                       "INNER JOIN MedioPago ON MedioPago.idMedioPago = MedioPagoPorVenta.idPagos " +
                       filtro + orden;
        return ConectorBD.consultar(cadenaSQL);
    }
   
                      

 

    public static List<MedioPagoPorVenta> getListaEnObjetos(String filtro, String orden) {
        List<MedioPagoPorVenta> lista = new ArrayList<>();
        try (ResultSet datos = MedioPagoPorVenta.getLista(filtro, orden)) {
            while (datos != null && datos.next()) {
                MedioPagoPorVenta medioVenta = new MedioPagoPorVenta();
                medioVenta.setIdMedioPagoFactura(datos.getString("idMedioPagoFactura"));
                medioVenta.setIdVentaDetalle(datos.getString("idVentaDetalle"));
                medioVenta.setIdPagos(datos.getString("idPagos"));
                medioVenta.setFecha(datos.getString("fecha"));
                medioVenta.setValor(datos.getString("valor"));                    
                medioVenta.setNombreMedioDePago(datos.getString("tipopago"));                    
                lista.add(medioVenta);
            }
        } catch (SQLException ex) {
            Logger.getLogger(MedioPagoPorVenta.class.getName()).log(Level.SEVERE, null, ex);
        }
        return lista;
    }
}
