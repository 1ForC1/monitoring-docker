package repository

import (
	"back-monitoring/model"
	"database/sql"
	"fmt"
)

type DeleteUserPostgres struct {
	db *sql.DB
}

func NewDeleteUserPostgres(db *sql.DB) *DeleteUserPostgres {
	return &DeleteUserPostgres{db: db}
}

func (r *DeleteUserPostgres) DeleteUser(login string) (model.User, error) {
	var deletedUser model.User

	query := fmt.Sprintf("SELECT Surname, Name, Patronymic, Login FROM %s WHERE LOGIN='%s'; DELETE FROM %s WHERE LOGIN='%s'", usersTable, login, usersTable, login)
	row := r.db.QueryRow(query)

	err := row.Scan(&deletedUser.Surname, &deletedUser.Name, &deletedUser.Patronymic, &deletedUser.Login)

	return deletedUser, err
}
