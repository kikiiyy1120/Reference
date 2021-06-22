package com.erp.common;

import java.security.MessageDigest;

public class SHA256 {
	
	public static void main(String[] args){
		SHA256 qwe =new SHA256();
		qwe.encrypt("test1234");
	}
	
    public String encrypt(String str){
    	try{
    		//해쉬함수 SHA-256 인스턴스 생성
    		MessageDigest md = MessageDigest.getInstance("SHA-256");
    		//암호화
    		md.update(str.getBytes("UTF-8"));
    		//16진수로 변환 후 리턴
    		return byteArrayToHex(md.digest()).toUpperCase();
    	}
    	catch(Exception e){
    		return null;
    	}
    }

    //byte[]->hex String
    private String byteArrayToHex(byte[] encrypted) {
        
        if(encrypted == null || encrypted.length == 0){
            return null;
        }
        
        StringBuffer sb = new StringBuffer();
        for (byte b : encrypted) {
        	//앞 빈자리 0으로 채우는 16진수 (16진수는 2자리)
        	sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
