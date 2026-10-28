CREATE TABLE IF NOT EXISTS clube (
    nome            VARCHAR(20) PRIMARY KEY,
    total_partidas  INTEGER NOT NULL DEFAULT 0 CHECK (total_partidas >= 0),
    vitorias        INTEGER NOT NULL DEFAULT 0 CHECK (vitorias >= 0),
    empates         INTEGER NOT NULL DEFAULT 0 CHECK (empates >= 0),
    derrotas        INTEGER NOT NULL DEFAULT 0 CHECK (derrotas >= 0),
    gols_marcados   INTEGER NOT NULL DEFAULT 0 CHECK (gols_marcados >= 0),
    gols_sofridos   INTEGER NOT NULL DEFAULT 0 CHECK (gols_sofridos >= 0)
);

CREATE TABLE IF NOT EXISTS atleta (
    nome                    VARCHAR(50) NOT NULL,
    clube_nome               VARCHAR(20) NOT NULL
                            REFERENCES clube (nome)
                            ON UPDATE CASCADE
                            ON DELETE CASCADE,
    nacionalidade           VARCHAR(3),
    setor                   TEXT[] NOT NULL DEFAULT '{}'
                            CHECK (setor <@ ARRAY['GK', 'DF', 'MF', 'FW']),
    partidas_jogadas        NUMERIC(3, 1) NOT NULL DEFAULT 0 CHECK (partidas_jogadas >= 0),
    cartao_amarelo          INTEGER NOT NULL DEFAULT 0 CHECK (cartao_amarelo >= 0),
    segundo_cartao_amarelo  INTEGER NOT NULL DEFAULT 0 CHECK (segundo_cartao_amarelo >= 0),
    cartao_vermelho         INTEGER NOT NULL DEFAULT 0 CHECK (cartao_vermelho >= 0),
    PRIMARY KEY (nome, clube_nome)
);

CREATE INDEX IF NOT EXISTS idx_atleta_clube_nome ON atleta (clube_nome);

CREATE TABLE IF NOT EXISTS goleiro (
    atleta_nome             VARCHAR(50) NOT NULL,
    clube_nome               VARCHAR(20) NOT NULL,
    defesas                 INTEGER NOT NULL DEFAULT 0 CHECK (defesas >= 0),
    gols_sofridos           INTEGER NOT NULL DEFAULT 0 CHECK (gols_sofridos >= 0),
    porcentagem_defesa      NUMERIC(4, 1) NOT NULL DEFAULT 0
                            CHECK (porcentagem_defesa BETWEEN 0 AND 100),
    jogos_sem_sofrer_gols   INTEGER NOT NULL DEFAULT 0 CHECK (jogos_sem_sofrer_gols >= 0),
    chutes_sofridos         INTEGER NOT NULL DEFAULT 0 CHECK (chutes_sofridos >= 0),
    PRIMARY KEY (atleta_nome, clube_nome),
    FOREIGN KEY (atleta_nome, clube_nome)
        REFERENCES atleta (nome, clube_nome)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS linha (
    atleta_nome     VARCHAR(50) NOT NULL,
    clube_nome       VARCHAR(20) NOT NULL,
    gols            INTEGER NOT NULL DEFAULT 0 CHECK (gols >= 0),
    assistencias    INTEGER NOT NULL DEFAULT 0 CHECK (assistencias >= 0),
    chutes          INTEGER NOT NULL DEFAULT 0 CHECK (chutes >= 0),
    chutes_no_gol   INTEGER NOT NULL DEFAULT 0 CHECK (chutes_no_gol >= 0),
    desarmes        INTEGER NOT NULL DEFAULT 0 CHECK (desarmes >= 0),
    cruzamentos     INTEGER NOT NULL DEFAULT 0 CHECK (cruzamentos >= 0),
    PRIMARY KEY (atleta_nome, clube_nome),
    FOREIGN KEY (atleta_nome, clube_nome)
        REFERENCES atleta (nome, clube_nome)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_linha_chutes_no_gol CHECK (chutes_no_gol <= chutes)
);
