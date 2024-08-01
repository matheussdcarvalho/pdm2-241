from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

app = FastAPI()

# Criar banco de dados SQLITE3
engine = create_engine('sqlite:///dbalunos.db')
Base = declarative_base()

# Definir entidade Aluno
class Aluno(Base):
    __tablename__ = 'TB_ALUNO'
    id = Column(Integer, primary_key=True, autoincrement=True)
    aluno_nome = Column(String(50))
    endereco = Column(String(100))

# Criar tabela TB_ALUNO
Base.metadata.create_all(engine)

# Criar sessão do banco de dados
Session = sessionmaker(bind=engine)
session = Session()

# Definir modelo de dados para o endpoint
class AlunoModel(BaseModel):
    id: int
    aluno_nome: str
    endereco: str

# Endpoint para criar aluno
@app.post("/criar_aluno")
async def criar_aluno(aluno: AlunoModel):
    novo_aluno = Aluno(aluno_nome=aluno.aluno_nome, endereco=aluno.endereco)
    session.add(novo_aluno)
    session.commit()
    return {"mensagem": "Aluno criado com sucesso"}

# Endpoint para listar todos os alunos
@app.get("/listar_alunos")
async def listar_alunos():
    alunos = session.query(Aluno).all()
    return [{"id": aluno.id, "aluno_nome": aluno.aluno_nome, "endereco": aluno.endereco} for aluno in alunos]

# Endpoint para listar um aluno por ID
@app.get("/listar_um_aluno/{id}")
async def listar_um_aluno(id: int):
    aluno = session.query(Aluno).filter_by(id=id).first()
    if aluno is None:
        raise HTTPException(status_code=404, detail="Aluno não encontrado")
    return {"id": aluno.id, "aluno_nome": aluno.aluno_nome, "endereco": aluno.endereco}

# Endpoint para atualizar aluno
@app.put("/atualizar_aluno/{id}")
async def atualizar_aluno(id: int, aluno: AlunoModel):
    aluno_atual = session.query(Aluno).filter_by(id=id).first()
    if aluno_atual is None:
        raise HTTPException(status_code=404, detail="Aluno não encontrado")
    aluno_atual.aluno_nome = aluno.aluno_nome
    aluno_atual.endereco = aluno.endereco
    session.commit()
    return {"mensagem": "Aluno atualizado com sucesso"}

# Endpoint para excluir aluno
@app.delete("/excluir_aluno/{id}")
async def excluir_aluno(id: int):
    aluno_atual = session.query(Aluno).filter_by(id=id).first()
    if aluno_atual is None:
        raise HTTPException(status_code=404, detail="Aluno não encontrado")
    session.delete(aluno_atual)
    session.commit()
    return {"mensagem": "Aluno excluído com sucesso"}