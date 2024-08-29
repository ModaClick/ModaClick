/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Persona {
    private String identificacion;
    private String nombre;
    private String telefono;
    private String genero;
    private String correoElectronico;
    private String tipo;

    public Persona() {
    }

    public Persona(String identificacion) {
        String cadenaSQL = "SELECT nombre, telefono, genero, correoElectronico, tipo FROM Persona WHERE identificacion = '" + identificacion + "'";
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);

        try {
            if (resultado.next()) {
                this.identificacion = identificacion;
                this.nombre = resultado.getString("nombre");
                this.telefono = resultado.getString("telefono");
                this.genero = resultado.getString("genero");
                this.correoElectronico = resultado.getString("correoElectronico");
                this.tipo = resultado.getString("tipo");
            }
        } catch (SQLException ex) {
            Logger.getLogger(Persona.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getIdentificacion() {
        return identificacion != null ? identificacion : "";
    }

    public void setIdentificacion(String identificacion) {
        this.identificacion = identificacion;
    }

    public String getNombre() {
        return nombre != null ? nombre : "";
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getTelefono() {
        return telefono != null ? telefono : "";
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getGenero() {
        return genero != null ? genero : "";
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }

    public String getCorreoElectronico() {
        return correoElectronico != null ? correoElectronico : "";
    }

    public void setCorreoElectronico(String correoElectronico) {
        this.correoElectronico = correoElectronico;
    }

    public String getTipo() {
        return tipo != null ? tipo : "";
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    @Override
    public String toString() {
        return identificacion != null ? identificacion + " - " + nombre : "";
    }

    public boolean grabar() {
        String cadenaSQL = "INSERT INTO Persona (identificacion, nombre, telefono, genero, correoElectronico, tipo) "
                         + "VALUES ('" + identificacion + "', '" + nombre + "', '" + telefono + "', '" 
                         + genero + "', '" + correoElectronico + "', '" + tipo + "')";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean modificar(String identificacionAnterior) {
        String cadenaSQL = "UPDATE Persona SET identificacion='" + identificacion + "', nombre='" + nombre 
                         + "', telefono='" + telefono + "', genero='" + genero 
                         + "', correoElectronico='" + correoElectronico + "', tipo='" + tipo 
                         + "' WHERE identificacion='" + identificacionAnterior + "'";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM Persona WHERE identificacion='" + identificacion + "'";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public static List<Persona> getListaEnObjetos(String filtro, String orden) {
        List<Persona> lista = new ArrayList<>();
        String cadenaSQL = "SELECT identificacion, nombre, telefono, genero, correoElectronico, tipo FROM Persona";
        if (filtro != null && !filtro.isEmpty()) {
            cadenaSQL += " WHERE " + filtro;
        }
        if (orden != null && !orden.isEmpty()) {
            cadenaSQL += " ORDER BY " + orden;
        }
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            while (resultado.next()) {
                Persona persona = new Persona();
                persona.setIdentificacion(resultado.getString("identificacion"));
                persona.setNombre(resultado.getString("nombre"));
                persona.setTelefono(resultado.getString("telefono"));
                persona.setGenero(resultado.getString("genero"));
                persona.setCorreoElectronico(resultado.getString("correoElectronico"));
                persona.setTipo(resultado.getString("tipo"));
                lista.add(persona);
            }
        } catch (SQLException ex) {
            Logger.getLogger(Persona.class.getName()).log(Level.SEVERE, null, ex);
        }
        return lista;
    }
}
