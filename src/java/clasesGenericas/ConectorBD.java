package clasesGenericas;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConectorBD {

    private String servidor;
    private String puerto;
    private String usuario;
    private String clave;
    private String baseDatos;

    private static Connection conexion;

    public ConectorBD() {
        servidor = "localhost";
        puerto = "3306";
        usuario = "adso";
        clave = "utilizar";
        baseDatos = "modaclick";
    }

    // Método para obtener la conexión
    public static Connection getConexion() throws SQLException {
        if (conexion == null || conexion.isClosed()) {
            ConectorBD conector = new ConectorBD();
            conector.conectar();
        }
        return conexion;
    }
    
    

    public boolean conectar() {
        boolean conectado = false;
        try {
            if (conexion == null || conexion.isClosed()) {
                Class.forName("com.mysql.jdbc.Driver");
                System.out.println("Driver ok");
                String cadenaConexion = "jdbc:mysql://" + servidor + ":" + puerto + "/" + baseDatos + "?characterEncoding=utf8";
                conexion = DriverManager.getConnection(cadenaConexion, usuario, clave);
                System.out.println("Conectado a la BD.");
            }
            conectado = true;
        } catch (ClassNotFoundException ex) {
            System.out.println("Error en el controlador de la BD. " + ex.getMessage());
        } catch (SQLException ex) {
            System.out.println("Error al conectarse a la BD. " + ex.getMessage());
        }

        return conectado;
    }

    public void desconectar() {
        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
                System.out.println("Se ha desconectado de la BD.");
            }
        } catch (SQLException ex) {
            System.out.println("Error al desconectarse de la BD. " + ex.getMessage());
        }
    }

    public static ResultSet consultar(String cadenaSQL) {
        ResultSet resultado = null;
        try {
            Connection conexion = getConexion(); // Obtener la conexión
            PreparedStatement sentencia = conexion.prepareStatement(cadenaSQL, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = sentencia.executeQuery();
        } catch (SQLException ex) {
            System.out.println("Error en la cadena SQL " + cadenaSQL + ". " + ex.getMessage());
        }
        return resultado;
    }

    public static boolean ejecutarQuery(String cadenaSQL, Object... params) {
        boolean resultado = false;
        try {
            Connection conexion = getConexion(); // Obtener la conexión
            PreparedStatement sentencia = conexion.prepareStatement(cadenaSQL);
            for (int i = 0; i < params.length; i++) {
                sentencia.setObject(i + 1, params[i]); // Establece los parámetros
            }
            sentencia.execute();
            resultado = true;
        } catch (SQLException ex) {
            System.out.println("Error en la cadena SQL, " + cadenaSQL + " . " + ex.getMessage());
        }
        return resultado;
    }
    
    public ResultSet ejecutarConsultaConParametros(String cadenaSQL, Object... params) {
        ResultSet resultado = null;
        try {
            Connection conexion = getConexion(); // Obtener la conexión
            PreparedStatement sentencia = conexion.prepareStatement(cadenaSQL);
            for (int i = 0; i < params.length; i++) {
                sentencia.setObject(i + 1, params[i]); // Establece los parámetros
            }
            resultado = sentencia.executeQuery();
        } catch (SQLException ex) {
            System.out.println("Error en la cadena SQL " + cadenaSQL + ": " + ex.getMessage());
        }
        return resultado;
    }
}