package kr.co.scheduler.search;

import org.springframework.stereotype.Component;

@Component
public class SearchDTO {
	private String mem_seq;
	private String mem_id;
	private String mem_pw;
	private String mem_name;
	private String mem_mail;
	private String mem_phone;
	private String mem_dep;
	private String mem_rank;
	
	
	public String getMem_seq() {
		return mem_seq;
	}
	public void setMem_seq(String mem_seq) {
		this.mem_seq = mem_seq;
	}
	public String getMem_id() {
		return mem_id;
	}
	public void setMem_id(String mem_id) {
		this.mem_id = mem_id;
	}
	public String getMem_pw() {
		return mem_pw;
	}
	public void setMem_pw(String mem_pw) {
		this.mem_pw = mem_pw;
	}
	public String getMem_name() {
		return mem_name;
	}
	public void setMem_name(String mem_name) {
		this.mem_name = mem_name;
	}
	public String getMem_mail() {
		return mem_mail;
	}
	public void setMem_mail(String mem_mail) {
		this.mem_mail = mem_mail;
	}
	public String getMem_phone() {
		return mem_phone;
	}
	public void setMem_phone(String mem_phone) {
		this.mem_phone = mem_phone;
	}
	public String getMem_dep() {
		return mem_dep;
	}
	public void setMem_dep(String mem_dep) {
		this.mem_dep = mem_dep;
	}
	public String getMem_rank() {
		return mem_rank;
	}
	public void setMem_rank(String mem_rank) {
		this.mem_rank = mem_rank;
	}
	
	
	
}
