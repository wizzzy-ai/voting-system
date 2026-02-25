package com.bascode.util;

import java.util.Properties;

import jakarta.mail.*;
import jakarta.mail.internet.*;




public class EmailUtil {
    public static void sendVerificationEmail(String to, String otp) throws MessagingException {
        String host = "smtp.gmail.com";
        String from = "chisomwork17@email.com";
        final String username = "chisomwork17";
        final String password = "jyfsxbpbqkyfofhi";

        String subject = "Your OTP Code";
        String content = "Your OTP code for email verification is: " + otp + "\n\nEnter this code on the verification page to activate your account.";

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        
        Session session =  Session.getInstance(props, new Authenticator(){
        	protected PasswordAuthentication getPasswordAuthentication() {
        		return new PasswordAuthentication(username, password);
        	}
        });
        
        Message message = new MimeMessage(session);
        
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(content);

        Transport.send(message);
    }
}