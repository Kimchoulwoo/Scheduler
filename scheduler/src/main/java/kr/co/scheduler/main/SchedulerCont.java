package kr.co.scheduler.main;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import net.sf.json.JSONArray;

@Controller
public class SchedulerCont {

	@Autowired
	SchedulerDAO dao;

	public SchedulerCont() {
		System.out.println("SchedulerCont");
	}

	
//	@RequestMapping(value = "scheduler.do", method = RequestMethod.GET)
//	@ResponseBody
//	public ModelAndView list(HttpSession session) {
//		ModelAndView mav = new ModelAndView();
//		JSONArray jsonArray = new JSONArray(); // List를 Json형식으로 쓸때 사용<maven> 추
//		
//		String uid = session.getAttribute("uid").toString();
//		String seq = session.getAttribute("seq").toString();
//		
//		//My schedule
//		List<Map<String, Object>> sch_list = dao.list(uid);
//		mav.addObject("list", jsonArray.fromObject(sch_list));
//		
//		//Share schedule
//		List<Map<String, Object>> sch_share_list = dao.shareList(seq, uid);
//		mav.addObject("share_list", jsonArray.fromObject(sch_share_list));
//		
//		mav.setViewName("scheduler");
//		return mav;
//	}
	
	@RequestMapping(value = "scheduler.do", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView list(HttpSession session) {
		ModelAndView mav = new ModelAndView();
		if(session.getAttribute("uid") == null) {
			mav.addObject("message", "로그인 후 이용해주세요.");
			mav.setViewName("index");
		}else {
			mav.setViewName("scheduler");
		}
		return mav;
	}

	@RequestMapping(value = "list.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> list(HttpSession session, @RequestBody Map<String,Object> params) {
		
		String uid = session.getAttribute("uid").toString();
		String start = params.get("start").toString();
		String end = params.get("end").toString();

		//My schedule
		List<Map<String, Object>> sch_list = dao.list(uid, start, end);

		return sch_list;
	}
	
	@RequestMapping(value = "sharelist.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> sharelist(HttpSession session, @RequestBody Map<String, Object> params) {
		
		String uid = session.getAttribute("uid").toString();
		String seq = session.getAttribute("seq").toString();
		String start = params.get("start").toString();
		String end = params.get("end").toString();

		//Share schedule
		List<Map<String, Object>> sch_share_list = dao.shareList(seq, uid, start, end);
	
		return sch_share_list;
	}

	//ajax post 방식일때 jackon-databind pom.xml 추가
	//spring 버전 4.2.5 이하는 jackon-databind 2.6.3이하 버전으로
	@RequestMapping(value = "submit.do", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	@ResponseBody
	public String submit(@RequestBody Map<String, Object> params, HttpServletRequest req, SchedulerDTO dto, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		dto.setSch_title(params.get("title").toString());
		dto.setSch_content(params.get("content").toString());
		dto.setSch_writer(params.get("writer").toString());
		dto.setSch_start(params.get("start").toString());
		dto.setSch_end(params.get("end").toString());
		String mem_seq = params.get("member").toString();
		
		mem_seq = mem_seq.replace("[", "");
		mem_seq = mem_seq.replace("]", "");
		
		dto.setSch_mem_seq(mem_seq);
		
		int result = dao.submit(dto);
		
		if(result == 0) {
			return "일정 저장에 실패";
		}else {	
			return "일정이 저장됨";
		}
	}
	
	@RequestMapping(value="/read.do", method=RequestMethod.POST)
	@ResponseBody
	public ArrayList read(HttpSession session, @RequestBody Map<String, String> params){
		ArrayList list = new ArrayList<>();
		Map<String, String> map_read = new HashMap<>();
		Map<String, String> map_read_mem = new HashMap<>();

		String seq = params.get("seq");
		
		//read schedule
		map_read = dao.read(seq);
		list.add(map_read);
		
		if(!map_read.get("mem_seq").equals("")) {
			//share member
			String mem_seq[]= map_read.get("mem_seq").split(",");
			
			for(int i=0; i<mem_seq.length; i++) {
				list.add(dao.read_mem(mem_seq[i]));
			}
		}
		return list;
	}
	
	@RequestMapping(value="/modify.do", method=RequestMethod.GET)
	public ModelAndView modify(HttpSession session, HttpServletRequest req){
		ModelAndView mav = new ModelAndView();
		ArrayList list = new ArrayList<>();
		Map<String, String> map_read = new HashMap<>();

		String seq = req.getParameter("seq");
		
		//read schedule
		map_read = dao.read(seq);
		
		if(!map_read.get("mem_seq").equals("")) {
			//share member
			String mem_seq[]= map_read.get("mem_seq").split(",");
			
			for(int i=0; i<mem_seq.length; i++) {
				list.add(dao.read_mem(mem_seq[i]));
			}
		}
		mav.addObject("map", map_read);
		mav.addObject("list", list);
		mav.addObject("seq", seq);
		mav.setViewName("modify");
		
		return mav;
	} 
	
	@RequestMapping(value="/modify.do", method=RequestMethod.POST)
	@ResponseBody
	public String modify(@RequestBody Map<String, Object> params, SchedulerDTO dto) {
		
		dto.setSch_title(params.get("title").toString());
		dto.setSch_content(params.get("content").toString());
		dto.setSch_writer(params.get("writer").toString());
		dto.setSch_start(params.get("start").toString());
		dto.setSch_end(params.get("end").toString());
		String mem_seq = params.get("member").toString();
		mem_seq = mem_seq.replace("[", "");
		mem_seq = mem_seq.replace("]", "");
		dto.setSch_mem_seq(mem_seq);
		dto.setSch_seq(Integer.parseInt(params.get("seq").toString()));
		
		int result = dao.modify(dto);
		
		if(result==0) {
			return "false";
		}else {
			return "true";
		}
	}
	
	@RequestMapping(value="/delete.do", method=RequestMethod.POST)
	@ResponseBody
	public String delete(@RequestBody Map<String, Object> params) {
		int seq = Integer.parseInt(params.get("seq").toString());
		
		int result = dao.delete(seq);
		
		if(result==0) {
			return "false";
		}else {
			return "true";
		}
	}
	
	
}
