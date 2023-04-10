package repository

import (
	"back-monitoring/model"
	"database/sql"
	"fmt"
	"github.com/sirupsen/logrus"
)

type TriggerPostgres struct {
	db *sql.DB
}

func NewTriggerPostgres(db *sql.DB) *TriggerPostgres {
	return &TriggerPostgres{db: db}
}

func (r *TriggerPostgres) GetAll() ([]model.Trigger, error) {
	var lists []model.Trigger
	var trigger model.Trigger

	query := fmt.Sprintf("SELECT * FROM %s", triggersTable)
	row, err := r.db.Query(query)

	for row.Next() {
		if err := row.Scan(&trigger.TriggerId, &trigger.TriggersExpression, &trigger.Description, &trigger.Priority, &trigger.IdHost); err != nil {
			logrus.Fatal(err.Error())
		}
		lists = append(lists, trigger)
	}

	return lists, err
}
