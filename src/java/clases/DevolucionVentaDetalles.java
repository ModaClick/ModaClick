package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DevolucionVentaDetalles {
    private int id;
    private int idVentaDetalle;
    private int cantidad;
    private String estadoDevolucion;
    private String comentariosAdicionales;

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdVentaDetalle() {
        return idVentaDetalle;
    }

    public void setIdVentaDetalle(int idVentaDetalle) {
        this.idVentaDetalle = idVentaDetalle;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public String getEstadoDevolucion() {
        return estadoDevolucion;
    }

    public void setEstadoDevolucion(String estadoDevolucion) {
        this.estadoDevolucion = estadoDevolucion;
    }

    public String getComentariosAdicionales() {
        return comentariosAdicionales;
    }

    public void setComentariosAdicionales(String comentariosAdicionales) {
        this.comentariosAdicionales = comentariosAdicionales;
    }

    private static boolean existeVentaDetalle(int idVentaDetalle) {
        String query = "SELECT COUNT(*) AS total FROM VentaDetalle WHERE id = " + idVentaDetalle;
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
    public static boolean insertarDetalleDevolucion(int idDevolucionVenta, DevolucionVentaDetalles detalle) {
        boolean resultado = false;
        
        // Verificar si el idVentaDetalle existe en la tabla VentaDetalle
        if (!existeVentaDetalle(detalle.getIdVentaDetalle())) {
            System.out.println("Error: el idVentaDetalle " + detalle.getIdVentaDetalle() + " no existe.");
            return false;
        }
        
        String insertSQL = "INSERT INTO DevolucionVentaDetalles (idDevolucion, idVentaDetalle, cantidad, estadoDevolucion, comentariosAdicionales) "
                + "VALUES (" + idDevolucionVenta + ", " + detalle.getIdVentaDetalle() + ", "
                + detalle.getCantidad() + ", '" + detalle.getEstadoDevolucion() + "', '"
                + detalle.getComentariosAdicionales() + "')";
    
        // Ejecutar la inserción usando el método de ConectorBD
        resultado = ConectorBD.ejecutarQuery(insertSQL);
        if (!resultado) {
            System.out.println("Error al insertar el detalle de devolución.");
        }
        return resultado;
    }

    // Método para obtener los detalles de una devolución de venta
    public static List<DevolucionVentaDetalles> getDetallesPorDevolucion(int idDevolucion) {
        List<DevolucionVentaDetalles> lista = new ArrayList<>();
        String query = "SELECT * FROM DevolucionVentaDetalles WHERE idDevolucion = " + idDevolucion;
        ResultSet rs = ConectorBD.consultar(query);
        try {
            while (rs.next()) {
                DevolucionVentaDetalles detalle = new DevolucionVentaDetalles();
                detalle.setId(rs.getInt("id"));
                detalle.setIdVentaDetalle(rs.getInt("idVentaDetalle"));
                detalle.setCantidad(rs.getInt("cantidad"));
                detalle.setEstadoDevolucion(rs.getString("estadoDevolucion"));
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
        String query = "SELECT cantidad * valorUnitarioVenta AS total "
                     + "FROM VentaDetalle WHERE id = " + this.idVentaDetalle;
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
        String deleteSQL = "DELETE FROM DevolucionVenta WHERE id = " + idDevolucion;

        // Ejecutar la eliminación usando el método de ConectorBD
        resultado = ConectorBD.ejecutarQuery(deleteSQL);
        if (!resultado) {
            System.out.println("Error al eliminar la devolución con ID: " + idDevolucion);
        }
        return resultado;
    }
}
