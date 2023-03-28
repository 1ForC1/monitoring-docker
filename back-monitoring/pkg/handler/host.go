package handler

import (
	"back-monitoring/model"
	"github.com/gin-gonic/gin"
	"net/http"
)

type getAllHostsResponse struct {
	Data []model.Host `json:"data"`
}

func (h *Handler) getAllHosts(c *gin.Context) {
	hosts, err := h.services.Host.GetAll()
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, getAllHostsResponse{Data: hosts})
}
