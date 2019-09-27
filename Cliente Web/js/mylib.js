var var_servidor='192.168.254.234';
var var_http='http';

function MyLoad(url, content, parm) {
    
    if (content === '' || content === undefined) {
        content = 'view_content';
    }

    $("#" + content + "").show(0);

    $.ajax({
        url: url,
        cache: false,
        dataType: "html",
        method: "GET",		
        data: parm,
        beforeSend: function () {
        },
        complete: function () {
        },
        success: function (data) {
			
            $("#" + content + "").html(data);
        },
        error: function (jqXHR, textStatus, errorThrown) {
            show_loard(0)
            MsngBoxErro('Erro ao carrega a  pagina  solicitada '+ url, 'Erro: ' + errorThrown);
        }
    });

    return false;
}


function MsngBoxInfor(titulo, msg) {
    if (titulo === '' || titulo === undefined) {
        titulo = '';
    }
    bootbox.alert('<div class="callout callout-info"><h4>' + titulo + '</h4>' + msg, function () {
        console.log(msg);
    });
}

function MsngBoxAtencao(titulo, msg) {
    if (titulo === '' || titulo === undefined) {
        titulo = '';
    }
    bootbox.alert('<div class="callout callout-warning"><h4>' + titulo + '</h4>' + msg, function () {
        console.log(msg);
    });
}

function MsngBoxErro(titulo, msg) {
    if (titulo === '' || titulo === undefined) {
        titulo = 'Erro na solicitação1!';
    }
    bootbox.alert('<div class="callout callout-danger"><h4>' + titulo + '</h4>' + msg, function () {
        console.log(msg);
    });
}



function ExcluirRegistro(var_url, gridUpdate) {
	console.log('var_url',var_url);
	console.log('gridUpdate',gridUpdate);

	$.ajax({
	type: "DELETE"
	,url: var_url			
	,dataType : 'json'	
	,contentType: "application/json"    
	,async: true  
	,crossDomain: true          
		, success: function (data) {                        
			var table = $('#'+gridUpdate).DataTable();
			table.ajax.reload();
			console.log('data',data);			
			if (data.result==true) {
				$.notify({
					title: '<strong>Registro Removido</strong><br>',
					message: 'O Registro foi removido com sucesso' 
					},{
						type: 'success'
				});	
			}else{
				MsngBoxErro('Erro ao excluir o registro', 'Erro: ' + data.message);	
			}
		},
		error: function (jqXHR, textStatus, errorThrown) {
			MsngBoxErro('Erro na solicitação os dados', 'Erro: ' + errorThrown);
		}
	}); 
return true
}