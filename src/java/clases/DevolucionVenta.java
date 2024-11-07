package clases;

import clasesGenericas.ConectorBD;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DevolucionVenta {
    private int id;
    private Date fecha;
    private Venta venta;

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }    

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha != null ? fecha : Date.valueOf(LocalDate.now());
    }

    public Venta getVenta() {
        return venta;
    }

    public void setVenta(Venta venta) {
        this.venta = venta;
    }

    // Método para insertar una nueva devolución
    public static boolean insertarDevolucion(DevolucionVenta devolucion) {
        boolean resultado = false;
        String insertSQL = "INSERT INTO DevolucionVenta (fecha, idVentaDetalle) VALUES ('" + devolucion.getFecha() + "', '" + devolucion.getVenta().getIdVenta() + "')";
        
        System.out.println("SQL de inserción de DevolucionVenta: " + insertSQL);

        if (ConectorBD.ejecutarQuery(insertSQL)) {
            try {
                String lastIdSQL = "SELECT MAX(id) AS id FROM DevolucionVenta";
                ResultSet rs = ConectorBD.consultar(lastIdSQL);
                if (rs.next()) {
                    int lastId = rs.getInt("id");
                    devolucion.setId(lastId);
                    resultado = true;
                }
                if (rs != null) rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Error al insertar la devolución.");
        }
        return resultado;
    }

    public static DevolucionVenta getDevolucionPorId(int id) {
        DevolucionVenta devolucion = null;
        String query = "SELECT * FROM DevolucionVenta WHERE id = " + id;
        System.out.println("Consulta SQL para obtener devolución por ID: " + query);

        ResultSet rs = ConectorBD.consultar(query);
        try {
            if (rs.next()) {
                devolucion = new DevolucionVenta();
                devolucion.setId(rs.getInt("id"));
                devolucion.setFecha(rs.getDate("fecha"));
                
                // Cargar la venta asociada usando su ID
                Venta venta = new Venta(rs.getString("idVentaDetalle"));
                devolucion.setVenta(venta);
            }
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return devolucion;
    }

    public static List<DevolucionVenta> getDevolucionesVenta(String fechaInicio, String fechaFin, String numeroVenta, String cliente) {
        List<DevolucionVenta> lista = new ArrayList<>();
        String query = "SELECT * FROM DevolucionVenta d "
                     + "JOIN Venta v ON d.idVentaDetalle = v.idVenta "
                     + "JOIN Persona p ON v.idCliente = p.identificacion "
                     + "WHERE 1=1 ";
        
        if (fechaInicio != null && !fechaInicio.isEmpty()) {
            query += "AND d.fecha >= '" + fechaInicio + "' ";
        }
        if (fechaFin != null && !fechaFin.isEmpty()) {
            query += "AND d.fecha <= '" + fechaFin + "' ";
        }
        if (numeroVenta != null && !numeroVenta.isEmpty()) {
            query += "AND v.idVenta = '" + numeroVenta + "' ";
        }
        if (cliente != null && !cliente.isEmpty()) {
            query += "AND p.nombre LIKE '%" + cliente + "%' ";
        }

        System.out.println("Consulta SQL para obtener lista de devoluciones de venta: " + query);
        ResultSet rs = ConectorBD.consultar(query);
        try {
            while (rs.next()) {
                DevolucionVenta devolucion = new DevolucionVenta();
                devolucion.setId(rs.getInt("id"));
                devolucion.setFecha(rs.getDate("fecha"));
                
                // Cargar la venta asociada usando su ID
                Venta venta = new Venta(rs.getString("idVentaDetalle"));
                devolucion.setVenta(venta);
                
                lista.add(devolucion);
            }
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public static List<DevolucionVenta> getDevolucionesVentaPaginadas(String filtro, int start, int total) {
        List<DevolucionVenta> lista = new ArrayList<>();
        String query = "SELECT * FROM DevolucionVenta d "
                     + "JOIN Venta v ON d.idVentaDetalle = v.idVenta "
                     + "JOIN Persona p ON v.idCliente = p.identificacion "
                     + "WHERE 1=1 " + filtro
                     + " LIMIT " + start + ", " + total;

        System.out.println("Consulta SQL para obtener devoluciones de venta paginadas: " + query);
        ResultSet rs = ConectorBD.consultar(query);
        try {
            while (rs.next()) {
                DevolucionVenta devolucion = new DevolucionVenta();
                devolucion.setId(rs.getInt("id"));
                devolucion.setFecha(rs.getDate("fecha"));

                // Cargar la venta asociada usando su ID
                Venta venta = new Venta(rs.getString("idVentaDetalle"));
                devolucion.setVenta(venta);

                lista.add(devolucion);
            }
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public static int getTotalDevoluciones(String filtro) {
        String query = "SELECT COUNT(*) AS total FROM DevolucionVenta d "
                     + "JOIN Venta v ON d.idVentaDetalle = v.idVenta "
                     + "JOIN Persona p ON v.idCliente = p.identificacion "
                     + "WHERE 1=1 " + filtro;

        System.out.println("Consulta SQL para obtener total de devoluciones de venta: " + query);
        ResultSet rs = ConectorBD.consultar(query);
        int total = 0;
        try {
            if (rs.next()) {
                total = rs.getInt("total");
            }
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public static boolean eliminarDevolucion(int idDevolucion) {
        boolean resultado = false;

        String deleteDetallesSQL = "DELETE FROM DevolucionDetallesVenta WHERE idDevolucionVenta = " + idDevolucion;
        System.out.println("SQL para eliminar detalles de devolución de venta: " + deleteDetallesSQL);
        boolean detallesEliminados = ConectorBD.ejecutarQuery(deleteDetallesSQL);

        if (detallesEliminados) {
            String deleteSQL = "DELETE FROM DevolucionVenta WHERE id = " + idDevolucion;
            System.out.println("SQL para eliminar devolución de venta: " + deleteSQL);
            resultado = ConectorBD.ejecutarQuery(deleteSQL);
        } else {
            System.out.println("Error al eliminar los detalles de la devolución de venta.");
        }

        return resultado;
    }

    public static List<DevolucionVenta> getListaEnObjetos() {
        List<DevolucionVenta> lista = new ArrayList<>();
        String query = "SELECT * FROM DevolucionVenta d "
                     + "JOIN Venta v ON d.idVentaDetalle = v.idVenta "
                     + "JOIN Persona p ON v.idCliente = p.identificacion";

        System.out.println("Consulta SQL para obtener lista completa de devoluciones de venta: " + query);
        ResultSet rs = ConectorBD.consultar(query);
        try {
            while (rs.next()) {
                DevolucionVenta devolucion = new DevolucionVenta();
                devolucion.setId(rs.getInt("id"));
                devolucion.setFecha(rs.getDate("fecha"));

                // Cargar la venta asociada usando su ID
                Venta venta = new Venta(rs.getString("idVentaDetalle"));
                devolucion.setVenta(venta);

                lista.add(devolucion);
            }
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
