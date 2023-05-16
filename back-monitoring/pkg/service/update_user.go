package service

import (
	"back-monitoring/model"
	"back-monitoring/pkg/repository"
)

type UpdateUserService struct {
	repo repository.UpdateUser
}

func NewUpdateUserService(repo repository.UpdateUser) *UpdateUserService {
	return &UpdateUserService{repo: repo}
}

func (s *UpdateUserService) UpdateUser(user model.User) (model.User, error) {
	user.Password = generatePasswordHash(user.Password)
	return s.repo.UpdateUser(user)
}
