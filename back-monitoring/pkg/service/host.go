package service

import (
	"back-monitoring/model"
	"back-monitoring/pkg/repository"
)

type HostService struct {
	repo repository.Host
}

func NewHostService(repo repository.Host) *HostService {
	return &HostService{repo: repo}
}

func (s *HostService) GetAll() ([]model.Host, error) {
	return s.repo.GetAll()
}
