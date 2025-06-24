-- Projeto Físico - Minimundo Albergue
-- Script de criação das tabelas
-- teste
-- Tabela de Clientes
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    documento VARCHAR(30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Quartos
CREATE TABLE quartos (
    quarto_id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) NOT NULL UNIQUE,
    capacidade INT NOT NULL,
    banheiro ENUM('S','N') NOT NULL,
    observacoes VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Vagas
CREATE TABLE vagas (
    vaga_id INT AUTO_INCREMENT PRIMARY KEY,
    quarto_id INT NOT NULL,
    observacoes VARCHAR(255),
    FOREIGN KEY (quarto_id) REFERENCES quartos(quarto_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de CaracteristicasVaga
CREATE TABLE caracteristicas_vaga (
    caracteristica_id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_cama ENUM('beliche','solteiro') NOT NULL,
    posicao_cama ENUM('superior','inferior','unica') NOT NULL,
    perto_porta ENUM('S','N') NOT NULL,
    perto_janela ENUM('S','N') NOT NULL,
    sol_manha ENUM('S','N') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de ligação entre Vaga e CaracteristicasVaga
CREATE TABLE vaga_caracteristica (
    vaga_id INT NOT NULL,
    caracteristica_id INT NOT NULL,
    PRIMARY KEY (vaga_id, caracteristica_id),
    FOREIGN KEY (vaga_id) REFERENCES vagas(vaga_id) ON DELETE CASCADE,
    FOREIGN KEY (caracteristica_id) REFERENCES caracteristicas_vaga(caracteristica_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Reservas
CREATE TABLE reservas (
    reserva_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    data_reserva DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status ENUM('ativa','cancelada','concluida') NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de ReservaVaga (N:N)
CREATE TABLE reserva_vaga (
    reserva_id INT NOT NULL,
    vaga_id INT NOT NULL,
    PRIMARY KEY (reserva_id, vaga_id),
    FOREIGN KEY (reserva_id) REFERENCES reservas(reserva_id) ON DELETE CASCADE,
    FOREIGN KEY (vaga_id) REFERENCES vagas(vaga_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Pagamentos
CREATE TABLE pagamentos (
    pagamento_id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL UNIQUE,
    valor_pago DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status_pagamento ENUM('processado','cancelado') NOT NULL,
    cartao_final VARCHAR(4),
    FOREIGN KEY (reserva_id) REFERENCES reservas(reserva_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- SCRIPTS DE MANIPULAÇÃO E CONSULTA

-- CLIENTES
INSERT INTO clientes (nome, email, telefone, documento) VALUES ('Nome Exemplo', 'email@exemplo.com', '21999999999', '123456789');
UPDATE clientes SET nome = 'Novo Nome' WHERE cliente_id = 1;
DELETE FROM clientes WHERE cliente_id = 1;
SELECT * FROM clientes;
SELECT * FROM clientes WHERE cliente_id = 1;

-- QUARTOS
INSERT INTO quartos (numero, capacidade, banheiro, observacoes) VALUES ('101', 4, 'S', 'Quarto com banheiro');
UPDATE quartos SET capacidade = 8 WHERE quarto_id = 1;
DELETE FROM quartos WHERE quarto_id = 1;
SELECT * FROM quartos;
SELECT * FROM quartos WHERE quarto_id = 1;

-- VAGAS
-- Exemplo de inserção de vaga e características
INSERT INTO vagas (quarto_id, observacoes) VALUES (1, 'Perto da janela');
INSERT INTO caracteristicas_vaga (tipo_cama, posicao_cama, perto_porta, perto_janela, sol_manha) VALUES ('beliche', 'superior', 'S', 'N', 'S');
INSERT INTO vaga_caracteristica (vaga_id, caracteristica_id) VALUES (1, 1);
UPDATE vagas SET tipo_cama = 'solteiro' WHERE vaga_id = 1;
DELETE FROM vagas WHERE vaga_id = 1;
SELECT * FROM vagas;
SELECT * FROM vagas WHERE vaga_id = 1;

-- RESERVAS
INSERT INTO reservas (cliente_id, data_inicio, data_fim, status, valor_total) VALUES (1, '2025-07-01 12:00:00', '2025-07-05 12:00:00', 'ativa', 500.00);
UPDATE reservas SET status = 'cancelada' WHERE reserva_id = 1;
DELETE FROM reservas WHERE reserva_id = 1;
SELECT * FROM reservas;
SELECT * FROM reservas WHERE reserva_id = 1;

-- RESERVA_VAGA
INSERT INTO reserva_vaga (reserva_id, vaga_id) VALUES (1, 1);
DELETE FROM reserva_vaga WHERE reserva_id = 1 AND vaga_id = 1;
SELECT * FROM reserva_vaga;
SELECT * FROM reserva_vaga WHERE reserva_id = 1 AND vaga_id = 1;

-- PAGAMENTOS
INSERT INTO pagamentos (reserva_id, valor_pago, status_pagamento, cartao_final) VALUES (1, 500.00, 'processado', '1234');
UPDATE pagamentos SET status_pagamento = 'cancelado' WHERE pagamento_id = 1;
DELETE FROM pagamentos WHERE pagamento_id = 1;
SELECT * FROM pagamentos;
SELECT * FROM pagamentos WHERE pagamento_id = 1;

-- CONSULTA DE VAGAS DISPONÍVEIS EM UM DETERMINADO DIA
-- Substitua '2025-07-02 12:00:00' pela data desejada
SELECT v.*
FROM vagas v
JOIN quartos q ON v.quarto_id = q.quarto_id
WHERE v.vaga_id NOT IN (
    SELECT rv.vaga_id
    FROM reserva_vaga rv
    JOIN reservas r ON rv.reserva_id = r.reserva_id
    WHERE r.status = 'ativa'
      AND (
        '2025-07-02 12:00:00' < r.data_fim AND '2025-07-02 12:00:00' >= r.data_inicio
      )
);

-- CONSULTA DE CAMAS JÁ RESERVADAS EM UM DETERMINADO DIA
SELECT v.*
FROM vagas v
JOIN reserva_vaga rv ON v.vaga_id = rv.vaga_id
JOIN reservas r ON rv.reserva_id = r.reserva_id
WHERE r.status = 'ativa'
  AND ('2025-07-02 12:00:00' < r.data_fim AND '2025-07-02 12:00:00' >= r.data_inicio);
