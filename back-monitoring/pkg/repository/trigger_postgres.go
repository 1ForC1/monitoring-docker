package repository

import (
	"back-monitoring/model"
	"database/sql"
	"fmt"
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
		err := row.Scan(&trigger.TriggerId, &trigger.TriggersExpression, &trigger.Description, &trigger.Priority, &trigger.IdHost)
		if err != nil {
			return nil, err
		}

		lists = append(lists, trigger)
	}

	return lists, err
}
