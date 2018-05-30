/*
	- FUNÇÃO PARA EXPORTAR DADOS DE UMA TABELA DO SQL SERVER PARA UM ARQUIVO .txt
	- PARA A FUNÇÃO FUNCIONAR CORRETAMENTE É NECESSÁRIO HABILITAR O xp_cmdshell
	- EM VERSÕES FUTURAS, ESTA FUNÇÃO HABILITARÁ E DESABILITARÁ ESTA FUNCIONALIDADE 
			EM TEMPO DE EXECUÇÃO

	@param: datasource (composto pelo nome do banco + nome do eschema + nome da tabela
	@param: file_target(é o caminho (diretório + nome do arquivo) para onde os dados devem ser exportados

	@return: retorna um integer indicando o total de erros ocorrido durante a execução da função
*/
CREATE FUNCTION exportToFile(@datasource text, @file_target text) RETURNS INTEGER AS
BEGIN
	DECLARE @error INTEGER,
			@cmd_string varchar(150)

	SET @cmd_string = CONCAT('BCP ', @datasource, ' OUT ', @file_target, ' -T -c -t;')
	EXEC @error = master..xp_cmdshell @cmd_string
	RETURN @error
END
go


/*
	EXEMPLOS DE USO DA FUNÇÃO exportToFile(@datasource, @file_target)
*/
select dbo.exportToFile('db_Escola.dbo.tbl_alunos', 'C:/BCP/tbl_alunos4.txt')
select dbo.exportToFile('bd_exemplos_devmedia.dbo.VENDAS','C:/BCP/tblVendas.txt')








/*
	COMO HABILITAR O xp_cmdshell
*/
exec sp_configure 'show advanced options', 1
go
reconfigure
go
EXEC sp_configure 'xp_cmdshell', 1
go
reconfigure
go
