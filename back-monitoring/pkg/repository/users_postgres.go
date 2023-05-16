package repository

import (
	"back-monitoring/model"
	"database/sql"
	"fmt"
)

type UserPostgres struct {
	db *sql.DB
}

func NewUserPostgres(db *sql.DB) *UserPostgres {
	return &UserPostgres{db: db}
}

func (r *UserPostgres) GetAll() ([]model.User, error) {
	var lists []model.User
	var user model.User

	query := fmt.Sprintf("SELECT * FROM %s", usersTable)
	row, err := r.db.Query(query)

	for row.Next() {
		err := row.Scan(&user.Id, &user.Surname, &user.Name, &user.Patronymic, &user.Login, &user.Password, &user.CanDeleteUsers, &user.CanViewHosts, &user.CanViewLog)
		if err != nil {
			return nil, err
		}

		lists = append(lists, user)
	}

	return lists, err
}
