package kr.co.scheduler.main;

import org.springframework.stereotype.Component;

@Component
public class SchedulerDTO {
	private int sch_seq;
	private String sch_title;
	private String sch_content;
	private String sch_writer;
	private String sch_start;
	private String sch_end;
	private String sch_mem_seq;
	
	public SchedulerDTO() {
		
	}

	public int getSch_seq() {
		return sch_seq;
	}

	public void setSch_seq(int sch_seq) {
		this.sch_seq = sch_seq;
	}

	public String getSch_title() {
		return sch_title;
	}

	public void setSch_title(String sch_title) {
		this.sch_title = sch_title;
	}

	public String getSch_content() {
		return sch_content;
	}

	public void setSch_content(String sch_content) {
		this.sch_content = sch_content;
	}

	public String getSch_writer() {
		return sch_writer;
	}

	public void setSch_writer(String sch_writer) {
		this.sch_writer = sch_writer;
	}

	public String getSch_start() {
		return sch_start;
	}

	public void setSch_start(String sch_start) {
		this.sch_start = sch_start;
	}

	public String getSch_end() {
		return sch_end;
	}

	public void setSch_end(String sch_end) {
		this.sch_end = sch_end;
	}

	public String getSch_mem_seq() {
		return sch_mem_seq;
	}

	public void setSch_mem_seq(String sch_mem_seq) {
		this.sch_mem_seq = sch_mem_seq;
	}
	
	
	

}
