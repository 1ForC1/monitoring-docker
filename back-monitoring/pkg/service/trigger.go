package service

import (
	"back-monitoring/model"
	"back-monitoring/pkg/repository"
)

type TriggerService struct {
	repo repository.Trigger
}

func NewTriggerService(repo repository.Trigger) *TriggerService {
	return &TriggerService{repo: repo}
}

func (s *TriggerService) GetAll() ([]model.Trigger, error) {
	return s.repo.GetAll()
}
