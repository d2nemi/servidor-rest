var token=localStorage.getItem('token');
$fullscren = $('#fullscren').hide();
intervalo=1000;

 function authenticated() {
	 
		$.ajax({
				type: 'POST'
				,url: 'http://'+var_servidor+'/authenticated?key=ADFFASDFASFDA65S4FA46F4A6F46AS4D5FA4S5F464'+token
				,cache: false	
				,contentType: "application/json; charset=UTF-8"	 
					, beforeSend: function () {                    
						$("#ajax_loard").hide();
					}
					,success: function (data) {
						
						console.log('authenticated',data);					
						
						if(data){
							
							if (data.result==false) {
								window.location.href = "login.html";
							}else{
								$fullscren.hide();
								intervalo=6000; //Cada um minuto faz uma verificação
								//console.log('Atuenticado',data.result);

								var url  = window.location.href; 
								var absoluto = url.split("/")[url.split("/").length -1];
								//console.log('absoluto',absoluto);
								 if ((absoluto!= 'adm.html') & (absoluto!= 'adm.html#')) 
									window.location.href = "adm.html";
							}
							
						}else{
							window.location.href = "login.html";
						}
						
					},
					error: function (jqXHR, textStatus, errorThrown) {
						$fullscren.show();
						intervalo=5000;
					}
		});	
 }

var recursiva = function () {
	
    //console.log('intervalo',intervalo);
	setTimeout(recursiva,intervalo);
	setTimeout(authenticated,100);
}

recursiva();