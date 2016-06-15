package main

import (
	// "fmt"
	"github.com/gin-gonic/gin"
	"math/rand"
	"net/http"
	"strconv"
	"strings"
	"time"
)

func main() {

	router := gin.Default()

	router.GET("/someJSON", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "hey", "status": http.StatusOK})
	})

	router.GET("/moreJSON", func(c *gin.Context) {
		// You also can use a struct
		var msg struct {
			Id   int    `json:"Id"`
			Name string `json:"name"`
			City string `json:"city"`
		}
		msg.Name = "Lena"
		msg.Id = 10
		msg.City = "北京"
		// Note that msg.Name becomes "user" in the JSON
		// Will output  :   {"user": "Lena", "Message": "hey", "Number": 123}
		c.JSON(http.StatusOK, msg)
	})

	type Login struct {
		User     string `form:"user" json:"user" binding:"required"`
		Password string `form:"password" json:"password" binding:"required"`
	}
	router.POST("/loginJSON", func(c *gin.Context) {
		var json Login
		if c.BindJSON(&json) == nil {
			if json.User == "manu" && json.Password == "123" {
				c.JSON(http.StatusOK, gin.H{"status": "you are logged in"})
			} else {
				c.JSON(http.StatusUnauthorized, gin.H{"status": "unauthorized"})
			}
		}
	})

	router.GET("/api/contacts/refresh", func(c *gin.Context) {
		type Msg struct {
			FirstName   string `json:"firstName"`
			LastName    string `json:"lastName"`
			PhoneNumber string `json:"phoneNumber"`
		}
		pageNumber := 20
		var msgArray []Msg
		for i := 0; i < pageNumber; i++ {
			var msg Msg
			msg.FirstName = getRandomCharacters(3)
			msg.LastName = getRandomCharacters(5)
			msg.PhoneNumber = getRandomNumbers(11)
			msgArray = append(msgArray, msg)
		}

		c.JSON(http.StatusOK, msgArray)
	})

	router.Run(":10001")
}

func getRandomCharacters(length int) string {
	rand.Seed(time.Now().UnixNano())
	rs := make([]string, length)
	for i := 0; i < length; i++ {
		rs = append(rs, string(rand.Intn(26)+97))
	}
	return strings.Join(rs, "")
}

func getRandomNumbers(length int) string {
	rand.Seed(time.Now().UnixNano())
	rs := make([]string, length)
	for i := 0; i < length; i++ {
		rs = append(rs, strconv.Itoa(rand.Intn(10)))
	}
	return strings.Join(rs, "")
}
