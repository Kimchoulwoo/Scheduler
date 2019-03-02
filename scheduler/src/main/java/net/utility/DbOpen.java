package net.utility;

import java.io.Console;
import java.sql.Connection;
import java.sql.DriverManager;

import org.springframework.stereotype.Component;

@Component
public class DbOpen {
	public Connection getConnection() {
		String url = "jdbc:mysql://localhost:3306/calendar?serverTimezone=Asia/Seoul";
		String user = "root";
		String password = "rlacjfdn135";
		String driver = "org.gjt.mm.mysql.Driver";
		
		Connection con = null;
		try {
			Class.forName(driver);
			con=DriverManager.getConnection(url, user, password);
			
		}catch (Exception e) {
			System.out.println("DB Open fail");
		}
		
		return con;
		
	}
}
