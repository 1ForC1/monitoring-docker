package repository

import (
	"back-monitoring/model"
	"database/sql"
	"fmt"
)

type ProfilePostgres struct {
	db *sql.DB
}

func NewProfilePostgres(db *sql.DB) *ProfilePostgres {
	return &ProfilePostgres{db: db}
}

func (r *ProfilePostgres) GetProfile(login string) (model.User, error) {
	var profile model.User

	query := fmt.Sprintf("SELECT Surname, Name, Patronymic, Login, \"CanDeleteUsers\", \"CanViewHosts\", \"CanViewLog\" FROM %s WHERE LOGIN='%s'", usersTable, login)
	row := r.db.QueryRow(query)

	err := row.Scan(&profile.Surname, &profile.Name, &profile.Patronymic, &profile.Login, &profile.CanDeleteUsers, &profile.CanViewHosts, &profile.CanViewLog)

	return profile, err
}
