<%--
Copyright (c) 2011, salesforce.com, inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided
that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the
following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or
promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
--%>

<%@ page import="java.util.Map" %>
<%@ page import="canvas.SignedRequest" %>
<%@ page import="canvas.ToolingAPI" %>
<%
	
    // Pull the signed request out of the request body.
    Map<String, String[]> parameters = request.getParameterMap();
    String[] signedRequest = parameters.get("signed_request");
    if ("GET".equals(request.getMethod()) || signedRequest == null) {%>
    <jsp:forward page="welcome.jsp"/><%
    }
    else {
    	//Load the metadata
    	String yourConsumerSecret=System.getenv("CANVAS_CONSUMER_SECRET");
    	String signedRequestJson = SignedRequest.verifyAndDecodeAsJson(signedRequest[0], yourConsumerSecret);
    	ToolingAPI.fetchMetadata(signedRequest[0], yourConsumerSecret);
    %>
    	On canvas.jsp about to go to signed-request.... 
    	<script>
        	document.getElementById('requestLink').disabled = true;
			var sr;
	        Sfdc.canvas(function() {
	            sr = JSON.parse('<%=signedRequestJson%>');
	            ToolingAPI.firstName = sr.context.user.firstName;
	            ToolingAPI.lastName = sr.context.user.lastName;
	            ToolingAPI.org = sr.context.user.lastName;
	            //Sfdc.canvas.byId('firstname').innerHTML = sr.context.user.firstName;
	            //Sfdc.canvas.byId('lastname').innerHTML = sr.context.user.lastName;
	            //Sfdc.canvas.byId('company').innerHTML = sr.context.organization.name;
	        });
	        alert("about to forward to signed-request page!");
	        console.log("about to forward to signed-request page!");
	        document.getElementById('requestLink').disabled = false;
    		//window.location.replace = '../signed-request.jsp?sr=' + sr;
    		//return false;
    	</script>
    	<a href="https://apex-codeanalysis.herokuapp.com/signed-request.jsp" id="requestLink">Click Here when ready</a>
    	<%-- <jsp:forward page="signed-request.jsp"/> --%><%
    }
%>
