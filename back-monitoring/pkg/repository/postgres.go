package repository

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq"
)

const (
	usersTable = "\"User\""
	hostsTable = "host"
)

type ConfigStruct struct {
	HostDB     string
	PortDB     int
	UserDB     string
	PasswordDB string
	DBName     string
}

var db *sql.DB
var err error

// DBConnect Метод подключения к БД
func DBConnect(cfg ConfigStruct) (*sql.DB, error) {
	//Строка подключения
	psqlconn := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", cfg.HostDB, cfg.PortDB, cfg.UserDB, cfg.PasswordDB, cfg.DBName)
	//Подключение к БД
	db, err = sql.Open("postgres", psqlconn)
	if err != nil {
		//errorHelper.PrintError(strings.ReplaceAll(err.Error(), "pq: ", ""))
		return nil, err
	}
	//defer db.Close()

	//Пинг БД
	err = db.Ping()
	if err != nil {
		return nil, err
		//errorHelper.PrintError(strings.ReplaceAll(err.Error(), "pq: ", ""))
	}
	return db, nil
}
