package repository

import (
	"back-monitoring/model"
	"database/sql"
	"fmt"
)

type AuthPostgres struct {
	db *sql.DB
}

func NewAuthPostgres(db *sql.DB) *AuthPostgres {
	return &AuthPostgres{
		db: db,
	}
}

func (r *AuthPostgres) CreateUser(user model.User) (int, error) {
	var id int
	query := fmt.Sprintf("INSERT INTO %s (surname, name, patronymic, login, password) VALUES ('%s', '%s', '%s', '%s', '%s') RETURNING ID_USER",
		usersTable, user.Surname, user.Name, user.Patronymic, user.Login, user.Password)
	row := r.db.QueryRow(query)
	if err := row.Scan(&id); err != nil {
		return 0, err
	}
	return id, nil
}

func (r *AuthPostgres) GetUser(login, password string) (model.User, error) {
	var user model.User
	query := fmt.Sprintf("SELECT ID_USER FROM %s WHERE LOGIN='%s' AND PASSWORD='%s'", usersTable, login, password)
	row := r.db.QueryRow(query)
	err := row.Scan(&user.Id)
	return user, err
}
