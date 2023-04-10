package model

import "database/sql"

type Trigger struct {
	TriggerId          int            `json:"triggerid" db:"triggerid"`
	TriggersExpression sql.NullString `json:"triggers_expression" db:"triggers_expression"`
	Description        sql.NullString `json:"description" db:"description"`
	Priority           sql.NullString `json:"priority" db:"priority"`
	IdHost             int            `json:"id_host" db:"hostid"`
}
