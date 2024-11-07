package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Pedido {
    private String id;
    private String idCliente;
    private String nombreCliente;  // Nuevo campo para el nombre del cliente
    private String idVentaDetalle;
    private String fecha;
    private String idTipoEnvio;
    private String tipoEnvio;  // Nuevo campo para el nombre del tipo de envío
    private String estado;

    // Constructor vacío
    public Pedido() {
    }

    // Constructor para cargar un pedido específico por su ID
    public Pedido(String id) {
        // Consulta para obtener los detalles del pedido
        String cadenaSQL = "SELECT idCliente, idVentaDetalle, fecha, idTipoEnvio, estado FROM Pedido WHERE id = " + id;
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.id = id;
                idCliente = resultado.getString("idCliente");
                idVentaDetalle = resultado.getString("idVentaDetalle");
                fecha = resultado.getString("fecha");
                idTipoEnvio = resultado.getString("idTipoEnvio");
                estado = resultado.getString("estado");

                // Obtener el nombre del cliente a partir de su id
                String cadenaSQLCliente = "SELECT nombre FROM Persona WHERE identificacion = '" + idCliente + "'";
                ResultSet resultadoCliente = ConectorBD.consultar(cadenaSQLCliente);
                if (resultadoCliente.next()) {
                    nombreCliente = resultadoCliente.getString("nombre");
                }

                // Obtener el nombre del tipo de envío a partir de su id
                String cadenaSQLTipoEnvio = "SELECT nombre FROM TipoEnvio WHERE id = " + idTipoEnvio;
                ResultSet resultadoTipoEnvio = ConectorBD.consultar(cadenaSQLTipoEnvio);
                if (resultadoTipoEnvio.next()) {
                    tipoEnvio = resultadoTipoEnvio.getString("nombre");
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(Pedido.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Getters y Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(String idCliente) {
        this.idCliente = idCliente;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public String getIdVentaDetalle() {
        return idVentaDetalle;
    }

    public void setIdVentaDetalle(String idVentaDetalle) {
        this.idVentaDetalle = idVentaDetalle;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getIdTipoEnvio() {
        return idTipoEnvio;
    }

    public void setIdTipoEnvio(String idTipoEnvio) {
        this.idTipoEnvio = idTipoEnvio;
    }

    public String getTipoEnvio() {
        return tipoEnvio;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    // Método para asignar el color basado en el estado del pedido
    public String getColorEstado() {
        if ("E".equalsIgnoreCase(estado)) { // Entregado
            return "green";
        } else if ("P".equalsIgnoreCase(estado)) { // Por entregar
            return "red";
        }
        return ""; // Otro valor
    }
    
    public String calcularValorTotal() {
    String total = "0";
    String cadenaSQL = "SELECT SUM(cantidad * valorUnitVenta) AS totalPedido " +
                       "FROM PedidoDetalle WHERE idPedido = " + this.id;
    ResultSet resultado = ConectorBD.consultar(cadenaSQL);
    try {
        if (resultado.next()) {
            total = resultado.getString("totalPedido");
        }
    } catch (SQLException ex) {
        Logger.getLogger(Pedido.class.getName()).log(Level.SEVERE, null, ex);
    }
    return total != null ? total : "0";
}


    // Método para grabar un pedido
    public boolean grabar() {
        String cadenaSQL = "INSERT INTO Pedido (idCliente, idVentaDetalle, fecha, idTipoEnvio, estado) VALUES ('" +
                idCliente + "', '" + idVentaDetalle + "', '" + fecha + "', '" + idTipoEnvio + "', '" + estado + "')";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }
    
    // Método para modificar un pedido existente
    public boolean modificar() {
        String cadenaSQL = "UPDATE Pedido SET idCliente = '" + idCliente + "', idVentaDetalle = '" + idVentaDetalle
                + "', fecha = '" + fecha + "', idTipoEnvio = '" + idTipoEnvio + "', estado = '" + estado + "' WHERE id = " + id;
        System.out.println("Modificando pedido: " + cadenaSQL); // Verifica la consulta completa aquí
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }


    public boolean eliminar() {
        boolean eliminado = false;
            try {
        // Paso 1: Eliminar primero los detalles del pedido relacionados
            String cadenaSQLDetalle = "DELETE FROM PedidoDetalle WHERE idPedido = " + this.id;
            eliminado = ConectorBD.ejecutarQuery(cadenaSQLDetalle);

        // Paso 2: Luego, eliminar el pedido si los detalles fueron eliminados con éxito
        if (eliminado) {
            String cadenaSQL = "DELETE FROM Pedido WHERE id = " + this.id;
            eliminado = ConectorBD.ejecutarQuery(cadenaSQL);
        }
    } catch (Exception e) {
        System.out.println("Error al eliminar el pedido: " + e.getMessage());
    }
        return eliminado;
    }

    // Método para obtener una lista de pedidos en formato ResultSet
    public static ResultSet getLista(String filtro, String orden) {
        if (filtro != null && !filtro.isEmpty()) filtro = " WHERE " + filtro;
        else filtro = "";
        if (orden != null && !orden.isEmpty()) orden = " ORDER BY " + orden;
        else orden = "";
        String cadenaSQL = "SELECT id, idCliente, idVentaDetalle, fecha, idTipoEnvio, estado FROM Pedido" + filtro + orden;
        return ConectorBD.consultar(cadenaSQL);
    }
    
    public static List<String> getListaNombresClientes() {
        List<String> listaNombres = new ArrayList<>();
        String cadenaSQL = "SELECT DISTINCT nombre FROM Persona";
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            while (resultado.next()) {
                listaNombres.add(resultado.getString("nombre"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(Pedido.class.getName()).log(Level.SEVERE, null, ex);
        }
        return listaNombres;
    }

    // Método para obtener una lista de pedidos en objetos
    public static List<Pedido> getListaEnObjetos(String filtro, String orden) {
        List<Pedido> lista = new ArrayList<>();
        ResultSet datos = Pedido.getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    Pedido pedido = new Pedido();
                    pedido.setId(datos.getString("id"));
                    pedido.setIdCliente(datos.getString("idCliente"));
                    pedido.setIdVentaDetalle(datos.getString("idVentaDetalle"));
                    pedido.setFecha(datos.getString("fecha"));
                    pedido.setIdTipoEnvio(datos.getString("idTipoEnvio"));
                    pedido.setEstado(datos.getString("estado"));

                    String cadenaSQLCliente = "SELECT nombre FROM Persona WHERE identificacion = '" + pedido.getIdCliente() + "'";
                    ResultSet resultadoCliente = ConectorBD.consultar(cadenaSQLCliente);
                    if (resultadoCliente.next()) {
                        pedido.nombreCliente = resultadoCliente.getString("nombre");
                    }

                    String cadenaSQLTipoEnvio = "SELECT nombre FROM TipoEnvio WHERE id = " + pedido.getIdTipoEnvio();
                    ResultSet resultadoTipoEnvio = ConectorBD.consultar(cadenaSQLTipoEnvio);
                    if (resultadoTipoEnvio.next()) {
                        pedido.tipoEnvio = resultadoTipoEnvio.getString("nombre");
                    }

                    lista.add(pedido);
                }
            } catch (SQLException ex) {
                Logger.getLogger(Pedido.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }
    
    
    public boolean grabarConProcedimiento(String cadenaArticulos) {
        boolean resultado = true; // Cambiará a false si alguna inserción falla
        ConectorBD conector = new ConectorBD();

        // Conectar a la base de datos
        if (!conector.conectar()) {
            System.out.println("Error al conectarse a la base de datos.");
            return false;
        }

        // Dividir la cadena de artículos por '||' para procesar cada artículo individualmente
        String[] articulos = cadenaArticulos.split("\\|\\|");

        // Verificar si hay artículos antes de continuar
        if (articulos.length == 0 || cadenaArticulos.isEmpty()) {
            System.out.println("No hay artículos para procesar.");
            return false;
        }

        // Construir la cadena SQL para invocar el procedimiento con los artículos
        StringBuilder cadenaSQL = new StringBuilder();
        cadenaSQL.append("CALL RegistrarPedidoConDetalles('")
                .append(this.idCliente).append("', '")
                .append(this.fecha).append("', ")
                .append(this.idTipoEnvio).append(", '")
                .append(this.estado).append("', '");

        // Concatenar todos los artículos en el formato adecuado 'idArticulo|cantidad||'
        for (String articulo : articulos) {
            // Verificar el formato del artículo 'idArticulo|cantidad'
            String[] datosArticulo = articulo.split("\\|");
            if (datosArticulo.length == 2) {
                int idArticulo = Integer.parseInt(datosArticulo[0]);
                int cantidad = Integer.parseInt(datosArticulo[1]);

                // Agregar el artículo en el formato adecuado (idArticulo|cantidad||)
                cadenaSQL.append(idArticulo).append("|").append(cantidad).append("||");
            } else {
                System.out.println("Formato incorrecto para el artículo: " + articulo);
                resultado = false;
                break; // Detener el proceso si hay un error en el formato de un artículo
            }
        }

        // Remover el último '||' de la cadena
        cadenaSQL.setLength(cadenaSQL.length() - 2);
        cadenaSQL.append("')");

        // Ejecutar la consulta utilizando el método ejecutarQuery
        System.out.println("Ejecutando SQL: " + cadenaSQL.toString()); // Para depuración
        boolean ejecucionExitosa = conector.ejecutarQuery(cadenaSQL.toString());

        if (!ejecucionExitosa) {
            resultado = false;
            System.out.println("Error al ejecutar la consulta: " + cadenaSQL.toString());
        }

        // Desconectar después de realizar las operaciones
        conector.desconectar();

        return resultado;
    }

    public boolean modificarConProcedimiento(String cadenaArticulos) {
        boolean resultado = true; // Cambiará a false si alguna inserción falla
        ConectorBD conector = new ConectorBD();

        // Conectar a la base de datos
        if (!conector.conectar()) {
            System.out.println("Error al conectarse a la base de datos.");
            return false;
        }

        // Dividir la cadena de artículos por '||' para procesar cada artículo individualmente
        String[] articulos = cadenaArticulos.split("\\|\\|");

        // Verificar si hay artículos antes de continuar
        if (articulos.length == 0 || cadenaArticulos.isEmpty()) {
            System.out.println("No hay artículos para procesar.");
            return false;
        }

        // Construir la cadena SQL para invocar el procedimiento una vez con todos los artículos
        StringBuilder cadenaSQL = new StringBuilder();
        cadenaSQL.append("CALL ModificarPedidoConDetalles(")
                .append(this.id).append(", '") // idPedido
                .append(this.idCliente).append("', '")
                .append(this.fecha).append("', ")
                .append(this.idTipoEnvio).append(", '")
                .append(this.estado).append("', '");

        // Concatenar todos los artículos en el formato adecuado 'idArticulo|cantidad||'
        for (String articulo : articulos) {
            // Verificar el formato del artículo 'idArticulo|cantidad'
            String[] datosArticulo = articulo.split("\\|");
            if (datosArticulo.length == 2) {
                int idArticulo = Integer.parseInt(datosArticulo[0]);
                int cantidad = Integer.parseInt(datosArticulo[1]);

                // Agregar el artículo en el formato adecuado (idArticulo|cantidad||)
                cadenaSQL.append(idArticulo).append("|").append(cantidad).append("||");
            } else {
                System.out.println("Formato incorrecto para el artículo: " + articulo);
                resultado = false;
                break; // Detener el proceso si hay un error en el formato de un artículo
            }
        }

        // Remover el último '||' de la cadena
        cadenaSQL.setLength(cadenaSQL.length() - 2);
        cadenaSQL.append("')");

        // Ejecutar la consulta utilizando el método ejecutarQuery
        System.out.println("Ejecutando SQL: " + cadenaSQL.toString()); // Para depuración
        boolean ejecucionExitosa = conector.ejecutarQuery(cadenaSQL.toString());

        if (!ejecucionExitosa) {
            resultado = false;
            System.out.println("Error al ejecutar la consulta: " + cadenaSQL.toString());
        }

        // Desconectar después de realizar las operaciones
        conector.desconectar();

        return resultado;
    }
    
    
    public double obtenerTotalAbonado() {
        double totalAbonado = 0;
        
        // Consulta SQL para obtener la suma de los valores abonados para el idVentaDetalle asociado al pedido
        String cadenaSQL = "SELECT SUM(valor) AS totalAbonado FROM MedioPagoPorVenta WHERE idVentaDetalle = " + this.idVentaDetalle;
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);

        try {
            if (resultado != null && resultado.next()) {
                totalAbonado = resultado.getDouble("totalAbonado");
            }
        } catch (SQLException ex) {
            Logger.getLogger(Pedido.class.getName()).log(Level.SEVERE, null, ex);
        }

        return totalAbonado;
    }



}
