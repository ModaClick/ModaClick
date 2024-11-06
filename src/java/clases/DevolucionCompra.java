package clases;

import clasesGenericas.ConectorBD;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DevolucionCompra {
    private int id;
    private Date fecha;
    private Compra compra;

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

    public Compra getCompra() {
        return compra;
    }

    public void setCompra(Compra compra) {
        this.compra = compra;
    }

    // Método para insertar una nueva devolución
    public static boolean insertarDevolucion(DevolucionCompra devolucion) {
        boolean resultado = false;
        String insertSQL = "INSERT INTO DevolucionCompra (fecha, idCompraDetalle) VALUES ('" + devolucion.getFecha() + "', '" + devolucion.getCompra().getIdCompra() + "')";
        
        System.out.println("SQL de inserción de DevolucionCompra: " + insertSQL);

        // Ejecutamos la inserción usando el método de ConectorBD
        if (ConectorBD.ejecutarQuery(insertSQL)) {
            try {
                // Obtenemos el último ID insertado
                String lastIdSQL = "SELECT MAX(id) AS id FROM DevolucionCompra";
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

    public static DevolucionCompra getDevolucionPorId(int id) {
        DevolucionCompra devolucion = null;
        String query = "SELECT * FROM DevolucionCompra WHERE id = " + id;
        System.out.println("Consulta SQL para obtener devolución por ID: " + query);

        ResultSet rs = ConectorBD.consultar(query);
        try {
            if (rs.next()) {
                devolucion = new DevolucionCompra();
                devolucion.setId(rs.getInt("id"));
                devolucion.setFecha(rs.getDate("fecha"));
                
                // Cargar la compra asociada usando su ID
                Compra compra = new Compra(rs.getString("idCompraDetalle")); // Usamos idCompraDetalle aquí
                devolucion.setCompra(compra);
            }
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return devolucion;
    }

    // Obtener la lista de devoluciones con filtros
    public static List<DevolucionCompra> getDevolucionesCompra(String fechaInicio, String fechaFin, String numeroCompra, String proveedor) {
        List<DevolucionCompra> lista = new ArrayList<>();
        String query = "SELECT * FROM DevolucionCompra d "
                     + "JOIN Compra c ON d.idCompraDetalle = c.idCompra "
                     + "JOIN Persona p ON c.idProveedor = p.identificacion "
                     + "WHERE 1=1 ";
        
        // Aplicar filtros
        if (fechaInicio != null && !fechaInicio.isEmpty()) {
            query += "AND d.fecha >= '" + fechaInicio + "' ";
        }
        if (fechaFin != null && !fechaFin.isEmpty()) {
            query += "AND d.fecha <= '" + fechaFin + "' ";
        }
        if (numeroCompra != null && !numeroCompra.isEmpty()) {
            query += "AND c.idCompra = '" + numeroCompra + "' ";
        }
        if (proveedor != null && !proveedor.isEmpty()) {
            query += "AND p.nombre LIKE '%" + proveedor + "%' ";
        }

        System.out.println("Consulta SQL para obtener lista de devoluciones: " + query);
        ResultSet rs = ConectorBD.consultar(query);
        try {
            while (rs.next()) {
                DevolucionCompra devolucion = new DevolucionCompra();
                devolucion.setId(rs.getInt("id"));
                devolucion.setFecha(rs.getDate("fecha"));
                
                // Cargar la compra asociada usando su ID
                Compra compra = new Compra(rs.getString("idCompraDetalle"));
                devolucion.setCompra(compra);
                
                lista.add(devolucion);
            }
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

public static List<DevolucionCompra> getDevolucionesCompraPaginadas(String filtro, int start, int total) {
    List<DevolucionCompra> lista = new ArrayList<>();
    String query = "SELECT * FROM DevolucionCompra d "
                 + "JOIN Compra c ON d.idCompraDetalle = c.idCompra "
                 + "JOIN Persona p ON c.idProveedor = p.identificacion "
                 + "WHERE 1=1 " + filtro // Aplica los filtros recibidos
                 + " LIMIT " + start + ", " + total;

    System.out.println("Consulta SQL para obtener devoluciones paginadas: " + query);
    ResultSet rs = ConectorBD.consultar(query);
    try {
        while (rs.next()) {
            DevolucionCompra devolucion = new DevolucionCompra();
            devolucion.setId(rs.getInt("id"));
            devolucion.setFecha(rs.getDate("fecha"));

            // Cargar la compra asociada usando su ID
            Compra compra = new Compra(rs.getString("idCompraDetalle"));
            devolucion.setCompra(compra);

            lista.add(devolucion);
        }
        if (rs != null) rs.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return lista;
}


public static int getTotalDevoluciones(String filtro) {
    String query = "SELECT COUNT(*) AS total FROM DevolucionCompra d "
                 + "JOIN Compra c ON d.idCompraDetalle = c.idCompra "
                 + "JOIN Persona p ON c.idProveedor = p.identificacion "
                 + "WHERE 1=1 " + filtro; // Aplica los filtros recibidos

    System.out.println("Consulta SQL para obtener total de devoluciones: " + query);
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

    // Primero, eliminar los detalles asociados a la devolución
    String deleteDetallesSQL = "DELETE FROM DevolucionDetallesCompra WHERE idDevolucionCompra = " + idDevolucion;
    System.out.println("SQL para eliminar detalles de devolución: " + deleteDetallesSQL);
    boolean detallesEliminados = ConectorBD.ejecutarQuery(deleteDetallesSQL);

    // Si los detalles se eliminaron correctamente, proceder a eliminar la devolución principal
    if (detallesEliminados) {
        String deleteSQL = "DELETE FROM DevolucionCompra WHERE id = " + idDevolucion;
        System.out.println("SQL para eliminar devolución: " + deleteSQL);
        resultado = ConectorBD.ejecutarQuery(deleteSQL);
    } else {
        System.out.println("Error al eliminar los detalles de la devolución.");
    }

    return resultado;
}

public static List<DevolucionCompra> getListaEnObjetos() {
    List<DevolucionCompra> lista = new ArrayList<>();
    String query = "SELECT * FROM DevolucionCompra d "
                 + "JOIN Compra c ON d.idCompraDetalle = c.idCompra "
                 + "JOIN Persona p ON c.idProveedor = p.identificacion";

    System.out.println("Consulta SQL para obtener lista completa de devoluciones: " + query);
    ResultSet rs = ConectorBD.consultar(query);
    try {
        while (rs.next()) {
            DevolucionCompra devolucion = new DevolucionCompra();
            devolucion.setId(rs.getInt("id"));
            devolucion.setFecha(rs.getDate("fecha"));

            // Cargar la compra asociada usando su ID
            Compra compra = new Compra(rs.getString("idCompraDetalle"));
            devolucion.setCompra(compra);

            lista.add(devolucion);
        }
        if (rs != null) rs.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return lista;
}

}
