package com.microfocus.sugahara.taro.case_count;

public class SupportCase {
	String interactionID;
	String username;
	int year;
	int month;
	int day;
	String pickupType;

	public SupportCase(String interactionID, String username, int year, int month, int day, String pickupType) {
		this.interactionID = interactionID;
		this.username = username;
		this.year = year;
		this.month = month;
		this.day = day;
		this.pickupType = pickupType;
	}
	
	public String getInteractionID() {
		return interactionID;
	}
	
	public String getUsername() {
		return username;
	}

	public int getYear() {
		return year;
	}
	
	public int getMonth() {
		return month;
	}
	
	public int getDay() {
		return day;
	}
	
	public String getPickupType() {
		return pickupType;
	}
}
