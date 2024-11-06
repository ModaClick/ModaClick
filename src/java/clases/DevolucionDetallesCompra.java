package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DevolucionDetallesCompra {
    private int id;
    private int idCompraDetalle;
    private int cantidad;
    private String estadoCompra;
    private String comentariosAdicionales;

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdCompraDetalle() {
        return idCompraDetalle;
    }

    public void setIdCompraDetalle(int idCompraDetalle) {
        this.idCompraDetalle = idCompraDetalle;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public String getEstadoCompra() {
        return estadoCompra;
    }

    public void setEstadoCompra(String estadoCompra) {
        this.estadoCompra = estadoCompra;
    }

    public String getComentariosAdicionales() {
        return comentariosAdicionales;
    }

    public void setComentariosAdicionales(String comentariosAdicionales) {
        this.comentariosAdicionales = comentariosAdicionales;
    }

    private static boolean existeCompraDetalle(int idCompraDetalle) {
    String query = "SELECT COUNT(*) AS total FROM CompraDetalle WHERE id = " + idCompraDetalle;
    ResultSet rs = ConectorBD.consultar(query);
    try {
        if (rs.next()) {
            return rs.getInt("total") > 0;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

// Método para insertar un detalle de devolución con validación
public static boolean insertarDetalleDevolucion(int idDevolucionCompra, DevolucionDetallesCompra detalle) {
    boolean resultado = false;
    
    // Verificar si el idCompraDetalle existe en la tabla CompraDetalle
    if (!existeCompraDetalle(detalle.getIdCompraDetalle())) {
        System.out.println("Error: el idCompraDetalle " + detalle.getIdCompraDetalle() + " no existe.");
        return false;
    }
    
    String insertSQL = "INSERT INTO DevolucionDetallesCompra (idDevolucionCompra, idCompraDetalle, cantidad, estadoCompra, comentariosAdicionales) "
            + "VALUES (" + idDevolucionCompra + ", " + detalle.getIdCompraDetalle() + ", "
            + detalle.getCantidad() + ", '" + detalle.getEstadoCompra() + "', '"
            + detalle.getComentariosAdicionales() + "')";

    // Ejecutar la inserción usando el método de ConectorBD
    resultado = ConectorBD.ejecutarQuery(insertSQL);
    if (!resultado) {
        System.out.println("Error al insertar el detalle de devolución.");
    }
    return resultado;
}


    // Método para obtener los detalles de una devolución
    public static List<DevolucionDetallesCompra> getDetallesPorDevolucion(int idDevolucion) {
        List<DevolucionDetallesCompra> lista = new ArrayList<>();
        String query = "SELECT * FROM DevolucionDetallesCompra WHERE idDevolucionCompra = " + idDevolucion;
        ResultSet rs = ConectorBD.consultar(query);
        try {
            while (rs.next()) {
                DevolucionDetallesCompra detalle = new DevolucionDetallesCompra();
                detalle.setId(rs.getInt("id"));
                detalle.setIdCompraDetalle(rs.getInt("idCompraDetalle"));
                detalle.setCantidad(rs.getInt("cantidad"));
                detalle.setEstadoCompra(rs.getString("estadoCompra"));
                detalle.setComentariosAdicionales(rs.getString("comentariosAdicionales"));
                lista.add(detalle);
            }
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }


    // Obtener el valor total de la devolución
    public int getValorTotal() {
        int valorTotal = 0;
        String query = "SELECT cantidad * costoUnitarioCompra AS total "
                     + "FROM CompraDetalle WHERE id = " + this.idCompraDetalle;
        ResultSet rs = ConectorBD.consultar(query);
        try {
            if (rs.next()) {
                valorTotal = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return valorTotal;
    }
    


    public static boolean eliminarDevolucion(int idDevolucion) {
        boolean resultado = false;
        String deleteSQL = "DELETE FROM DevolucionCompra WHERE id = " + idDevolucion;

        // Ejecutar la eliminación usando el método de ConectorBD
        resultado = ConectorBD.ejecutarQuery(deleteSQL);
        if (!resultado) {
            System.out.println("Error al eliminar la devolución con ID: " + idDevolucion);
        }
        return resultado;
    }
    
   
}
