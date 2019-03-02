package kr.co.scheduler.main;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import net.utility.DbClose;
import net.utility.DbOpen;

@Component
public class SchedulerDAO {

	@Autowired
	DbOpen dbopen = null;
	
	@Autowired
	DbClose dbclose = null;
	
	
	public SchedulerDAO() {
		System.out.println("SchedulerDAO success");
	}
	
	
	
	public int submit(SchedulerDTO dto) {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbopen.getConnection();
			StringBuffer sql= new StringBuffer();
			sql.append(" INSERT INTO schedule(sch_title, sch_content, sch_writer, sch_start, sch_end, sch_mem_seq) ");
			sql.append(" value(?,?,?,?,?,?) ");
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, dto.getSch_title());
			pstmt.setString(2, dto.getSch_content());
			pstmt.setString(3, dto.getSch_writer());
			pstmt.setString(4, dto.getSch_start());
			pstmt.setString(5, dto.getSch_end());
			pstmt.setString(6, dto.getSch_mem_seq());
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("submit fail : "+e);
		}finally {
			dbclose.close(con, pstmt);
		}
		return result;
	}
	
	public ArrayList list(String uid, String start, String end){
		ArrayList list = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbopen.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append(" SELECT ");
			sql.append(" 	   sch_title, ");
			sql.append(" 	   sch_start, ");
			sql.append(" 	   sch_end, ");
			sql.append("	   sch_seq ");
			sql.append(" FROM ");
			sql.append(" 	   schedule ");
			sql.append(" WHERE ");
			sql.append(" 	   sch_writer = ? ");
			sql.append(" AND sch_start > ? AND sch_start < ?; ");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, uid);
			pstmt.setString(2, start);
			pstmt.setString(3, end);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				list = new ArrayList<>();
				do {
					Map<String, String> map = new HashMap<String, String>();
					map.put("title", rs.getString("sch_title").toString());
					map.put("start", rs.getString("sch_start").toString());
					map.put("end", rs.getString("sch_end").toString());
					map.put("seq", rs.getString("sch_seq").toString());
					list.add(map);
				}while(rs.next());
			}
		} catch (Exception e) {
			System.out.println("list fail : "+e);
		}finally {
			dbclose.close(con, pstmt, rs);
		}
		return list;
	}
	
	public ArrayList shareList(String seq, String uid, String start, String end){
		ArrayList list = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbopen.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append(" SELECT ");
			sql.append(" 	   sch_title, ");
			sql.append(" 	   sch_start, ");
			sql.append(" 	   sch_end, ");
			sql.append("	   sch_seq ");
			sql.append(" FROM ");
			sql.append(" 	   schedule ");
			sql.append(" WHERE ");
			sql.append(" 	   FIND_IN_SET(?,sch_mem_seq) AND sch_writer != ? ");
			sql.append(" AND sch_start>? AND sch_start<? ");

			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, seq);
			pstmt.setString(2, uid);
			pstmt.setString(3, start);
			pstmt.setString(4, end);
			
			rs = pstmt.executeQuery();

			if(rs.next()) {
				list = new ArrayList<>();
				do {
					Map<String, String> map = new HashMap<String, String>();
					map.put("title", rs.getString("sch_title").toString());
					map.put("start", rs.getString("sch_start").toString());
					map.put("end", rs.getString("sch_end").toString());
					map.put("seq", rs.getString("sch_seq").toString());
					list.add(map);
				}while(rs.next());
			}
		} catch (Exception e) {
			System.out.println("sharelist fail : "+e);
		}finally {
			dbclose.close(con, pstmt, rs);
		}
		
		return list;
	}
	
	public Map<String, String> read(String seq){
		Map<String, String> map = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		StringBuffer sql = null;
		ResultSet rs = null;
		
		try {
			con = dbopen.getConnection();
			sql = new StringBuffer();
			sql.append(" SELECT sch_seq, sch_title, sch_content, sch_start, sch_end, sch_mem_seq, mem_name, sch_writer ");
			sql.append(" FROM schedule ");
			sql.append(" JOIN member ");
			sql.append(" ON mem_id=sch_writer ");
			sql.append(" WHERE sch_seq = ?  ");
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, seq);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				map = new HashMap<>();
				map.put("seq", rs.getString("sch_seq"));
				map.put("title", rs.getString("sch_title"));
				map.put("content", rs.getString("sch_content"));
				map.put("writer", rs.getString("mem_name"));
				map.put("start", rs.getString("sch_start"));
				map.put("end", rs.getString("sch_end"));
				map.put("mem_seq", rs.getString("sch_mem_seq"));
				map.put("writer_id", rs.getString("sch_writer"));
			}
			
		}catch (Exception e) {
			System.out.println("read fail : "+e);
		}finally {
			dbclose.close(con, pstmt, rs);
		}
		return map;
	}
	
	public Map<String, String> read_mem(String mem_seq){
		Map<String, String> map = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		StringBuffer sql = null;
		ResultSet rs = null;
		
		try {
			con = dbopen.getConnection();
			sql = new StringBuffer();
			sql.append(" SELECT mem_dep, mem_rank, mem_name, mem_seq ");
			sql.append(" FROM member ");
			sql.append(" WHERE mem_seq = ? ");
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, mem_seq);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				map = new HashMap<>();
				map.put("mem_dep", rs.getString("mem_dep"));
				map.put("mem_rank", rs.getString("mem_rank"));
				map.put("mem_name", rs.getString("mem_name"));
				map.put("mem_seq", rs.getString("mem_seq"));
			}
			
		}catch (Exception e) {
			System.out.println("read fail : "+e);
		}finally {
			dbclose.close(con, pstmt, rs);
		}
		return map;
	}
	
	public int modify(SchedulerDTO dto) {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		StringBuffer sql = null;
		ResultSet rs = null;
		
		try {
			con = dbopen.getConnection();
			sql = new StringBuffer();
			sql.append(" UPDATE schedule SET sch_title=?, sch_content=?, sch_writer=?, sch_start=?, sch_end=?, sch_mem_seq=? ");
			sql.append(" WHERE sch_seq=? ");
			pstmt = con.prepareStatement(sql.toString());
			
			pstmt.setString(1, dto.getSch_title());
			pstmt.setString(2, dto.getSch_content());
			pstmt.setString(3, dto.getSch_writer());
			pstmt.setString(4, dto.getSch_start());
			pstmt.setString(5, dto.getSch_end());
			pstmt.setString(6, dto.getSch_mem_seq());
			pstmt.setInt(7, dto.getSch_seq());
			result = pstmt.executeUpdate();
			
		}catch (Exception e) {
			System.out.println("modify fail : "+e);
		}finally {
			dbclose.close(con, pstmt);
		}
		
		return result;
	}
	
	public int delete(int seq) {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		StringBuffer sql = null;
		ResultSet rs = null;
		
		try {
			con = dbopen.getConnection();
			sql = new StringBuffer();
			sql.append(" DELETE FROM schedule WHERE sch_seq=? ");
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setInt(1, seq);
			result = pstmt.executeUpdate();			
		}catch (Exception e) {
			System.out.println("delete fail : "+e);
		}finally {
			dbclose.close(con, pstmt);
		}
		return result;
	}
	
}
