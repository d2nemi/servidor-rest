	

//--------------------------------------porta----------------------------------------------------
function delete_banco(ban_codigo,nome)
{
			bootbox.dialog({
                message: "Você tem certeza de que quer excluir o porta <b>"+ban_codigo+" a "+nome+"</b> da lista de controlde de firewall?",
                title: "Confirma",
                buttons: {
                    main: {
                        label: "<i class='fa fa-reply'></i> Não ",
                        className: "btn-primary",
                        callback: function () {
                        }
                    },
                    danger: {
                        label: "<i class='fa fa-trash-o'></i> Sim ",
                        className: "btn-danger",
                        callback: function () {
                            ExcluirRegistro(var_http+'://'+var_servidor+'/banco?ban_codigo='+ban_codigo, 'grid-banco');
                        }
                    }
                }
            });
};
			
function post_banco(method) {  

			var vdata='{"ban_codigo": '+JSON.stringify($("#ban_codigo").val())+
                       ',"ban_nome": '+JSON.stringify($("#ban_nome").val())+'}';  
     
			console.log('method',method);
			console.log('vdata',vdata);
	   
			$.ajax({
				type: ''+method+''
				,url: var_http+'://'+var_servidor+'/banco'			
				,contentType: "application/json; charset=UTF-8"	 
				,data: vdata
				, beforeSend: function () {                    
					$("#btn_salvar").addClass('disabled');
				}
				, complete: function () {                  
					$("#btn_salvar").removeClass('disabled');
				}
				, success: function (data) {
					console.log('result',data);
					if (data.result==true) {
						var table = $('#grid-banco').DataTable();
						table.ajax.reload();
						$("#myModal").modal('hide');
					} else {
						$("#btn_salvar").removeClass('disabled');
						MsngBoxErro('Erro ao salvar os dados', data.message)
					}
				},
				error: function (jqXHR, textStatus, errorThrown) {
					MsngBoxErro('Erro ao enviar a solicitação', 'Erro:' + errorThrown + textStatus);
					$("#btn_salvar").removeClass('disabled');
				}
			});
					
			
			return true
};
