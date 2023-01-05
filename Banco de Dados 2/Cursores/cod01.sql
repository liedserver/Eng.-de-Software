BEGIN TRANSACTION;
	    DECLARE
		 @num_inscricao NUMERIC(11,0),
         @inscritoscidade VARCHAR(120),
         @inscritosuf VARCHAR(120)
   
   --01)PECORRENDO OS REGISTROS
    DECLARE [cur_inscritos_cidadeuf] CURSOR FOR
        SELECT
            [num_inscricao],
            [cidade],
            [uf]
        FROM
            [INSCRITOS]

    -- 02) ABRINDO O CURSOR
    OPEN [cur_inscritos_cidadeuf]

    -- 03) PECORRENDO A PROXIMA LINHA
    FETCH NEXT FROM
        [cur_inscritos_cidadeuf]
    INTO
        @num_inscricao,
        @inscritoscidade,
        @inscritosuf

    -- 04) PECORRER LINHAS DO CURSOR
    WHILE @@FETCH_STATUS = 0
    BEGIN

        -- 05) EXECUTAR ROTINAS DO REGISTRO
        UPDATE [INSCRITOS]
            SET [cidade] = TRIM(@inscritoscidade) + '/' + @inscritosuf
        WHERE
            [num_inscricao] = @num_inscricao
        
        -- 06) LER O PROXIMO REGISTRO
        FETCH NEXT FROM [cur_inscritos_cidadeuf] INTO @num_inscricao, @inscritoscidade, @inscritosuf
    END

    -- 07) ENCERRA A LEITURA DO CURSOR
    CLOSE [cur_inscritos_cidadeuf]

    -- 08) FINALIZA O CURSOR
    DEALLOCATE [cur_inscritos_cidadeuf]

ROLLBACK

--09) VENDO AS ALTERAÇÕES DO CURSOR
SELECT
    [num_inscricao],
    [cidade],
    [uf]
FROM [INSCRITOS]

-- 10) APAGANDO TABELA INUTIL UF
ALTER TABLE [INSCRITOS]
    DROP COLUMN [uf]
GO

-- 11) VENDO AS ALTERAÇÕES DO CURSOR DEPOIS DE APAGAR A TABELA UF
SELECT
    [num_inscricao],
    [cidade]
FROM [INSCRITOS]
