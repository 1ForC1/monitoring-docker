package service

import (
	"back-monitoring/model"
	"back-monitoring/pkg/repository"
)

type HostInfoService struct {
	repo repository.HostInfo
}

func NewHostInfoService(repo repository.HostInfo) *HostInfoService {
	return &HostInfoService{repo: repo}
}

func (s *HostInfoService) GetHostInfo(hostid int) (model.HostInfo, error) {
	return s.repo.GetHostInfo(hostid)
}
