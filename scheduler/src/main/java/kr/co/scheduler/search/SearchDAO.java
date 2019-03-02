package kr.co.scheduler.search;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import net.utility.DbClose;
import net.utility.DbOpen;

@Component
public class SearchDAO {
	@Autowired
	DbOpen dbopen = null;

	@Autowired
	DbClose dbclose = null;

	public SearchDAO() {
		System.out.println("SearchDAO()");
	}

	Connection con = null;
	StringBuffer sql = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	public ArrayList memList(String uid) {
		ArrayList list = null;

		try {
			con = dbopen.getConnection();
			sql = new StringBuffer();
			sql.append(" SELECT mem_seq, mem_dep, mem_rank, mem_name ");
			sql.append(" FROM member WHERE mem_id != ?");
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				list = new ArrayList();
				do {
					Map<String, Object> map = new HashMap<>();
					map.put("mem_seq", rs.getString("mem_seq"));
					map.put("mem_dep", rs.getString("mem_dep"));
					map.put("mem_rank", rs.getString("mem_rank"));
					map.put("mem_name", rs.getString("mem_name"));
					list.add(map);
				} while (rs.next());
			}

		} catch (Exception e) {
			System.out.println("memList fail" + e);
		} finally {

		}
		return list;
	}

	public ArrayList search_mem_list(String uid, String option, String content) {
		ArrayList list = null;
		try {
			con = dbopen.getConnection();
			sql = new StringBuffer();
			sql.append(" SELECT mem_seq, mem_dep, mem_rank, mem_name ");
			sql.append(" FROM member WHERE ");
			if (!content.equals("")) {
				if (option.equals("mem_dep")) {
					sql.append(" mem_dep like '%" + content + "%' AND ");
				} else if (option.equals("mem_rank")) {
					sql.append(" mem_rank like '%" + content + "%' AND ");
				} else if (option.equals("mem_name")) {
					sql.append(" mem_name like '%" + content + "%' AND ");
				}
			}
			sql.append(" mem_id !=? ");
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				list = new ArrayList();
				do {
					Map<String, Object> map = new HashMap<>();
					map.put("mem_seq", rs.getString("mem_seq"));
					map.put("mem_dep", rs.getString("mem_dep"));
					map.put("mem_rank", rs.getString("mem_rank"));
					map.put("mem_name", rs.getString("mem_name"));
					list.add(map);
				} while (rs.next());
			}

		} catch (Exception e) {
			System.out.println("memList fail" + e);
		} finally {

		}

		return list;
	}

}
