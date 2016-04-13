package main

import (
	// "fmt"
	"github.com/gin-gonic/gin"
	"net/http"
)

func main(){
	
	router := gin.Default()

	router.GET("/someJSON", func(c *gin.Context){
		c.JSON(http.StatusOK, gin.H{"message": "hey", "status": http.StatusOK})
		})

	router.GET("/moreJSON", func(c *gin.Context) {
        // You also can use a struct
        var msg struct {
            Id    int    `json:"Id"`
            Name  string `json:"name"`
            City  string `json:"city"`
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
    router.POST("/loginJSON", func(c *gin.Context){
    	var json Login
    	if c.BindJSON(&json) == nil{
    		if json.User == "manu" && json.Password == "123"{
    			c.JSON(http.StatusOK, gin.H{"status": "you are logged in"})
    		}else{
    			c.JSON(http.StatusUnauthorized, gin.H{"status": "unauthorized"})
    		}
    	}
    })
	router.Run(":10001")
}
