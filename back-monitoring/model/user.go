package model

type User struct {
	Id         int    `json:"-" db:"id"`
	Surname    string `json:"surname" binding:"required"`
	Name       string `json:"name" binding:"required"`
	Patronymic string `json:"patronymic"`
	Login      string `json:"login" binding:"required"`
	Password   string `json:"password" binding:"required"`
}
