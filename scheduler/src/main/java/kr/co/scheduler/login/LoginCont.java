package kr.co.scheduler.login;

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
public class LoginCont {

	@Autowired
	LoginDAO dao;

	@RequestMapping(value="login.do", method=RequestMethod.POST)
	public ModelAndView login(LoginDTO dto, HttpServletRequest req) {
		ModelAndView mav = new ModelAndView();

		String id = req.getParameter("user_id");
		String pw = req.getParameter("user_pw");
		dto.setId(id);
		dto.setPassword(pw);
		String result[] = dao.login(dto);
		if (result != null) {
			// login session
			HttpSession session = req.getSession();
			session.setAttribute("uid", result[0]);
			session.setAttribute("seq", result[1]);
			session.setAttribute("uname", result[2]);
			//mav.setViewName("scheduler");
			mav.setViewName("redirect:/scheduler.do");
		}else {
			mav.addObject("message", "아이디 비밀번호를 확인해주세요.");
			mav.setViewName("index");
		}
		return mav;
	}
	
	@RequestMapping(value="/logout.do", method=RequestMethod.POST, produces = "application/text; charset=utf8")
	@ResponseBody
	public String logout(HttpSession session) {
		
		session.removeAttribute("uid");
		session.removeAttribute("uname");
		session.removeAttribute("seq");
		
		return "로그아웃되셨습니다.";
	}
	
	@RequestMapping(value="/join.do", method=RequestMethod.POST, produces="application/text; charset=utf8")
	@ResponseBody
	public String join(@RequestBody Map<String, Object> params) {
		String id = params.get("id").toString();
		String pw = params.get("pw").toString();
		String name = params.get("name").toString();
		
		int result = dao.join(id, pw, name);
		if(result == 0) {
			return "회원가입에 실패하였습니다.";
		}else {
			return "회원가입이 완료되었습니다.";
		}
	}

}
