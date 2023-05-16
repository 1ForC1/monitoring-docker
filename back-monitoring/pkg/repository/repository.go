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

type User interface {
	GetAll() ([]model.User, error)
}

type Trigger interface {
	GetAll() ([]model.Trigger, error)
}

type Profile interface {
	GetProfile(login string) (model.User, error)
}

type DeleteUser interface {
	DeleteUser(login string) (model.User, error)
}

type UpdateUser interface {
	UpdateUser(model.User) (model.User, error)
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
	User
	DeleteUser
	UpdateUser
}

func NewRepository(db *sql.DB) *Repository {
	return &Repository{
		Authorization: NewAuthPostgres(db),
		Host:          NewHostPostgres(db),
		Profile:       NewProfilePostgres(db),
		HostInfo:      NewHostInfoPostgres(db),
		Trigger:       NewTriggerPostgres(db),
		User:          NewUserPostgres(db),
		DeleteUser:    NewDeleteUserPostgres(db),
		UpdateUser:    NewUpdateUserPostgres(db),
	}
}
