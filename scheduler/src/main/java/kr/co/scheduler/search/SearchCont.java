package kr.co.scheduler.search;

import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SearchCont {
	@Autowired
	SearchDAO dao;

	public SearchCont() {
		System.out.println("SearchCont()");
	}
	
	@RequestMapping(value="search.do", method=RequestMethod.GET)
	public ModelAndView search(HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		
		if(request.getParameter("seq_Array") != null) {
			String seq_Array=request.getParameter("seq_Array").toString();
			mav.addObject("seq_Array", seq_Array);
		}
		
		mav.setViewName("search");
		return mav;
	}
	
	@RequestMapping(value="search.do", method=RequestMethod.POST)
	@ResponseBody
	public ArrayList search_mem(HttpSession session) {
		
		String uid = session.getAttribute("uid").toString();		
		
		return dao.memList(uid);
	}
	
	@RequestMapping(value="search_mem.do", method=RequestMethod.POST)
	@ResponseBody
	public ArrayList search(@RequestBody Map<String, Object> params, HttpSession session,HttpServletRequest request) {
		
		String uid = session.getAttribute("uid").toString();
		String seq_Array=request.getParameter("seq_Array");
		String option = params.get("option").toString();
		String content = params.get("content").toString();
		
//		mav.addObject("seq_Array", seq_Array);
//		mav.addObject("list",);
//		
		return dao.search_mem_list(uid, option, content);
	}
	
	
}
