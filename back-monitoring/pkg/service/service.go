package service

import (
	"back-monitoring/model"
	"back-monitoring/pkg/repository"
)

type Authorization interface {
	CreateUser(user model.User) (int, error)
	GenerateToken(login, password string) (string, error)
	ParseToken(token string) (int, error)
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
	UpdateUser(user model.User) (model.User, error)
}

type HostInfo interface {
	GetHostInfo(hostid int) (model.HostInfo, error)
}

type Service struct {
	Authorization
	Host
	Profile
	HostInfo
	Trigger
	User
	DeleteUser
	UpdateUser
}

func NewService(repos *repository.Repository) *Service {
	return &Service{
		Authorization: NewAuthService(repos.Authorization),
		Host:          NewHostService(repos.Host),
		Profile:       NewProfileService(repos.Profile),
		HostInfo:      NewHostInfoService(repos.HostInfo),
		Trigger:       NewTriggerService(repos.Trigger),
		User:          NewUserService(repos.User),
		DeleteUser:    NewDeleteUserService(repos.DeleteUser),
		UpdateUser:    NewUpdateUserService(repos.UpdateUser),
	}
}
