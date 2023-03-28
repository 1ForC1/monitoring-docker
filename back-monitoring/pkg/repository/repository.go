package repository

import (
	"back-monitoring/model"
	"database/sql"
)

type Authorization interface {
	CreateUser(user model.User) (int, error)
	GetUser(login, password string) (model.User, error)
}

type Host interface {
	GetAll() ([]model.Host, error)
}

type Repository struct {
	Authorization
	Host
}

func NewRepository(db *sql.DB) *Repository {
	return &Repository{
		Authorization: NewAuthPostgres(db),
		Host:          NewHostPostgres(db),
	}
}
