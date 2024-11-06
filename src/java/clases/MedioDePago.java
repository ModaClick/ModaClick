package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MedioDePago {
    private String id;
    private String tipoPago;
    private String descripcionMetodoPago;

    public MedioDePago() {
        
    }
    
    public MedioDePago(String id) {
        String cadenaSQL = "select tipoPago, descripcionMetodoPago from MedioPago where idMedioPago = " + id;
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        
        try {
            if (resultado.next()) {
                this.id = id;
                tipoPago = resultado.getString("tipoPago");
                descripcionMetodoPago = resultado.getString("descripcionMetodoPago");
            }       
        } catch (SQLException ex) {
            Logger.getLogger(MedioDePago.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTipoPago() {
        return tipoPago != null ? tipoPago : "";
    }

    public void setTipoPago(String tipoPago) {
        this.tipoPago = tipoPago;
    }

    public String getDescripcionMetodoPago() {
        return descripcionMetodoPago;
    }

    public void setDescripcionMetodoPago(String descripcionMetodoPago) {
        this.descripcionMetodoPago = descripcionMetodoPago;
    }

    @Override
    public String toString() {
        return tipoPago;
    }

    public boolean grabar() {
        String cadenaSQL = "insert into MedioPago (tipoPago, descripcionMetodoPago) values ('" + tipoPago + "', '" + descripcionMetodoPago + "')";
        return ConectorBD.ejecutarQuery(cadenaSQL);            
    }

    public boolean modificar() {
       String cadenaSQL = "update MedioPago set tipoPago = '" + tipoPago + "', descripcionMetodoPago = '" + descripcionMetodoPago + "' where idMedioPago = " + id;
       return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean eliminar() {
        String cadenaSQL = "delete from MedioPago where idMedioPago = " + id;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public static ResultSet getlista(String filtro, String orden) {
        if (filtro != null && !filtro.isEmpty()) filtro = "where " + filtro;
        else filtro = "";
        if (orden != null && !orden.isEmpty()) orden = " order by " + orden;
        else orden = "";
        String cadenaSQL = "select idMedioPago, tipoPago, descripcionMetodoPago from MedioPago " + filtro + orden;
        return ConectorBD.consultar(cadenaSQL);
    }

    public static List<MedioDePago> getListaEnObjetos(String filtro, String orden) {
        List<MedioDePago> lista = new ArrayList<>();
        ResultSet datos = MedioDePago.getlista(filtro, orden);
        
        if (datos != null) {
            try {
                while (datos.next()) {
                    MedioDePago medioP = new MedioDePago();
                    medioP.setId(datos.getString("idMedioPago"));
                    medioP.setTipoPago(datos.getString("tipoPago"));
                    medioP.setDescripcionMetodoPago(datos.getString("descripcionMetodoPago"));
                    lista.add(medioP);
                }
            } catch (SQLException ex) {
                Logger.getLogger(MedioDePago.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }

    public static String getListaEnOptions(String preseleccionado) {
        String lista = "";
        List<MedioDePago> datos = MedioDePago.getListaEnObjetos(null, "tipoPago");
        for (MedioDePago medioDePago : datos) {
            String auxiliar = "";
            if (preseleccionado.equals(medioDePago.getId())) auxiliar = " selected";
            lista += "<option value='" + medioDePago.getId() + "'" + auxiliar + ">" + medioDePago.getTipoPago() + "</option>";          
        }
        return lista;
    }
}

