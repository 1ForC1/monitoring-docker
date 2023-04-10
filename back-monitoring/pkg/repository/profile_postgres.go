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

	query := fmt.Sprintf("SELECT Surname, Name, Patronymic, Login FROM %s WHERE LOGIN='%s'", usersTable, login)
	row := r.db.QueryRow(query)

	if err := row.Scan(&profile.Surname, &profile.Name, &profile.Patronymic, &profile.Login); err != nil {
		//logrus.Error(err.Error())
	}

	return profile, err
}
