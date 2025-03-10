CREATE DATABASE faculdade;

CREATE TABLE IF NOT EXISTS faculdade.alunos (
  id_alunos int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  matricula int(11) NOT NULL,
  nome varchar(50) NOT NULL,
  email varchar(50) NOT NULL,
  cpf varchar(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS faculdade.disciplinas (
  id_disciplinas int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  sigla varchar(5) NOT NULL,
  nome varchar(30) NOT NULL,
  cargaHoraria int(11) NOT NULL,
  periodo smallint(6) NOT NULL,
  limiteFalta int(11) NOT NULL
) 
