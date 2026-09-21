package com.myapp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/royaltaste"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC";

    private static final String USER = "root";

    private static final String PASSWORD = "Gowtham2002/28.S";

    static {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            System.out.println("MySQL Driver Loaded");

        } catch (ClassNotFoundException e) {

            System.out.println("MySQL Driver Not Found");

            e.printStackTrace();
        }
    }

    public static Connection getConnection() {

        Connection con = null;

        try {

            con = DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
            );

            System.out.println("Database Connected Successfully");

        } catch (SQLException e) {

            System.out.println("Database Connection Failed");

            e.printStackTrace();
        }

        return con;
    }
}