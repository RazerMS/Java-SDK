<%--
/*
 * The MIT License
 *
 * Copyright 2018 MOLPay Sdn Bhd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
--%>

<%@page import="molpay.controller"%>
<%@page import="molpay.molpay"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="java.net.URL"%>
<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@page import="javax.net.ssl.SSLContext"%>
<%@page import="javax.net.ssl.X509TrustManager"%>
<%@page import="javax.net.ssl.TrustManager"%>

<%!

    

%>
<html>
   <head>
      <title>Callback URL</title>
   </head>
   <body>
      
     <% 
        /***********************************************************
        * Set the values received from MOLPay's payment page
        ************************************************************/
        controller data = new controller();
        // nbcb = Always equal to 1, which indicates this is a callback noti from MOLPay.
        // nbcb = Always equal to 2, which indicates this is a notification from MOLPay.
        data.setNbcb(request.getParameter("nbcb")); 
        data.setSkey(request.getParameter("skey"));
        data.setTranID(request.getParameter("tranID"));
        data.setDomain(request.getParameter("domain"));
        data.setStatus(request.getParameter("status"));
        data.setAmount(request.getParameter("amount"));
        data.setCurrency(request.getParameter("currency"));
        data.setPaydate(request.getParameter("paydate"));
        data.setOrderid(request.getParameter("orderid"));
        data.setAppcode(request.getParameter("appcode"));
        data.setError_code(request.getParameter("error_code"));
        data.setError_desc(request.getParameter("error_desc"));
        data.setChannel(request.getParameter("channel"));
        data.setExtraP(request.getParameter("extraP")); 
        out.println(data.getDemo_type()); // Print out demo type
     %>
      
      <%
        /***********************************************************
        * To verify the data integrity sending by MOLPay
        ************************************************************/
        
        String key1 = molpay.generateKeys(data.getTranID(), data.getOrderid(), data.getStatus(), data.getDomain(), data.getAmount(), data.getCurrency(), data.getPaydate(), data.getAppcode(), data.getSecretkey() );
        out.println("status : " + data.getStatus() + "<br>");
        out.println("key1 : " + key1 + "<br>");
        out.println("skey : " + data.getSkey() + "<br>");
      %>    
      
       <% if (!key1.equals( data.getSkey() )) data.setStatus("-1"); /* Invalid transaction */ %>

       <% if(data.getStatus().equals("00")){
           // Write your script here e.g. check_cart()    
        }
        else {
            out.println(data.getStatus() + "<br>" + "Ops something just went wrong. Your transaction have been detected as fraud ");
        } 

        if( data.getNbcb().equals("1")){
             out.println("CBTOKEN:MPSTATOK");
        }
        
        if( data.getNbcb().equals("2")){
        /***********************************************************
        * IPN Snippet code is the enhancement required
        * by merchant to add into their return script in order to
        * implement backend acknowledge method for notification IPN
        ************************************************************/
        molpay securitycert = new molpay();
        out.println("<br>" + "\nMerchant have sent IPN");
        String urlP = securitycert.IPN_Notification(data.getDemo_type(), data.getNbcb(), data.getSkey(), data.getTranID(), data.getDomain(), data.getStatus(), data.getAmount(), data.getCurrency(), data.getPaydate(), data.getOrderid(), data.getAppcode(), data.getError_code(), data.getError_desc(), data.getChannel(), data.getExtraP());
        out.println(urlP);
        }
      %>           
   </body>
</html>
