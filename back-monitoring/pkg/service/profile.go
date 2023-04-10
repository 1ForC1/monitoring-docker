package service

import (
	"back-monitoring/model"
	"back-monitoring/pkg/repository"
)

type ProfileService struct {
	repo repository.Profile
}

func NewProfileService(repo repository.Profile) *ProfileService {
	return &ProfileService{repo: repo}
}

func (s *ProfileService) GetProfile(login string) (model.User, error) {
	return s.repo.GetProfile(login)
}
