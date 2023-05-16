package repository

import (
	"back-monitoring/model"
	"database/sql"
	"fmt"
)

type UpdateUserPostgres struct {
	db *sql.DB
}

func NewUpdateUserPostgres(db *sql.DB) *UpdateUserPostgres {
	return &UpdateUserPostgres{db: db}
}

func (r *UpdateUserPostgres) UpdateUser(updatedUser model.User) (model.User, error) {
	var query string
	if updatedUser.Password == "" {
		query = fmt.Sprintf("UPDATE %s SET surname='%s', name='%s', patronymic='%s', \"CanDeleteUsers\"='%v', \"CanViewHosts\"='%v', \"CanViewLog\"='%v' WHERE login='%s' RETURNING login",
			usersTable, updatedUser.Surname, updatedUser.Name, updatedUser.Patronymic, updatedUser.CanDeleteUsers, updatedUser.CanViewHosts, updatedUser.CanViewLog, updatedUser.Login)
	} else {
		query = fmt.Sprintf("UPDATE %s SET surname='%s', name='%s', patronymic='%s', password='%s', \"CanDeleteUsers\"='%v', \"CanViewHosts\"='%v', \"CanViewLog\"='%v' WHERE login='%s' RETURNING login",
			usersTable, updatedUser.Surname, updatedUser.Name, updatedUser.Patronymic, updatedUser.Password, updatedUser.CanDeleteUsers, updatedUser.CanViewHosts, updatedUser.CanViewLog, updatedUser.Login)
	}
	row := r.db.QueryRow(query)

	err := row.Scan(&updatedUser.Login)

	return updatedUser, err
}
