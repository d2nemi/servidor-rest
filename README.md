Servidor REST + SSL em DELPHI usando os componentes nativos

# Servidor Desktop
  Delphi 10.3 (Rio)
  
  VCL Indy 10 ( THTTPServer + SSL )
  
  VCL FastReport 6
  
# Cliente Web
 Bootstrap 4
 
 JQuery
  
#
# Exemplo obter registro
GET http://servidor/banco

GET http://servidor/banco?id=1

# Exemplo exlcuir registro
DELETE http://servidor/banco?id=1000

# Exemplo atualizar registro
PUT http://servidor/banco

RAW {"ban_codigo": 1000,"ban_nome": "Banco do Brasil S.A"}

# Exemplo incluir registro
POST http://servidor/banco

$.ajax({

	"url": "http://localhost/banco",
  
	"method": "POST",
  
	contentType: "application/json; charset=UTF-8",
  
	"data": "{"ban_codigo":1,"ban_nome":"Banco do Brasil S.A"}",
  
	"headers": {
  
		"key": "key_debug"// Token do usuario
	
	},
  
	success: function (data) {
  
		console.log('result',data);
		
	}
  
});

# Exemplo imprimir um relatorio em PDF
Retorna o arquivo PDF gerado no servidor 

GET http://servidor//relatorios/bancos?return=data

Retorna o arquivo JSON com as informações do arquivo gerado no servidor 

GET http://servidor/relatorios/bancos

Gerar um relatorio com um registro

GET http://servidor/relatorios/bancos?ban_codigo=1

Gerar um relatorio do registro 10 ao 20

GET http://servidor/relatorios/bancos?offset=10&limit=20

# Download de arquivo do servidor
GET http://servidor/files/img.jpg

# Upload de arquivo para o servidor
POST http://servidor/fileupload

#

# Utilizar Token no modo debug
Para fazer testes no modo debug sem a necessidade de um usuário autenticado, existe um token gerado internamente com o Identificador “key_debug” 

Desabilitado no modo reliase.

GET http://servidor/relatorios/bancos?key=key_debug


# Exemplo com JQuery Token

	$.ajax({
	
		async: false,
		
		crossDomain: true,	
		//com parametro sem header
		
		//url: "http://servidor/banco?key=key_debug",
		
		//Com header sem parametro
		url: "http://servidor/banco",
		
		method: "POST",
		
		contentType: "text/plain",
		
		data: '{"ban_codigo":1,"ban_nome":"Banco do Brasil S.Asss"}',
		
		//Remove se for com parametro key na URL
		
		headers: {
		
			"key": "key_debug",
			
		},
		success: function (data) {
	  
			console.log('result',data);
						
		}
	  
	});
#

NOTA 

Ferramenta utilizada para realizar os teste como cliente web

Baixa Postman https://github.com/postmanlabs/postman-app-support/ 

