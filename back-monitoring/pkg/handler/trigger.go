package handler

import (
	"back-monitoring/model"
	"github.com/gin-gonic/gin"
	"net/http"
)

type getAllTriggersResponse struct {
	Data []model.Trigger `json:"data"`
}

func (h *Handler) getAllTriggers(c *gin.Context) {
	triggers, err := h.services.Trigger.GetAll()
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, getAllTriggersResponse{Data: triggers})
}
