import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;

public class SFTP_VAN {

	private String host;
	private Integer port;
	private String user;
	private String password;

	private JSch jsch;
	private Session session;
	private Channel channel;
	private ChannelSftp sftpChannel;

	public SFTP_VAN(String host, Integer port, String user, String password) {
		this.host = host;
		this.port = port;
		this.user = user;
		this.password = password;
	}

	public void connect() {

		System.out.println("connecting..." + host);
		try {
			jsch = new JSch();
			session = jsch.getSession(user, host, port);
			session.setConfig("StrictHostKeyChecking", "no");
			session.setPassword(password);
			session.connect();

			channel = session.openChannel("sftp");
			channel.connect();
			sftpChannel = (ChannelSftp) channel;

		} catch (JSchException e) {
			e.printStackTrace();
		}

	}

	public void disconnect() {
		System.out.println("disconnecting...");
		sftpChannel.disconnect();
		channel.disconnect();
		session.disconnect();
	}

	public void upload(String fileName, String remoteDir) {

		FileInputStream fis = null;
		connect();
		try {
			// Change to output directory
			sftpChannel.cd(remoteDir);

			// Upload file
			File file = new File(fileName);
			fis = new FileInputStream(file);
			sftpChannel.put(fis, file.getName());

			fis.close();
			System.out.println("File uploaded successfully - "
					+ file.getAbsolutePath());

		} catch (Exception e) {
			e.printStackTrace();
		}
		disconnect();
	}

	public void download(String fileName, String localDir) {

		byte[] buffer = new byte[1024];
		BufferedInputStream bis;
		connect();
		try {
			// Change to output directory
			String cdDir = fileName.substring(0, fileName.lastIndexOf("/") + 1);
			sftpChannel.cd(cdDir);

			File file = new File(fileName);
			bis = new BufferedInputStream(sftpChannel.get(file.getName()));

			File newFile = new File(localDir + "/" + file.getName());

			// Download file
			OutputStream os = new FileOutputStream(newFile);
			BufferedOutputStream bos = new BufferedOutputStream(os);
			int readCount;
			while ((readCount = bis.read(buffer)) > 0) {
				bos.write(buffer, 0, readCount);
			}
			bis.close();
			bos.close();
			System.out.println("File downloaded successfully - "
					+ file.getAbsolutePath());

		} catch (Exception e) {
			e.printStackTrace();
		}
		disconnect();
	}
	
	public static void filecopy(String path, String yesterday) {
		try {
			Runtime runtime = Runtime.getRuntime();
			
			String s_exe = "cmd /c md \\\\192.168.122.111\\oradata\\Van_Data\\SFTP\\" + yesterday;
			//System.out.println(s_exe);
			runtime.exec(s_exe);
			
			s_exe = "cmd /c move \\\\192.168.122.111\\oradata\\Van_Data\\SFTP\\*." + yesterday.substring(2) +  " \\\\192.168.122.111\\oradata\\Van_Data\\SFTP\\" + yesterday;
			//System.out.println(s_exe);
			runtime.exec(s_exe);
			
			s_exe = "xcopy /Y " + path + " \\\\192.168.122.111\\oradata\\Van_Data\\SFTP\\";
			//System.out.println(s_exe);
			runtime.exec(s_exe);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		
		Date date = new Date();
		Date yesterday = new Date();
		
		SimpleDateFormat today = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat now = new SimpleDateFormat("hh:mm:ss");
		
		yesterday.setTime(date.getTime() - ((long) 1000 * 60 * 60 *24));
	

		
		String localPath = "C:\\SFTP_VAN\\" + today.format(date);
		String yester	 = today.format(yesterday);
		//String localPath = "C:\\SFTP_VAN";
		String remotePath = "/home/marioo80/snd/";
		
		/*System.out.println("today = " + today.format(date));
		System.out.println("yesterday = " + today.format(yesterday));*/
		//localPath = "C:\\SFTP_VAN\\20180509";  //테스트용
		
		
		File folder = new File(localPath);
		folder.mkdirs();

		SFTP_VAN ftp_fdk = new SFTP_VAN("177.200.3.71", 22, "marioo80", "mario&223"); // FDK
		
		SFTP_VAN ftp_daou = new SFTP_VAN("192.168.41.216", 22, "marioo80", "mario&223"); // DAOU
		
		SFTP_VAN ftp_ksnet = new SFTP_VAN("210.181.29.21", 22, "marioo80", "mario&223"); // KSNET

		// ftp.upload(localPath+"filetoupload.txt", remotePath); 업로드 필요없음
		
		String today_yymmdd = today.format(date).substring(2);
		
		int today_int = Integer.parseInt(today.format(date));  
		
		//System.out.println("today_yymmdd : " + today_yymmdd);
		//today_yymmdd = "180509";  //테스트용도
		
		System.out.println("FDK_연결");
		ftp_fdk.download(remotePath + "MARIOOLT_KTLF12." + today_yymmdd, localPath);  //파일명 나중에 변경해야함
		System.out.println("FDK_완---료");
		
		/*if(today_int < 20181231)  // 20181220_강연식_KSNET 전용선 해지(20181231일자 로 해지)
		{  
			System.out.println("KSNET_연결");
			ftp_ksnet.download("/home/marioo80/MARIOOLT_KTLF01."  + today_yymmdd , localPath);   // 테스트
			System.out.println("KSNET_완---료");
		}*/
		
		System.out.println("DAOU_연결");
		ftp_daou.download("/home/marioo80/MARIOOLT_KTLF15." + today_yymmdd, localPath);  //테스트
		System.out.println("DAOU_완---료");
		
		filecopy(localPath,yester);

	}

}
