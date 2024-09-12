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

/**
 *
 * @author SENA
 */
public class Categoria {
    private String idCategoria;
    private String nombre;
    private String descripcion;

    public Categoria() {
    }

    public Categoria(String idCategoria) {
        String cadenaSQL = "select nombre, descripcion from categoria where idCategoria=" + idCategoria;
        System.out.println(cadenaSQL);
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.idCategoria = idCategoria;
                nombre = resultado.getString("nombre");
                descripcion = resultado.getString("descripcion");
            }
        } catch (SQLException ex) {
            Logger.getLogger(Categoria.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(String idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    @Override
    public String toString() {
        return nombre;
    }

    public boolean grabar() {
        String cadenaSQL = "insert into categoria (nombre, descripcion) values ('" + nombre + "','" + descripcion + "')";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean modificar() {
        String cadenaSQL = "update categoria set nombre='" + nombre + "', descripcion='" + descripcion + "' where idCategoria=" + idCategoria;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean eliminar() {
        String cadenaSQL = "delete from categoria where id=" + idCategoria;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public static ResultSet getlista(String filtro, String orden) {
        if (filtro != null && !filtro.isEmpty()) filtro = " where " + filtro;
        else filtro = "";
        if (orden != null && !orden.isEmpty()) orden = " order by " + orden;
        else orden = "";
        String cadenaSQL = "select idCategoria, nombre, descripcion from categoria " + filtro + orden;
        return ConectorBD.consultar(cadenaSQL);
    }

    public static List<Categoria> getListaEnObjetos(String filtro, String orden) {
        List<Categoria> lista = new ArrayList<>();
        ResultSet datos = Categoria.getlista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    Categoria categoria = new Categoria();
                    categoria.setIdCategoria(datos.getString("idCategoria"));
                    categoria.setNombre(datos.getString("nombre"));
                    categoria.setDescripcion(datos.getString("descripcion"));
                    lista.add(categoria);
                }
            } catch (SQLException ex) {
                Logger.getLogger(Categoria.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }

    public static String getListaEnOptions(String preseleccionado) {
        String lista = "";

        List<Categoria> datos = Categoria.getListaEnObjetos(null, "nombre");
        for (Categoria categoria : datos) {
            String auxiliar = "";
            if (preseleccionado.equals(categoria.getIdCategoria())) auxiliar = "selected";
            lista += "<option value='" + categoria.getIdCategoria() + "'" + auxiliar + ">" + categoria.getNombre() + "</option>";
        }

        return lista;
    }
}
