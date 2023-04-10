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

type Trigger interface {
	GetAll() ([]model.Trigger, error)
}

type Profile interface {
	GetProfile(login string) (model.User, error)
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
}

func NewService(repos *repository.Repository) *Service {
	return &Service{
		Authorization: NewAuthService(repos.Authorization),
		Host:          NewHostService(repos.Host),
		Profile:       NewProfileService(repos.Profile),
		HostInfo:      NewHostInfoService(repos.HostInfo),
		Trigger:       NewTriggerService(repos.Trigger),
	}
}
