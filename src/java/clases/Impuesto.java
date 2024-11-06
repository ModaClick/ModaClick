package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Impuesto {

    private String idImpuesto;
    private String nombre;
    private String porcentaje;
    private String descripcion;

    // Constructor por defecto
    public Impuesto() {
    }

    // Constructor que carga un impuesto desde la base de datos por su id
    public Impuesto(String idImpuesto) {
        String cadenaSQL = "SELECT nombre, porcentaje, descripcion FROM impuesto WHERE idImpuesto = '" + idImpuesto + "'";
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.idImpuesto = idImpuesto;
                this.nombre = resultado.getString("nombre");
                this.porcentaje = resultado.getString("porcentaje");
                this.descripcion = resultado.getString("descripcion");
            }
        } catch (SQLException ex) {
            Logger.getLogger(Impuesto.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Getters y Setters
    public String getIdImpuesto() {
        return idImpuesto;
    }

    public void setIdImpuesto(String idImpuesto) {
        this.idImpuesto = idImpuesto;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getPorcentaje() {
        return porcentaje;
    }

    public void setPorcentaje(String porcentaje) {
        this.porcentaje = porcentaje;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    // Método para grabar un nuevo impuesto en la base de datos
    public boolean grabar() {
        String cadenaSQL = "INSERT INTO impuesto (nombre, porcentaje, descripcion) VALUES ('" + nombre + "', '" + porcentaje + "', '" + descripcion + "')";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para modificar un impuesto existente
    public boolean modificar() {
        String cadenaSQL = "UPDATE impuesto SET nombre = '" + nombre + "', porcentaje = '" + porcentaje + "', descripcion = '" + descripcion + "' WHERE idImpuesto = '" + idImpuesto + "'";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para eliminar un impuesto
    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM impuesto WHERE idImpuesto = " + idImpuesto;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para obtener un ResultSet con una lista de impuestos, con filtro y orden
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
        String cadenaSQL = "SELECT idImpuesto, nombre, porcentaje, descripcion FROM impuesto" + filtro + orden;
        return ConectorBD.consultar(cadenaSQL);
    }

    // Método para obtener una lista de objetos Impuesto
    public static List<Impuesto> getListaEnObjetos(String filtro, String orden) {
        List<Impuesto> lista = new ArrayList<>();
        ResultSet datos = Impuesto.getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    Impuesto impuesto = new Impuesto();
                    impuesto.setIdImpuesto(datos.getString("idImpuesto"));
                    impuesto.setNombre(datos.getString("nombre"));
                    impuesto.setPorcentaje(datos.getString("porcentaje"));
                    impuesto.setDescripcion(datos.getString("descripcion"));
                    lista.add(impuesto);
                }
            } catch (SQLException ex) {
                Logger.getLogger(Impuesto.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }

    // Método para obtener una lista de opciones HTML de los impuestos
    public static String getListaEnOptions(String preseleccionado) {
        StringBuilder lista = new StringBuilder();
        List<Impuesto> datos = Impuesto.getListaEnObjetos(null, "nombre");
        for (Impuesto impuesto : datos) {
            String auxiliar = "";
            if (preseleccionado.equals(String.valueOf(impuesto.getIdImpuesto()))) {
                auxiliar = "selected";
            }
            lista.append("<option value='").append(impuesto.getIdImpuesto()).append("' ").append(auxiliar).append(">")
                    .append(impuesto.getNombre()).append(" (").append(impuesto.getPorcentaje()).append("%)</option>");
        }
        return lista.toString();
    }

    
    
    public static String getOpciones(String preseleccionado) {
    String lista = "";
    List<Impuesto> impuestos = Impuesto.getListaEnObjetos(null, "fecha_inventario DESC"); // Implementa este método para recuperar impuestos desde la base de datos
    for (Impuesto impuesto : impuestos) {
        String auxiliar = "";
        if (preseleccionado != null && preseleccionado.equals(impuesto.getNombre())) {
            auxiliar = "selected";
        }
        lista += "<option value='" + impuesto.getNombre() + "'" + auxiliar + ">" + impuesto.getNombre() + "</option>";
    }
    return lista;
}

    public static String getOpciones(List<Integer> impuestosSeleccionados) {
    StringBuilder opciones = new StringBuilder();
    List<Impuesto> listaImpuestos = Impuesto.getListaEnObjetos(null, null); // Obtén todos los impuestos

    for (Impuesto impuesto : listaImpuestos) {
        String checked = "";

        // Verifica si este impuesto está en la lista de preseleccionados
        if (impuestosSeleccionados != null && impuestosSeleccionados.contains(Integer.parseInt(impuesto.getIdImpuesto()))) {
            checked = "checked"; // Si está seleccionado, marca el checkbox
        }

        // Genera el checkbox
        opciones.append("<label><input type='checkbox' name='impuesto' value='")
                .append(impuesto.getIdImpuesto())
                .append("' ").append(checked).append("> ")
                .append(impuesto.getNombre())
                .append(" (")
                .append(impuesto.getPorcentaje())
                .append("%)</label><br>");
    }
    return opciones.toString();
}


    
    
    
    @Override
public String toString() {
        return nombre + " (" + porcentaje + "%)";
    }
}
