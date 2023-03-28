package repository

import (
	"back-monitoring/model"
	"database/sql"
	"fmt"
	"github.com/lib/pq"
	"github.com/sirupsen/logrus"
)

type HostPostgres struct {
	db *sql.DB
}

func NewHostPostgres(db *sql.DB) *HostPostgres {
	return &HostPostgres{db: db}
}

func (r *HostPostgres) GetAll() ([]model.Host, error) {
	var lists []model.Host
	var host model.Host

	query := fmt.Sprintf("SELECT * FROM %s", hostsTable)
	row, err := r.db.Query(query)

	for row.Next() {
		if err := row.Scan(&host.IdHost, &host.HostName, pq.Array(&host.HostInterfaces)); err != nil {
			logrus.Fatal(err.Error())
		}
		lists = append(lists, host)
	}

	return lists, err
}
