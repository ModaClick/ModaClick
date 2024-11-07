package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ImpuestoInventario {
    private String id;
    private String idArticulo;
    private String idImpuesto;

    public ImpuestoInventario() {
        System.out.println("Inicializando objeto ImpuestoInventario vacío.");
    }

    public ImpuestoInventario(String id) {
        this.id = id;
        String cadenaSQL = "SELECT idArticulo, idImpuesto FROM ImpuestoInventario WHERE id='" + id + "'";
        System.out.println(cadenaSQL + " se imprimió");

        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.idArticulo = resultado.getString("idArticulo");
                this.idImpuesto = resultado.getString("idImpuesto");
                System.out.println("ImpuestoInventario cargado: idArticulo=" + idArticulo + ", idImpuesto=" + idImpuesto);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ImpuestoInventario.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdArticulo() {
        return idArticulo;
    }

    public void setIdArticulo(String idArticulo) {
        this.idArticulo = idArticulo;
    }

    public String getIdImpuesto() {
        return idImpuesto;
    }

    public void setIdImpuesto(String idImpuesto) {
        this.idImpuesto = idImpuesto;
    }

    public boolean grabar() {
        System.out.println("Insertando en ImpuestoInventario: idArticulo=" + idArticulo + ", idImpuesto=" + idImpuesto);
        String cadenaSQL = "INSERT INTO ImpuestoInventario (idArticulo, idImpuesto) VALUES ('" + idArticulo + "', '" + idImpuesto + "')";
        System.out.println("Consulta SQL: " + cadenaSQL);
        boolean resultado = ConectorBD.ejecutarQuery(cadenaSQL);
        System.out.println("Resultado de la inserción: " + resultado);
        return resultado;
    }

    public boolean modificar() {
        String cadenaSQL = "UPDATE ImpuestoInventario SET idArticulo=" + idArticulo + ", idImpuesto=" + idImpuesto + " WHERE id=" + id;
        System.out.println(cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM ImpuestoInventario WHERE id=" + idArticulo;
        System.out.println(cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
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

        String cadenaSQL = "SELECT i.idArticulo, i.nombreArticulo, i.descripcion, i.costoUnitCompra, i.valorUnitVenta, "
                + "i.stock, i.stockMinimo, i.stockMaximo, i.tipoTela, i.colorArticulo, i.talla, i.foto, i.idCategoria, "
                + "GROUP_CONCAT(imp.nombre, ' (', imp.porcentaje, '%)') AS impuestos "
                + "FROM inventario i "
                + "LEFT JOIN ImpuestoInventario ii ON i.idArticulo = ii.idArticulo "
                + "LEFT JOIN Impuesto imp ON ii.idImpuesto = imp.idImpuesto "
                + filtro
                + " GROUP BY i.idArticulo"
                + orden;

        System.out.println("Consulta ejecutada: " + cadenaSQL);
        return ConectorBD.consultar(cadenaSQL);
    }

    public static List<ImpuestoInventario> getListaEnObjetos(String filtro, String orden) {
        List<ImpuestoInventario> lista = new ArrayList<>();
        ResultSet datos = ImpuestoInventario.getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    ImpuestoInventario impuestoInventario = new ImpuestoInventario();
                    impuestoInventario.setId(datos.getString("id"));
                    impuestoInventario.setIdArticulo(datos.getString("idArticulo"));
                    impuestoInventario.setIdImpuesto(datos.getString("idImpuesto"));
                    lista.add(impuestoInventario);
                    System.out.println("Impuesto encontrado: " + impuestoInventario.getIdImpuesto());
                }
            } catch (SQLException ex) {
                Logger.getLogger(ImpuestoInventario.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }
    public static void eliminarPorArticulo(int idArticulo) {
    String cadenaSQL = "DELETE FROM ImpuestoInventario WHERE idArticulo = " + idArticulo;
    ConectorBD.ejecutarQuery(cadenaSQL);
}
  public boolean insertarImpuestoInventario(int idArticulo, int idImpuesto) {
    String procedimientoSQL = "CALL InsertarImpuestoInventario('" + idArticulo + "', '" + idImpuesto + "')";
    System.out.println(procedimientoSQL);  // Para depuración
    return ConectorBD.ejecutarQuery(procedimientoSQL);
}



    public static String getListaEnArregloJS() {
        String lista = "[";
        String sql = "SELECT idArticulo, i.idImpuesto, i.nombre, i.porcentaje "
                + "FROM ImpuestoInventario ii "
                + "INNER JOIN Impuesto i ON ii.idImpuesto = i.idImpuesto";
        ResultSet rs = ConectorBD.consultar(sql);
        int i = 0;
        try {
            while (rs.next()) {
                if (i > 0) lista += ", ";
                lista += "[";
                lista += "'" + rs.getString("idArticulo") + "', ";
                lista += "'" + rs.getString("idImpuesto") + "', ";
                lista += "'" + rs.getString("nombre") + "', ";
                lista += "'" + rs.getString("porcentaje") + "']";
                i++;
            }
            lista += "];";
        } catch (SQLException e) {
            System.err.println("Error al cargar los impuestos en arreglo JS: " + e.getMessage());
        }
        return lista;
    }
}
