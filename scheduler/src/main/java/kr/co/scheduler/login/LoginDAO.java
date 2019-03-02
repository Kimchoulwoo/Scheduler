package kr.co.scheduler.login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import net.utility.DbClose;
import net.utility.DbOpen;

@Component
public class LoginDAO {
	@Autowired
	DbOpen dbopen = null;
	
	@Autowired
	DbClose dbclose = null;
	
	public LoginDAO() {
		System.out.println("LoginDAO() 성공");
	}
	
	Connection con = null;
	PreparedStatement pstmt = null;
	StringBuffer sql = null;
	ResultSet rs = null;
	
	public String[] login(LoginDTO dto) {
		String login_arr[] = new String[3];
		try {
			con = dbopen.getConnection();
			sql = new StringBuffer();
			sql.append(" SELECT mem_id, mem_seq, mem_name FROM member ");
			sql.append(" WHERE mem_id=? AND mem_pw=? ");
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPassword());
			rs=pstmt.executeQuery();
			if(rs.next()) {
				login_arr[0]=rs.getString("mem_id");
				login_arr[1]=rs.getString("mem_seq");
				login_arr[2]=rs.getString("mem_name");
			}else {
				login_arr = null;
			}
			
		}catch (Exception e) {
			System.out.println("login fail"+e);
		}finally {
			dbclose.close(con, pstmt, rs);
		}
		
		return login_arr;
	}
	
	public int join(String id, String pw, String name) {
		int result = 0;
		
		try {
			con = dbopen.getConnection();
			sql = new StringBuffer();
			sql.append(" INSERT INTO member(mem_id, mem_pw, mem_name, mem_dep, mem_rank) ");
			sql.append(" VALUES(?,?,?,'개발부','사원') ");
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			pstmt.setString(3, name);
			result = pstmt.executeUpdate();
		}catch (Exception e) {
			System.out.println("join fail"+e);
		}finally {
			dbclose.close(con, pstmt);
		}
		return result;
	}
}
