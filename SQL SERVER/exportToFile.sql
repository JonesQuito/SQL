/*
	- FUN��O PARA EXPORTAR DADOS DE UMA TABELA DO SQL SERVER PARA UM ARQUIVO .txt
	- PARA A FUN��O FUNCIONAR CORRETAMENTE � NECESS�RIO HABILITAR O xp_cmdshell
	- PARA EVITAR A NECESSIDADE DE HABILITAR O xp_cmdshell, PODE-SE USAR A 
		PROCEDURE runExportToFile(@datasource text, @file_target text). A EXECU��O
		DA REFERIDA PROCEDURE:
			- HABILITA O xp_cmdshell,
			- EXECUTA A FUN��O exportToFile E
			- DESABILITA O xp_cmdshell
		
	@param: datasource (composto pelo nome do banco + nome do eschema + nome da tabela
	@param: file_target(� o caminho (diret�rio + nome do arquivo) para onde os dados devem ser exportados
	@param: uma string com op��es de configura��o do BCP. O padr�o � ' -T -c -t;'

	@return: retorna um integer indicando o total de erros ocorrido durante a execu��o da fun��o

	EXEMPLOS DE USO: 
		- select dbo.exportToFile('db_Escola.dbo.tbl_alunos', 'C:/BCP/tbl_alunos4.txt', @options= default)
		- select dbo.exportToFile('bd_exemplos_devmedia.dbo.VENDAS','C:/BCP/tblVendas.txt', @options= ' -T -c -t"|"')
*/
CREATE FUNCTION exportToFile(@datasource text, @file_target text, @options text = ' -T -c -t;') RETURNS INTEGER AS
BEGIN
	DECLARE @error INTEGER,
			@cmd_string varchar(150)

	SET @cmd_string = CONCAT('BCP ', @datasource, ' OUT ', @file_target, @options)
	EXEC @error = master..xp_cmdshell @cmd_string
	RETURN @error
END
go




/*
	PROCEDURE RESPONS�VEL POR HABILITAR O xp_cmdshell

	EXEMPLO DE USO:
		- exec dbo.enable_xp_cmdshell
*/
CREATE PROCEDURE enable_xp_cmdshell AS
BEGIN
	exec sp_configure 'show advanced options', 1
	reconfigure
	EXEC sp_configure 'xp_cmdshell', 1
	reconfigure	
	RETURN
END
go




/*
	PROCEDURE RESPONS�VEL POR DESABILITAR O xp_cmdshell

	EXEMPLO DE USO:
		- exec dbo.disable_xp_cmdshell
*/
CREATE PROCEDURE disable_xp_cmdshell AS
BEGIN
	EXEC sp_configure 'xp_cmdshell', 0
	reconfigure
	exec sp_configure 'show advanced options', 0
	reconfigure
	RETURN
END
go




/*
	PROCEDURE QUE ENCAPSULA OS PROCEDIMENTOS DE:
		- HABILITAR O xp_cmdshell,
		- EXUCUTAR A FUN��O exportToFile E
		- DESABILITAR O xp_cmdshell

	@param: datasource (composto pelo nome do banco + nome do eschema + nome da tabela
	@param: file_target(� o caminho (diret�rio + nome do arquivo) para onde os dados devem ser exportados
	@param: uma string com op��es de configura��o do BCP. O padr�o � ' -T -c -t;'

	EXEMPLOS DE USO:
		- exec dbo.runExportToFile @datasource='db_Escola.dbo.tbl_alunos', @file_target='C:/BCP/tbl_alunos25.txt', @options= default
		- exec dbo.runExportToFile @datasource='db_Escola.dbo.tbl_alunos', @file_target='C:/BCP/tbl_alunos26.txt', @options=' -T -c -t"|"'
*/
CREATE PROCEDURE runExportToFile(@datasource text, @file_target text, @options text = ' -T -c -t;') AS
BEGIN
	exec dbo.enable_xp_cmdshell
	select dbo.exportToFile(@datasource, @file_target, @options)
	exec dbo.disable_xp_cmdshell	
	RETURN
END
go
