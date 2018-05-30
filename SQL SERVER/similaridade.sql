/*
	FUNÇÃO PARA CALCULO DE SIMILARIDADE DE STRINGS

	@param:
	@param:
	@param:
	@param:

	EXEMPLOS DE USO:
		- select dbo.simfunc('sistemas', 'sistema', 2, 1)
		BEGIN
			declare @similaridade float
			exec @similaridade = simfunc @s1='sistemas de informação', @s2='sistema de informação', @q=3, @simFunc=1
			select @similaridade as similaridade
		END

*/
CREATE FUNCTION simfunc(@s1 varchar(100),  @s2 varchar(100), @q integer, @simFunc integer)
  RETURNS FLOAT AS
BEGIN
	DECLARE
		@s1_card integer = len(@s1) + @q - 1,
		@s2_card integer = len(@s2) + @q - 1,
		@overlap integer = 0,
		@count integer = 1,
		@sim float = 0;
		Declare @array_s1 as table(token char(3));
		Declare @array_s2 as table(token char(3));
		Declare @array_over table(token char(3))

	WHILE @count < (@q-1)
	BEGIN
	   set @s1 = CONCAT(CONCAT('*',@s1), '*')
	   set @s2 = CONCAT(CONCAT('*',@s2), '*')
	   SET @count = @count + 1;
	END

	SET @count = 1;
	WHILE @count <= (@s1_card)
	BEGIN
		Insert into @array_s1 values (SUBSTRING(@s1, @count, @q))
		SET @count = @count + 1;
	END

	SET @count = 1;
	WHILE @count <= (@s2_card)
	BEGIN
		Insert into @array_s2 values (SUBSTRING(@s2, @count, @q))
		SET @count = @count + 1;
	END

	insert @array_over select token from @array_s1 intersect select token from @array_s2

	set @overlap = (select COUNT(*) from @array_over)
	
	if (@simFunc = 1)
	begin
		set @sim = cast(@overlap as float)/(@s1_card + @s2_card - @overlap);
	end
	
	else if (@simFunc = 2)
	begin
		set @sim = (cast(2 as float) * @overlap)/(@s1_card + @s2_card);
	end
	else if (@simFunc = 3)
	begin
		set @sim = cast(@overlap as float)/sqrt(@s1_card * @s2_card);
	end
	else
	begin
		set @sim = cast(@overlap as float)/(@s1_card + @s2_card - @overlap);
	end
	RETURN @sim;
END;
GO
