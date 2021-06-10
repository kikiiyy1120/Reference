import java.security.Key;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
 
public class AES128 {
	private String ips;
    private Key keySpec;
	
	public AES128() {
		String key = "16byte 암호화키";
        try {
            byte[] keyBytes = new byte[16];
            byte[] b = key.getBytes("UTF-8");
            System.arraycopy(b, 0, keyBytes, 0, keyBytes.length);
            SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
            this.ips = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"; //null 16bytes IV
            this.keySpec = keySpec;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
	
	public AES128(String key) {
        try {
            byte[] keyBytes = new byte[16];
            byte[] b = key.getBytes("UTF-8");
            System.arraycopy(b, 0, keyBytes, 0, keyBytes.length);
            SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
            this.ips = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"; //null 16bytes
            this.keySpec = keySpec;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 
    public String encrypt(String str) {
        Cipher cipher;
        try {
            cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(ips.getBytes()) );
 
            byte[] encrypted = cipher.doFinal(str.getBytes("UTF-8"));
            String Str = new String(byteArrayToHex(encrypted).toUpperCase());

            return Str;
        } catch (Exception e) {
        	return null;
        }
    }
 
    public String decrypt(String str) {
        try {
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(ips.getBytes("UTF-8")));
 
            byte[] byteStr = hexToByteArray(str);
            String Str = new String(cipher.doFinal(byteStr), "UTF-8");
 
            return Str;
        } catch (Exception e) {
            return null;
        }
    }
    
    //byte[]->hex String
    private String byteArrayToHex(byte[] encrypted) {
        
        if(encrypted ==null || encrypted.length ==0){
            return null;
        }
         
        StringBuffer sb =new StringBuffer(encrypted.length *2);
        String hexNumber;
         
        for(int x=0; x<encrypted.length; x++){
            hexNumber ="0" + Integer.toHexString(0xff & encrypted[x]);
            sb.append(hexNumber.substring(hexNumber.length() -2));
        }
         
        return sb.toString();
    }
    //hex String->byte[]
    private byte[] hexToByteArray(String hex) {
        
        if(hex == null || hex.length() == 0){
            return null;
        }
         
        byte[] byteArray = new byte[hex.length() /2 ];
         
        for(int i=0; i<byteArray.length; i++){
            byteArray[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2*i+2), 16);
        }
        return byteArray;
    }
}
