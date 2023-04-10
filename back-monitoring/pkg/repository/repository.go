package repository

import (
	"back-monitoring/model"
	"database/sql"
)

type Authorization interface {
	CreateUser(user model.User) (int, error)
	GetUser(login, password string) (model.User, error)
}

type Host interface {
	GetAll() ([]model.Host, error)
}

type Trigger interface {
	GetAll() ([]model.Trigger, error)
}

type Profile interface {
	GetProfile(login string) (model.User, error)
}

type HostInfo interface {
	GetHostInfo(hostid int) (model.HostInfo, error)
}

type Repository struct {
	Authorization
	Host
	Profile
	HostInfo
	Trigger
}

func NewRepository(db *sql.DB) *Repository {
	return &Repository{
		Authorization: NewAuthPostgres(db),
		Host:          NewHostPostgres(db),
		Profile:       NewProfilePostgres(db),
		HostInfo:      NewHostInfoPostgres(db),
		Trigger:       NewTriggerPostgres(db),
	}
}
