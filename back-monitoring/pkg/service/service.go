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

type Service struct {
	Authorization
	Host
}

func NewService(repos *repository.Repository) *Service {
	return &Service{
		Authorization: NewAuthService(repos.Authorization),
		Host:          NewHostService(repos.Host),
	}
}
