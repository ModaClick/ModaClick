/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clasesGenericas;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author user
 */
public class ConectorBD {

    private String servidor;
    private String puerto;
    private String usuario;
    private String clave;
    private String baseDatos;
    private Connection conexion; //esto lleva la conexion de la bd

    public ConectorBD() {
        servidor = "localhost";
        puerto = "3306";
        usuario = "adso";
        clave = "utilizar";
        baseDatos = "modaclick";
    }

    public boolean conectar() {
        boolean conectado = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            System.out.println("Driver ok");
            String cadenaConexion = "jdbc:mysql://" + servidor + ":" + puerto + "/" + baseDatos + "?characterEncoding=utf8";
            /*Aqui agregue dos puntos de // entendiendose
            como la sintaxis de la url del servidor sintaxis es= 
            jdbc:mysql, psql cuando es postgres://[servidor]:[puerto]/[baseDatos],characterEncoding=utf8 para 
            que maneje caracteres especiales, cuando interactuamos con la base de datos
            los caracteres especiales ñ o tildes daña, entonces para eso sirve characterEncondig=utf8*/
            conexion = (Connection) DriverManager.getConnection(cadenaConexion, usuario, clave);
            System.out.println("Conectado a la base de datos");
            conectado = true; // antes esta linea No estaba, se trataba de encontrar el error. 
        } catch (ClassNotFoundException ex) {
            // Logger.getLogger(ConectorBD.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Error en el controlador de la base de datos. " + ex.getMessage());
        } catch (SQLException ex) {
            //Logger.getLogger(ConectorBD.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Error al conectarse a la base de datos. " + ex.getMessage());
        }
        return conectado;
    }

    public void desconectar() {
        try {
            conexion.close();
            System.out.println("Se ha desconectado de la base de datos");
        } catch (SQLException ex) {
            // Logger.getLogger(ConectorBD.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Error al desconectarse de la base de datos " + ex.getMessage());
        }
    }

    public static ResultSet consultar(String cadenaSQL) {
        /*
        CadenaSQL se refiere al select, la orden que espera. 
         */
        ResultSet resultado = null;
        ConectorBD conector = new ConectorBD();
        if (!conector.conectar()) {
            System.out.println("Error al conectarse a la base de datos. ");
        }
        try {
            PreparedStatement sentencia = conector.conexion.prepareStatement(cadenaSQL, ResultSet.TYPE_SCROLL_SENSITIVE, 0);
            resultado = sentencia.executeQuery();
        } catch (SQLException ex) {
            //Logger.getLogger(ConectorBD.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Error en la cadena SQL. " + cadenaSQL + ". " + ex.getMessage());
        }
        //  conector.desconectar();
        return resultado;
    }

    public static boolean ejecutarQuery(String cadenaSQL) {
        boolean resultado = false;
        ConectorBD conector = new ConectorBD();
        if (!conector.conectar()) {
            System.out.println("Error al conectarse a la base de datos ");
        }

        try {
            PreparedStatement sentencia = conector.conexion.prepareStatement(cadenaSQL); // aqui no se pone mas
            //parametros resultset porque no necesita arrojar resultados
            resultado = sentencia.execute();
            resultado=true;
        } catch (SQLException ex) {
            //Logger.getLogger(ConectorBD.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Error en la cadena SQL. " + cadenaSQL + ". " + ex.getMessage());
        }
        conector.desconectar();
        return resultado;
    }
}
