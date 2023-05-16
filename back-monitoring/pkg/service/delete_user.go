package service

import (
	"back-monitoring/model"
	"back-monitoring/pkg/repository"
)

type DeleteUserService struct {
	repo repository.DeleteUser
}

func NewDeleteUserService(repo repository.DeleteUser) *DeleteUserService {
	return &DeleteUserService{repo: repo}
}

func (s *DeleteUserService) DeleteUser(login string) (model.User, error) {
	return s.repo.DeleteUser(login)
}
