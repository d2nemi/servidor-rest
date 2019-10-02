token=localStorage.getItem('token');
$fullscren = $('#fullscren').hide();
$loading = $('#ajax_loard').hide();
intervalo=1000;
Offline=false;
 
 
 $.ajaxSetup({ 
	cache: false,
	headers: {
		"key": token,
	}
});

$(document)
		.ajaxStart(function () { 
			$loading.show();
		}).ajaxStop(function () {
			$loading.hide();
		}).ajaxComplete(function () {
			$loading.hide();
		}).ajaxError(function (jqXHR, Rp, errorThrown) {
			if(Rp.status==401){
				MsngBoxErro('Erro', 'Autenticação requerida para completa esse processo!!');
				window.location.href = "login.html";
			}else if(Rp.status==0){
				$fullscren.show();
				if (Offline==false){
					Offline=true;		
					MsngBoxErro('Erro na conexão', 'O Servidor não esta disponível no momento');				 
				}				
				
				setTimeout(authenticated,5000);
			}
			$loading.hide();
});
		
 function authenticated() {
	 
		$.ajax({
			type: 'POST'
			,url: 'http://'+var_servidor+'/authenticated?key='+token
			,success: function (data) {
				Offline=false;
				if(data){
					if (data.result==true) {
						return true
					}else{
						return false	
					}
					
				}else{
					return false
				}
			
			},
			error: function (jqXHR, textStatus, errorThrown) {
				return false
			}
		});	
 };	
 